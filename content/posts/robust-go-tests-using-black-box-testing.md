---
title: "Robust Go tests using black box testing"
date: 2021-01-24T17:57:34+01:00
draft: true
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

## No qualitative test coverage for simple parameter combinations

When writing tests, the test parameters look similar for almost all developers, from "foo" to "John 
Doe" everything is represented. Let's take a look at a classic test where these normal parameters 
are used.

```golang
func TestNormalParameters(t *testing.T) {
	testCases := []struct {
		defaultValue string
		size         int
	}{
		{"", 0},
		{"foo", 3},
		{"foobar", 42},
		{"John Doe", 100},
	}

	for _, tc := range testCases {
		t.Run(fmt.Sprintf("%s,%d", tc.defaultValue, tc.size), func(t *testing.T) {
			s := GetSliceWithDefaultValues(tc.defaultValue, tc.size)

			if len(s) != tc.size {
				t.Fatalf("assertion failed, expected slice length %d, got %d", tc.size, len(s))
			}

			for i := 0; i < tc.size; i++ {
				if s[i] != tc.defaultValue {
					t.Fatalf("assertion failed, expected value %s, got %s", tc.defaultValue, s[i])
				}
			}
		})
	}
}

func GetSliceWithDefaultValues(defaultValue string, size int) []string {
	s := make([]string, size)

	for i := 0; i < size; i++ {
		s[i] = defaultValue
	}

	return s
}
```

In our test we are testing a function that creates a slice of the desired length and whose values 
are filled with a specified default value. The test contains several test cases that are run through 
one after the other and whose results are checked afterwards. Let's start the test and see if all 
test cases work.

```shell
$ go test
PASS
ok      github.com/lrotermund/quicktesting/pkg/basictest   0.001s
```

My assumption now could be that my function works the way I want it to and maybe I use the function 
in my code only with the tested values. Should I now be so convinced of my package that I make it 
available to others, the probability is very high that someone uses the function with other 
parameters and something fails. 

The function doesn't necessarily have to fail when it's used by others, often it's enough if project 
requirements change or code is changed in the course of refactoring, resulting in new cases not yet 
covered by my unit test. 

To circumvent these potential sources of error and to avoid possible unknown test cases, the Go 
standard library provides the [package quick](https://golang.org/pkg/testing/quick/) in the 
subdirectory of the [testing package](https://golang.org/pkg/testing/). 

Let's take a look at the first function 
[Check()](https://golang.org/src/testing/quick/quick.go?s=7499:7546#L253), maybe we can use it to 
make our tests more robust!

### Check

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