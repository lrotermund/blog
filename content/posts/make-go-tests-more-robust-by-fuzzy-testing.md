---
title: "Make Go tests more robust by fuzzy testing"
date: 2021-03-07T23:43:34+01:00
draft: false
images: ["/assets/pexels-dương-nhân-1529881.jpg"]
tags: [go-standard-library, "development", "golang", "testing"]
description: "In this post, we'll look at how Go tests are built more robustly with the quick 
package and how we can avoid incorrectly chosen parameters."
---

Often when testing a function in Go tests only a few selected parameter combinations are used and in 
most cases this may fit. In this article we follow up on the last article in the series 
[Testing, an important feature of the Go standard library]({{< ref "/posts/testing-an-important-feature-of-the-go-standard-library.md" >}}) and look at why the classic test 
parameters are often not sufficient to respond to unknown input parameters.

{{< toc >}}

## The classic test and its disadvantages

When writing tests, the test parameters look similar for almost all developers, from "foo" to "John 
Doe" everything is represented and often only the obvious is tested. Let's pick up where we left off 
in the previous blog post and see what a classic test looks like. 

In the following example, there is a service that takes care of credit and debit entries, i.e. 
transactions, from bank accounts.

```golang
package transactions

import (
	"github.com/shopspring/decimal"
)

type (
	Transaction struct {
		Amount decimal.Decimal
		Type   TransactionType
	}
	GroupedTransactionsByType map[TransactionType][]Transaction
	TransactionType string
)

const (
	TransactionTypeCredit TransactionType = "CREDIT"
	TransactionTypeDebit  TransactionType = "DEBIT"
)

func GroupTransactionsByType(transactions []Transaction) GroupedTransactionsByType {
	transactionsByType := make(GroupedTransactionsByType)

	for _, t := range transactions {
		transactionsByType[t.Type] = append(transactionsByType[t.Type], t)
	}

	return transactionsByType
}
```

The transaction service provides the function `GroupTransactionsByType()` which groups a slice with 
transactions by the type of the transactions and returns the result as a map. Now let's create a 
test to ensure the intended function.

```golang
package transactions

import (
	"reflect"
	"testing"

	"github.com/shopspring/decimal"
)

func TestGroupTransactionsByType(t *testing.T) {
	credit1 := decimal.RequireFromString("42.99")
	credit2 := decimal.RequireFromString("321.00")
	debit1 := decimal.RequireFromString("-123.15")
	debit2 := decimal.RequireFromString("-1337.00")

	testCases := map[string]struct {
		givenTransactons []Transaction
		expectedGrouping GroupedTransactionsByType
	}{
		"Missing transactions result in an empty grouping": {
			givenTransactons: []Transaction{},
			expectedGrouping: make(GroupedTransactionsByType),
		},
		"If there are only credit notes, there are no debit notes in the grouping": {
			givenTransactons: []Transaction{
				{Amount: credit1, Type: TransactionTypeCredit},
				{Amount: credit2, Type: TransactionTypeCredit},
			},
			expectedGrouping: GroupedTransactionsByType{
				TransactionTypeCredit: []Transaction{
					{Amount: credit1, Type: TransactionTypeCredit},
					{Amount: credit2, Type: TransactionTypeCredit},
				},
			},
		},
		"If there are only debit notes, there are no credit notes in the grouping": {
			givenTransactons: []Transaction{
				{Amount: debit1, Type: TransactionTypeDebit},
				{Amount: debit2, Type: TransactionTypeDebit},
			},
			expectedGrouping: GroupedTransactionsByType{
				TransactionTypeDebit: []Transaction{
					{Amount: debit1, Type: TransactionTypeDebit},
					{Amount: debit2, Type: TransactionTypeDebit},
				},
			},
		},
		"If there are credit and debit notes, there are both in the grouping.": {
			givenTransactons: []Transaction{
				{Amount: credit1, Type: TransactionTypeCredit},
				{Amount: debit1, Type: TransactionTypeDebit},
				{Amount: credit2, Type: TransactionTypeCredit},
				{Amount: debit2, Type: TransactionTypeDebit},
			},
			expectedGrouping: GroupedTransactionsByType{
				TransactionTypeCredit: []Transaction{
					{Amount: credit1, Type: TransactionTypeCredit},
					{Amount: credit2, Type: TransactionTypeCredit},
				},
				TransactionTypeDebit: []Transaction{
					{Amount: debit1, Type: TransactionTypeDebit},
					{Amount: debit2, Type: TransactionTypeDebit},
				},
			},
		},
	}

	for title, tc := range testCases {
		t.Run(title, func(t *testing.T) {
			actual := GroupTransactionsByType(tc.givenTransactons)

			if !reflect.DeepEqual(tc.expectedGrouping, actual) {
				t.Errorf(
					"grouping transactions failed.\n\nexpected:\n%+v\n\ngot:\n%+v",
					tc.expectedGrouping,
					actual,
				)
			}
		})
	}
}
```
Before we run test, here's a quick shout out. In the service, as well as in the test, the 
[Decimal library](https://github.com/shopspring/decimal) was used to correctly represent the 
floating points of the money amounts, as these cannot be correctly represented by a float or a 
big.Rat in Go. Many thanks to Shopspring for this great library. 

The test contains several test cases that are run through one after the other and whose results are 
checked afterwards. Let's start the test and see if all test cases work.

```shell
$ go test
PASS
ok      github.com/lrotermund/quicktesting/pkg/transactions   0.001s
```

My assumption now could be that my function works the way I want it to and maybe I use the function 
in my code only with the tested values. Should I now be so convinced of my package that I make it 
available to others, the probability is very high that someone uses the function with other 
parameters and something fails. 

The function doesn't necessarily have to fail when it's used by others, often it's enough if project 
requirements change or code is changed in the course of refactoring, resulting in new cases not yet 
covered by my unit test. 

To circumvent these potential sources of errors and to avoid possible unknown test cases, the Go 
standard library provides the [package quick](https://golang.org/pkg/testing/quick/) in the 
subdirectory of the [testing package](https://golang.org/pkg/testing/). 

## Fuzzy testing with quick's Check() function

The function [Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) is one of the 
two functions of the [package quick](https://golang.org/pkg/testing/quick/) that allows fuzzy 
testing[^fuzz] with unspecified parameters. We will pimp our previous unit test with the 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function after the 
code analysis to make it more robust by not selecting the test parameters ourselves. 

```golang
func Check(f interface{}, config *Config) error {
	if config == nil {
		config = &defaultConfig
	}

	fVal, fType, ok := functionAndType(f)
	if !ok {
		return SetupError("argument is not a function")
	}

	if fType.NumOut() != 1 {
		return SetupError("function does not return one value")
	}
	if fType.Out(0).Kind() != reflect.Bool {
		return SetupError("function does not return a bool")
	}

	arguments := make([]reflect.Value, fType.NumIn())
	rand := config.getRand()
	maxCount := config.getMaxCount()

	for i := 0; i < maxCount; i++ {
		err := arbitraryValues(arguments, fType, config, rand)
		if err != nil {
			return err
		}

		if !fVal.Call(arguments)[0].Bool() {
			return &CheckError{i + 1, toInterfaces(arguments)}
		}
	}

	return nil
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253))

### Code analysis of the Check() function

Let's start with the parameters of the function. 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) first expects a parameter 
of the type `interface{}`. This empty interface type is one that doesn't need to provide any 
functions, and therefore any value can be passed since every type corresponds to this interface. If 
you want to know more about this I recommend you to have a look at the 
[Tour of Go about the empty interface](https://tour.golang.org/methods/14).

The second parameter is the pointer to the 
[Config struct](https://golang.org/src/testing/quick/quick.go?s=4954:5679#L167) and is used to 
configure the test. The struct has, for example, the "MaxCount" field, which can be used to set the 
maximum number of test iterations in which the function under test is tested with random parameters. 
The [Config](https://golang.org/src/testing/quick/quick.go?s=4954:5679#L167) struct has two getters 
that return values depending on the set fields, but more about that in the further analysis.

First, the function checks whether a configuration was passed. Since a pointer of the 
[Config](https://golang.org/src/testing/quick/quick.go?s=4954:5679#L167) struct is expected, nil can 
also be passed instead of the configuration. If this is the case, the parameter is overwritten with 
an empty default configuration.

In the next section of the function the passed value of the empty interface parameter "f" is checked 
for validity, because the parameter must be of type function. The check and the determination of the 
type is done by the function 
[functionAndType()](https://golang.org/src/testing/quick/quick.go?s=9855:10036#L350).

```golang
func functionAndType(f interface{}) (v reflect.Value, t reflect.Type, ok bool) {
	v = reflect.ValueOf(f)
	ok = v.Kind() == reflect.Func
	if !ok {
		return
	}
	t = v.Type()
	return
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=9855:10036#L350))

The check and determination of the type takes place here via the 
[reflect package](https://golang.org/pkg/reflect/). We haven't talked about this package yet, but we 
will in the future. If you already want to learn more about this topic, I can recommend the blog 
article [Laws of reflaction from golang.org](https://blog.golang.org/laws-of-reflection). For now, 
let's assume that this package finds out more about our empty interface and detects whether it is a 
function or something else.

First, the actual value of the interface is determined via 
[ValueOf](https://golang.org/src/reflect/value.go?s=70173:70206#L2337) and returned as 
[Value](https://golang.org/src/reflect/value.go?s=1328:2547#L27). 
[Value](https://golang.org/src/reflect/value.go?s=1328:2547#L27) now offers the possibility to find 
out more about the value. In the function it is checked what 
[Kind](https://golang.org/src/reflect/type.go?s=8409:8423#L220) the value is and whether this is a 
function.

The return values of the function are first the 
[value](https://golang.org/src/reflect/value.go?s=1328:2547#L27) of our empty interface, which in 
the best case is our passed-in function, then the type of the empty interface and finally an "ok" 
flag that informs whether our empty interface is a function, which is important to know for 
subsequent validation.

Back in the [Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function, the 
"ok" flag is now checked. If our empty interface is not a function, a setup error is returned to our 
test. 

The next step is the type validation, which is done via the 
[Type interface](https://golang.org/src/reflect/type.go?s=1335:7577#L28) of 
[reflect](https://golang.org/pkg/reflect/). First, it is ensured that exactly one return parameter 
is available, otherwise a setup error is returned again. Then it is checked whether the type of this 
return parameter is a Boolean, and if not, how could it be otherwise, a setup error is returned.

The next section is about the generation of random parameters and the test execution. Via 
`make([]reflect.Value, fType.NumIn())` an array is created whose capacity corresponds to the number 
of our parameters returned by `fType.NumIn()`. Directly afterwards, a random generator from the 
[package math](https://golang.org/pkg/math/) and the value for the maximum number of test runs are 
loaded via the passed configuration, or the default configuration.

[config.getRand()](https://golang.org/src/testing/quick/quick.go?s=5768:5808#L193) and 
[config.getMaxCount()](https://golang.org/src/testing/quick/quick.go?s=5992:6039#L193) both check if
the respective field of the configuration is set and if not, the default value of the field is 
returned.

The default value determined in 
[getRand()](https://golang.org/src/testing/quick/quick.go?s=5768:5808#L193) is a new random 
generator that uses a pseudo-random source with the seed of the current unix time in nanoseconds. 

```golang {hl_lines=[4]}
// getRand returns the *rand.Rand to use for a given Config.
func (c *Config) getRand() *rand.Rand {
	if c.Rand == nil {
		return rand.New(rand.NewSource(time.Now().UnixNano()))
	}
	return c.Rand
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=5768:5808#L193))

The default value for `maxCount` depends on whether the scaling factor `c.MaxCountScale` is set. In 
the default configuration, the factor is 0, which initializes `maxCount` with the default value 100.
If the scale factor is set, i.e. non-zero, then the default value is multiplied by the factor.

```golang {hl_lines=[7,9]}
// getMaxCount returns the maximum number of iterations to run for a given
// Config.
func (c *Config) getMaxCount() (maxCount int) {
	maxCount = c.MaxCount
	if maxCount == 0 {
		if c.MaxCountScale != 0 {
			maxCount = int(c.MaxCountScale * float64(*defaultMaxCount))
		} else {
			maxCount = *defaultMaxCount
		}
	}

	return
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=5992:6039#L193))

Now we start the test execution with the determined configuration values. The runs of the for loop 
are limited to the previously determined `maxCount` value. 

```golang
for i := 0; i < maxCount; i++ {
	err := arbitraryValues(arguments, fType, config, rand)
	if err != nil {
		return err
	}

	if !fVal.Call(arguments)[0].Bool() {
		return &CheckError{i + 1, toInterfaces(arguments)}
	}
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253))

The first step of any test execution is the generation and filling of the previously created array 
`arguments` via the function 
[arbitraryValues()](https://golang.org/src/testing/quick/quick.go?s=9450:9556#L333).

```golang
// arbitraryValues writes Values to args such that args contains Values
// suitable for calling f.
func arbitraryValues(args []reflect.Value, f reflect.Type, config *Config, rand *rand.Rand) (err error) {
	if config.Values != nil {
		config.Values(args, rand)
		return
	}

	for j := 0; j < len(args); j++ {
		var ok bool
		args[j], ok = Value(f.In(j), rand)
		if !ok {
			err = SetupError(fmt.Sprintf("cannot create arbitrary value of type %s for argument %d", f.In(j), j))
			return
		}
	}

	return
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=9450:9556#L333))

First, the function checks if the user has configured his own function to generate the arguments, if 
this is the case, it is called. Otherwise the arguments are looped and filled via the 
[Value()](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49) 
function. The first parameter of 
[Value()](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49) is the type of the 
argument, which is determined via the 
[In()](https://golang.org/src/reflect/type.go?s=6778:6792#L175) function of the 
[Type interface](https://golang.org/src/reflect/type.go?s=1335:7577#L28) and via the position of the 
element. Now let's see where the random value for our argument `args[j]` comes from.

```golang
func Value(t reflect.Type, rand *rand.Rand) (value reflect.Value, ok bool) {
	return sizedValue(t, rand, complexSize)
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49))

[Value()](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49) serves only as wrapper and 
calls the function [sizedValue()](https://golang.org/src/testing/quick/quick.go?s=1926:2017#L59) 
with the size 50, which is stored in the constant `const complexSize = 50`. So let's jump right into 
the function.


```golang
func sizedValue(t reflect.Type, rand *rand.Rand, size int) (value reflect.Value, ok bool) {
	if m, ok := reflect.Zero(t).Interface().(Generator); ok {
		return m.Generate(rand, size), true
	}

	v := reflect.New(t).Elem()
	switch concrete := t; concrete.Kind() {
	case reflect.Bool:
		v.SetBool(rand.Int()&1 == 0)
	case reflect.Float32:
		v.SetFloat(float64(randFloat32(rand)))
	case reflect.Float64:
		v.SetFloat(randFloat64(rand))
	case reflect.Complex64:
		v.SetComplex(complex(float64(randFloat32(rand)), float64(randFloat32(rand))))
	case reflect.Complex128:
		v.SetComplex(complex(randFloat64(rand), randFloat64(rand)))
	case reflect.Int16:
		v.SetInt(randInt64(rand))
	case reflect.Int32:
		v.SetInt(randInt64(rand))
	case reflect.Int64:
		v.SetInt(randInt64(rand))
	case reflect.Int8:
		v.SetInt(randInt64(rand))
	case reflect.Int:
		v.SetInt(randInt64(rand))
	case reflect.Uint16:
		v.SetUint(uint64(randInt64(rand)))
	case reflect.Uint32:
		v.SetUint(uint64(randInt64(rand)))
	case reflect.Uint64:
		v.SetUint(uint64(randInt64(rand)))
	case reflect.Uint8:
		v.SetUint(uint64(randInt64(rand)))
	case reflect.Uint:
		v.SetUint(uint64(randInt64(rand)))
	case reflect.Uintptr:
		v.SetUint(uint64(randInt64(rand)))
	case reflect.Map:
		numElems := rand.Intn(size)
		v.Set(reflect.MakeMap(concrete))
		for i := 0; i < numElems; i++ {
			key, ok1 := sizedValue(concrete.Key(), rand, size)
			value, ok2 := sizedValue(concrete.Elem(), rand, size)
			if !ok1 || !ok2 {
				return reflect.Value{}, false
			}
			v.SetMapIndex(key, value)
		}
	case reflect.Ptr:
		if rand.Intn(size) == 0 {
			v.Set(reflect.Zero(concrete)) // Generate nil pointer.
		} else {
			elem, ok := sizedValue(concrete.Elem(), rand, size)
			if !ok {
				return reflect.Value{}, false
			}
			v.Set(reflect.New(concrete.Elem()))
			v.Elem().Set(elem)
		}
	case reflect.Slice:
		numElems := rand.Intn(size)
		sizeLeft := size - numElems
		v.Set(reflect.MakeSlice(concrete, numElems, numElems))
		for i := 0; i < numElems; i++ {
			elem, ok := sizedValue(concrete.Elem(), rand, sizeLeft)
			if !ok {
				return reflect.Value{}, false
			}
			v.Index(i).Set(elem)
		}
	case reflect.Array:
		for i := 0; i < v.Len(); i++ {
			elem, ok := sizedValue(concrete.Elem(), rand, size)
			if !ok {
				return reflect.Value{}, false
			}
			v.Index(i).Set(elem)
		}
	case reflect.String:
		numChars := rand.Intn(complexSize)
		codePoints := make([]rune, numChars)
		for i := 0; i < numChars; i++ {
			codePoints[i] = rune(rand.Intn(0x10ffff))
		}
		v.SetString(string(codePoints))
	case reflect.Struct:
		n := v.NumField()
		// Divide sizeLeft evenly among the struct fields.
		sizeLeft := size
		if n > sizeLeft {
			sizeLeft = 1
		} else if n > 0 {
			sizeLeft /= n
		}
		for i := 0; i < n; i++ {
			elem, ok := sizedValue(concrete.Field(i).Type, rand, sizeLeft)
			if !ok {
				return reflect.Value{}, false
			}
			v.Field(i).Set(elem)
		}
	default:
		return reflect.Value{}, false
	}

	return v, true
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=1926:2017#L59))

Oh my goodness – I didn't expect such a complex and confusing function. Okay, but we'll work it out, 
piece by piece. Basically, the function can be divided into two sections. The first part is small 
and deals with random value generation via the 
[quick Generator interface](https://golang.org/src/testing/quick/quick.go?s=575:764#L13) and the 
second part is large switch case block, which is used for random value generation depending on the 
[reflect Type interface](https://golang.org/src/reflect/type.go?s=1335:7577#L28).

In the first part the reflect function 
[Zero()](https://golang.org/src/reflect/value.go?s=70809:70834#L2356) is used to get the zero value 
of the passed type and then the reflect function 
[Interface()](https://golang.org/src/reflect/value.go?s=31475:31517#L1005) is used to convert the 
value into an `interface{}`. On this interface now a type assertion for the 
[Generator](https://golang.org/src/testing/quick/quick.go?s=575:764#L13) interface is performed. If 
the type implements the interface, 
[Generate()](https://golang.org/src/testing/quick/quick.go?s=713:762#L16) is called on it and the 
result is returned.

We continue with the next section, which covers all types that do not implement the 
[Generator](https://golang.org/src/testing/quick/quick.go?s=575:764#L13) interface. First, a reflect 
[Value()](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49) is created that is filled 
via the switch case depending on the type. The 
[Value()](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49) is created via the reflect 
function [New()](https://golang.org/src/reflect/value.go?s=71172:71196#L2370), which returns a 
pointer to a new zero value of the type and via the reflect function 
[Elem()](https://golang.org/src/reflect/value.go?s=25742:25769#L801) the value is determined to 
which the previously created pointer points.

Some simple case treatments now follow and I will not go into every case. Of particular interest to 
me in this article is what code the [package quick](https://golang.org/pkg/testing/quick/) provides 
and that is the focus here as well. The code of the 
[package reflect](https://golang.org/pkg/reflect/) may come in a future post. In general, we can 
summarize a large part of the cases with the fact that the 
[package reflect](https://golang.org/pkg/reflect/) provides multiple setters for the different types 
through which the previously defined value is initialized.

For setting the values in the first part of the switch case block the functions 
[randFloat32()](https://golang.org/src/testing/quick/quick.go?s=842:885#L16), 
[randFloat64()](https://golang.org/src/testing/quick/quick.go?s=1059:1102#L33), as well as 
[randInt64()](https://golang.org/src/testing/quick/quick.go?s=1228:1267#L41) are used and their 
results are converted to the required type. We will now take a closer look at these random 
functions. 

#### randFloat32

```golang
func randFloat32(rand *rand.Rand) float32 {
	f := rand.Float64() * math.MaxFloat32
	if rand.Int()&1 == 1 {
		f = -f
	}
	return float32(f)
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=842:885#L16))

The first step to generate a random float32 value for via generating a random float64 using the 
[Float64()](https://golang.org/src/math/rand/rand.go?s=5359:5391#L168) function of the 
[package math/rand](https://golang.org/pkg/math/rand/). This function generates a pseudo-random 
float64 value between 0.0 and 1.0, e.g. 0.498934. 

The result of the random function is multiplied by the maximum value for float32 
[math.MaxFloat32](https://golang.org/src/math/const.go?s=1515:1617#L24) to get a random value within 
the float32 range, e.g. the random value 0.498934 multiplied by 
[math.MaxFloat32](https://golang.org/src/math/const.go?s=1515:1617#L24) gives 
1.6977833628035685e+38.

Because we only get positive values from the previous calculation, the next step is to randomly 
determine whether the value is negated. For this purpose, a random number is generated via 
[Int()](https://golang.org/src/math/rand/rand.go?s=3272:3296#L92) in order to perform a logical
conjunction with the binary value of one. This bitwise AND operation[^bitwiseAND] tells us whether 
the generated random number is even (false) or odd (true). If the number is odd, the random float32 
value is negated. Finally, the value is converted to a float32 and returned.

#### randFloat64

```golang
func randFloat64(rand *rand.Rand) float64 {
	f := rand.Float64() * math.MaxFloat64
	if rand.Int()&1 == 1 {
		f = -f
	}
	return f
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=1058:1102#L32))

In this function basically the same happens as in [randFloat32](#randfloat32), except that here the 
constant [math.MaxFloat64](https://golang.org/src/math/const.go?s=1717:1821#L28) is used for the 
first calculation and the result is not converted to a float32.

#### randInt64

```golang
func randInt64(rand *rand.Rand) int64 {
	return int64(rand.Uint64())
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=1227:1268#L40))

To generate a random int64 value, only 
[rand.Uint64()](https://golang.org/src/math/rand/rand.go?s=2949:2979#L81) is used to generate a 
random uint64 value which is then converted to an int64 value. 

We now return to the function 
[arbitraryValues()](https://golang.org/src/testing/quick/quick.go?s=9450:9556#L333), where we wanted 
to determine the random value via 
[Value()](https://golang.org/src/testing/quick/quick.go?s=1618:1692#L49). 

```golang {hl_lines=[3]}
for j := 0; j < len(args); j++ {
	var ok bool
	args[j], ok = Value(f.In(j), rand)
	if !ok {
		err = SetupError(fmt.Sprintf("cannot create arbitrary value of type %s for argument %d", f.In(j), j))
		return
	}
}
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=9450:9556#L333))

The only thing that is checked here is whether a value could be generated and if this is not the 
case, a [SetupError](https://golang.org/src/testing/quick/quick.go?s=6360:6382#L213) with a 
corresponding error message is created and returned.

We now jump further back into the 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function where 
[arbitraryValues()](https://golang.org/src/testing/quick/quick.go?s=9450:9556#L333) was called to 
determine the random arguments.

```golang {hl_lines=[2]}
for i := 0; i < maxCount; i++ {
	err := arbitraryValues(arguments, fType, config, rand)
	if err != nil {
		return err
	}

	if !fVal.Call(arguments)[0].Bool() {
		return &CheckError{i + 1, toInterfaces(arguments)}
	}
}

return nil
```

(Source: [quick/quick.go](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253))

If an error occurred during the determination, it is now returned. If everything went smoothly and 
we received the required arguments, then the test function with the random parameters is executed 
via the reflection function [Call()](https://golang.org/src/reflect/value.go?s=10504:10543#L324).

The result of the function is interpreted as a boolean and if it is false, the test has failed and a 
[CheckError](https://golang.org/src/testing/quick/quick.go?s=6498:6556#L218) is generated and a 
pointer to it is returned. If all tests are passed successfully, nil is returned.

### Examples for fuzzy testing via the Check() function

Now we've rummaged long enough in the Go standard library – let's look at a few examples of how 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) can be easily implemented 
in Go tests to quickly generate added value.

First, we take the input example and convert it into a fuzzy test[^fuzz]. By the way, it is often 
worthwhile to have both a test with static test parameters and an additional fuzzy test[^fuzz]. 
Especially in the course of {{< abbr "TDD" "test-driven development" >}}, I like to build 
old-fashioned static tests first, so that the test cases I know are secured, and then I add a fuzzy 
test[^fuzz] to secure all further cases.

#### Input example as fuzzy test

In the input example, several test cases were statically defined, each containing different slices 
of transactions and the expected grouping. Unfortunately (or fortunately), however, we already reach 
the limits of the [Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function 
in our fuzzy test[^fuzz] when generating the transactions. As long as all fields of a struct are 
public, random values can be generated, but since private fields are used in the 
[Decimal](https://github.com/shopspring/decimal/blob/master/decimal.go#L69) struct, an error occurs 
during generation. 

Through this error, I can now show how the 
[Generator](https://golang.org/src/testing/quick/quick.go?s=575:764#L13) interface can be used to 
generate a random value. 

Since I don't want to extend the `Transaction` model with the interface, a new type 
`fuzzTransaction` of type `Transaction` is created in the test, which implements the 
[Generator](https://golang.org/src/testing/quick/quick.go?s=575:764#L13) interface. This new type 
can now be used for generation, but must then be transformed back into the `Transaction` model so 
that the grouping function can be tested.

Let's jump into the test and take a closer look. 

```golang
package transactions

import (
	"math/rand"
	"reflect"
	"testing"
	"testing/quick"

	"github.com/shopspring/decimal"
)

type fuzzTransaction Transaction

func (f fuzzTransaction) Generate(rand *rand.Rand, size int) reflect.Value {
	return reflect.ValueOf(fuzzTransaction{
		Amount: randDecimal(rand, size),
		Type:   randTransactionType(rand, size),
	})
}

func randDecimal(rand *rand.Rand, size int) decimal.Decimal {
	i := float64(rand.Intn(size))
	return decimal.NewFromFloat((rand.Float64() * i) + i)
}

func randTransactionType(rand *rand.Rand, size int) TransactionType {
	numChars := rand.Intn(size)
	codePoints := make([]rune, numChars)
	for i := 0; i < numChars; i++ {
		codePoints[i] = rune(rand.Intn(0x10ffff))
	}

	return TransactionType(string(codePoints))
}

func TestGroupTransactionsByType(t *testing.T) {
	f := func(fuzzTransactions []fuzzTransaction) bool {
		transactions := make([]Transaction, len(fuzzTransactions))
		for i := range fuzzTransactions {
			transactions = append(transactions, Transaction(fuzzTransactions[i]))
		}

		actual := GroupTransactionsByType(transactions)

		for transactionType, groupedTransactions := range actual {
			for i := range groupedTransactions {
				if groupedTransactions[i].Type != transactionType {
					return false
				}
			}
		}

		return true
	}

	cfg := &quick.Config{MaxCount: 10000}

	if err := quick.Check(f, cfg); err != nil {
		t.Error(err)
	}
}
```

More about the implementation of the 
[Generator](https://golang.org/src/testing/quick/quick.go?s=575:764#L13) interface in the previous 
section, [Code analysis of the Check() function](code-analysis-of-the-check-function).

The fuzzy test[^fuzz] can be roughly divided into three sections – the test function, the 
configuration and the test execution.

First, a variable is initialized with the test function, whose signature is used in the 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function for generating 
the random values. All parameters of the function are automatically determined via reflection. The 
function is only executed within the 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function together with the 
random values.

In the next section the configuration of the fuzzy test[^fuzz] is created. Since the default value 
for the maximum test runs is set to 100, I like to overwrite the value with 10000 to get a good test 
coverage.

Finally, the [Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253) function is 
called. If everything runs smoothly during the initialization of the test, the random values are 
determined and passed as parameters to the test function. 

The `fuzzyTransactions` are now transformed back to normal transactions within the test function and 
passed to the `GroupTransactionsByType` function for grouping. To make sure that everything has been 
grouped correctly, the groupings are processed in a loop and if the type of one of the grouped 
transactions does not match the type to which the transaction was grouped, `false` is returned to 
mark the test as failed. 

Let's run the test and see the result.

```shell
$ go test
PASS
ok      github.com/lrotermund/quicktesting/pkg/transactions   0.370s
```

Here you can also see well that the execution time is significantly higher than with the classic 
tests due to the large number of test runs. In the following you can find the output at 50000 test 
runs.

```shell
$ go test
PASS
ok      github.com/lrotermund/quicktesting/pkg/transactions   1.669s
```

#### Fuzzy test with two parameters

In the next fuzzy test[^fuzz], we include the name of the transaction partner as another string 
parameter. The `Transaction` and the `Generate` function of the `fuzzTransaction` are also extended 
by a partner.

Now the function `FindTransactionsByPartnerName` is added, which determines all transactions to a 
certain name. This is not a good example, since a name is not a unique identifier, but it serves 
well as an illustration. For this function we now build another test – let's take a look at the new
service code.


```golang
package transactions

import (
	"github.com/shopspring/decimal"
)

type (
	Transaction struct {
		Amount  decimal.Decimal
		Type    TransactionType
		Partner Partner
	}
	Partner struct {
		Name string
	}
	GroupedTransactionsByType map[TransactionType][]Transaction
	TransactionType           string
)

const (
	TransactionTypeCredit TransactionType = "CREDIT"
	TransactionTypeDebit  TransactionType = "DEBIT"
)

func GroupTransactionsByType(transactions []Transaction) GroupedTransactionsByType {
	transactionsByType := make(GroupedTransactionsByType)

	for _, t := range transactions {
		transactionsByType[t.Type] = append(transactionsByType[t.Type], t)
	}

	return transactionsByType
}

func FindTransactionsByPartnerName(
	transactions []Transaction,
	partnerName string,
) (transactionsByPartnerName []Transaction) {
	for i := range transactions {
		if transactions[i].Partner.Name != partnerName {
			continue
		}

		transactionsByPartnerName = append(transactionsByPartnerName, transactions[i])
	}

	return
}
```

We continue with the new test and the adjustment to the `Generate` function.

```golang
package transactions

import (
	"math/rand"
	"reflect"
	"testing"
	"testing/quick"

	"github.com/shopspring/decimal"
)

type fuzzTransaction Transaction

func (f fuzzTransaction) Generate(rand *rand.Rand, size int) reflect.Value {
	return reflect.ValueOf(fuzzTransaction{
		Amount:  randDecimal(rand, size),
		Type:    randTransactionType(rand, size),
		Partner: randPartner(rand, size),
	})
}

func randDecimal(rand *rand.Rand, size int) decimal.Decimal {
	i := float64(rand.Intn(size))
	return decimal.NewFromFloat((rand.Float64() * i) + i)
}

func randTransactionType(rand *rand.Rand, size int) TransactionType {
	return TransactionType(randString(rand, size))
}

func randPartner(rand *rand.Rand, size int) Partner {
	return Partner{Name: string(randString(rand, size))}
}

func randString(rand *rand.Rand, size int) string {
	numChars := rand.Intn(size)
	codePoints := make([]rune, numChars)
	for i := 0; i < numChars; i++ {
		codePoints[i] = rune(rand.Intn(0x10ffff))
	}

	return string(codePoints)
}

func TestFindTransactionsByPartnerName(t *testing.T) {
	f := func(fuzzTransactions []fuzzTransaction, partnerName string) bool {
		transactions := make([]Transaction, len(fuzzTransactions))
		for i := range fuzzTransactions {
			transactions = append(transactions, Transaction(fuzzTransactions[i]))
		}

		actual := FindTransactionsByPartnerName(transactions, partnerName)

		for i := range actual {
			if actual[i].Partner.Name != partnerName {
				return false
			}
		}

		return true
	}

	cfg := &quick.Config{MaxCount: 10000}

	if err := quick.Check(f, cfg); err != nil {
		t.Error(err)
	}
}
```

In the course of the new test I refactored the random generators for the `Transaction` type and the 
`Partner` and added a string generator. 

The test function now has the additional parameter `partnerName` and both parameters are passed to 
the new function `FindTransactionsByPartnerName`. 

The check is very simple, all transactions are run through and the name is checked in the 
transactions.

```shell
$ go test
PASS
ok      github.com/lrotermund/quicktesting/pkg/transactions   0.357s
```

## My feedback on fuzzy testing with the quick package

First of all, I think it's awesome that there's a way to fuzzy test[^fuzz] in the Go standard 
library. It gives every Go developer the opportunity to write more bulletproof and robust code. 
Especially when I'm writing down my test cases during development anyway through 
{{< abbr "TDD" "test-driven development" >}}, it's easy for me to add a fuzzy test[^fuzz] afterwards 
to cover all the cases I didn't think of.

At the beginning I found the test syntax a bit hard to get used to and also the fact that I often 
have to write a generator through private fields in my structs, but you get used to it quite 
quickly. Just by the enormous added value generated by the sheer amount of test runs.

Of course there are other libraries that offer fuzzy testing[^fuzz] for Golang, but before you get a 
lot of external dependencies into your project, you should try the way via the standard library.

I will definitely continue to enrich my classic tests with fuzzy tests[^fuzz] through quick. 

Do you disagree with me, have you had bad or good experiences with quick, or do you know a way to 
make fuzzy testing[^fuzz] much more efficient and better? Let's discuss it on 
[LinkedIn](https://www.linkedin.com/in/lukas-rotermund) or 
[Xing](https://www.xing.com/profile/Lukas_Rotermund2) – I look forward to your opinion!

[^fuzz]: fuzzing, fuzz testing, fuzzy testing:  
	Fuzzy testing is an automatic way to test software using random parameters. Through the random, 
	unknown parameters and a large number of test runs, cases are taken into account that are often 
	not thought of when writing tests. With each test run, more test cases are generated, making the 
	function more and more robust. More about fuzzy testing can be found on 
	[Wikipedia - Fuzzing](https://en.wikipedia.org/wiki/Fuzzing)


[^bitwiseAND]: bitwise AND operation:
	
	```shell
		1111000 (decimal 120)
	AND	0000001 (decimal 1)
	  =	0000000 (decimal 0)
	```

	Here is an example of the bitwise AND operation, in which 120 is used as the randomly 
	generated number. More about bitwise operations can be found on 
	[Wikipedia - Bitwise operation](https://en.wikipedia.org/wiki/Bitwise_operation)