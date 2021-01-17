---
title: "Testing, an important feature of the Go standard library"
tags: [go-standard-library, "development", "golang", "testing"]
date: 2021-01-15T12:51:41+01:00
draft: true
---

Testing should be a big part of our daily work routine as a software developer, which is the reason
for this article. During my last project I often had problems writing good and robust tests for Go, 
which now gives me the best basis for a new post. Fortunately, again the Go standard library 
provides a solution: [pkg/testing](https://golang.org/pkg/testing/).

{{< toc >}}

## A quick and short introduction to Go testing

This part is a brief overview over the basic functionality of testing in Go. You can skip this
section if simple tests are already a habit for you.

### Where should I place a Go test?

First, add the test file as close as possible to the code/ package it will test. Always name your 
test files the same as the file under test and attach "_test.go". Let's assume, the file under test 
is "validator.go", then name your test file "validator_test.go" and place it into the same 
directory. 

```bash
.
├── pkg
│   ├── validator.go
│   └── validator_test.go
```

### How do I write a Go test?

A test is nothing else then a function, and there name is prefixed with "Test", followed by the test 
description written in PascalCase for an automatic test execution on `go test` and in camelCase to 
avoid the automatic test execution. 

Test with automatic test execution on `go test`:
```golang
func TestValidateStringNotBlank(*testing.T)
```
```shell
$ go test
PASS
ok      github.com/lrotermund/testing/pkg/validation   0.003s
```

Test _without_ automatic test execution:
```golang
func TestvalidateStringNotBlank(*testing.T)
```
```shell
$ go test
ok      github.com/lrotermund/testing/pkg/validation   0.001s [no tests to run]
```

Both functions accepting a pointer of 
[testing.T](https://golang.org/src/testing/testing.go?s=23377:23479#L647), which is necessary to 
make the current test fail. But what does a test that integrates 
[testing.T](https://golang.org/src/testing/testing.go?s=23377:23479#L647) look like and how do I 
make a test fail?

```golang
func TestValidateStringNotBlank(t *testing.T) {
    s := buggyFuncReturningBlankStr()

    if len(s) == 0 {
		t.Log("String returned by buggyFuncReturningBlankStr() is blank")
        t.Fail()
    }
}

func buggyFuncReturningBlankStr() string {
    return ""
}
```
Let's take a look at what happens here in the test step by step. First, I added the name "t" for the
[testing.T](https://golang.org/src/testing/testing.go?s=23377:23479#L647) pointer. For a simple 
illustration, we test the intentionally buggy function `buggyFuncReturningBlankStr()`, which returns 
an blank string, causing `s` to contain an blank string. 

Now to make sure our string is not blank, I check the length of `s` via `if len(s) == 0`. Since `s` 
was initialized empty via the `buggyFuncReturningBlankStr()` function, the error "String returned by buggyFuncReturningBlankStr() is blank" is now generated via the 
[t.Error](https://golang.org/pkg/testing/#T.Error) function and the test is marked as failed – we'll 
look at how all this happens later.

It is important to note here that the test deliberately results in a failed test to illustrate the 
result of the [t.Error](https://golang.org/pkg/testing/#T.Error) function. Of course, the goal is 
always to have successful tests – in other words, to get the tests green at the end.

Now let's run the test via `go test` and see if we get our expected error message.
```shell
$ go test
--- FAIL: TestValidateStringNotBlank (0.00s)
    validator_test.go:9: String returned by buggyFuncReturningBlankStr() is blank
FAIL
exit status 1
FAIL    github.com/lrotermund/testing/pkg/validation   0.001s
```

In the previous example, I used [t.Error](https://golang.org/pkg/testing/#T.Error) to mark the test
as failed and generate a log message. There are many more ways to mark a test as failed and we will 
look at these in the next section.

## Mark a Go test as failed

Tests are marked as "passed" if they were not marked as failed during the test. There are several 
ways to mark a test as failed – let's dive into the Go standard library and start with the "Fail" 
function.

### Use the Fail function to mark a test as failed 

```golang
func (c *common) Fail() {
	if c.parent != nil {
		c.parent.Fail()
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	// c.done needs to be locked to synchronize checks to c.done in parent tests.
	if c.done {
		panic("Fail in goroutine after " + c.name + " has completed")
	}
	c.failed = true
}
```
(Source: [testing/testing.go](https://golang.org/src/testing/testing.go?s=23815:23838#L670))

Below you find the common struct used in `Fail()` so you have the fields and their types available 
for reference. (in a shortened form).

```golang
type common struct {
    ...
    mu     sync.RWMutex // guards this group of fields
	failed bool         // Test or benchmark has failed.
	done   bool         // Test is finished and all subtests have completed.
    parent *common
    name   string       // Name of test or benchmark.
    ...
}
```

(Source: [testing/testing.go](https://golang.org/src/testing/testing.go?s=14406:14426#L384))

Why do we have so many code in here for a simple fail function – why not just set failed to true? We 
can find the answer to this question already in the first few lines of Code, `if c.parent != nil` 
shows us that there could be a parent test that produced the current test and if so `Fail()` is also 
called on the parent test `c.parent.Fail()`.

Now its getting more complicated, what is this 
[sync.RWMutex](https://golang.org/src/sync/rwmutex.go?s=987:1319#L18) thats getting locked 
`c.mu.Lock()`? In order to answer this question, we have to make a short excursion into the world of 
multi-threading in Go. 

We already know that there can be a parent test to our test and that already indicates the use of a 
[goroutine](https://tour.golang.org/concurrency/1). Before we clarify what a 
[sync.RWMutex](https://golang.org/src/sync/rwmutex.go?s=987:1319#L18) is, let's first look at a 
classic [sync.Mutex](https://golang.org/src/sync/mutex.go?s=765:813#L15). A mutex (mutual exclusion 
lock) is your tool to protect a shared resource, like the common struct in our case, from race 
condition due to an simultaneously read or write access. Let's have a brief look into the func 
description of the `Lock()` function.

```golang
// Lock locks m.
// If the lock is already in use, the calling goroutine
// blocks until the mutex is available.
func (m *Mutex) Lock()
```
(Source: [sync/mutex.go](https://golang.org/src/sync/mutex.go?s=2534:2556#L62))

The description already brings it to the point – if the function `Lock()` of the mutex is called and 
this lock should already be set by another goroutine, our current goroutine is blocked until the 
lock is released again and this applies to reading, as well as writing accesses.

To take a less restrictive approach, a 
[sync.RWMutex](https://golang.org/src/sync/rwmutex.go?s=987:1319#L18) (reader/writer mutex) was 
integrated in the common struct. The 
[sync.RWMutex](https://golang.org/src/sync/rwmutex.go?s=987:1319#L18) slightly loosens the 
restriction that only one access can take place at the same time. Thus, it is possible that several 
read accesses, or one write access take place simultaneously on the shared resource. By the way, 
there are different lock functions for the different accesses: 
[Lock()](https://golang.org/src/sync/rwmutex.go?s=2805:2830#L82) and 
[RLock()](https://golang.org/src/sync/rwmutex.go?s=1558:1584#L33)

Now let's jump back into our `Fail()` function and thus to the next line of code 
`defer c.mu.Unlock()`. The `defer` statement causes the following instruction to be executed when 
the surrounding function returns, as a result we unlock the previously created lock at the end of 
the function with [Unlock()](https://golang.org/src/sync/rwmutex.go?s=3664:3691#L108) and release 
the resource again.

The next lines of code are a reaction to a race condition that occurs when the user has not 
synchronized his sub-tests/ goroutines appropriately and the test function completes successfully 
even though sub-tests are still running.

```golang
// c.done needs to be locked to synchronize checks to c.done in parent tests.
if c.done {
    panic("Fail in goroutine after " + c.name + " has completed")
}
```

Finally, the test is marked as failed via `c.failed = true`. Important to know: the test is __not 
aborted__ at this point. To abort a test completely in case of an error, the function 
[FailNow()](https://golang.org/src/testing/testing.go?s=24706:24732#L699) can be used, which we'll 
look in the next section – but first, an example of what I mean by "not aborted":

```golang
func TestMultipleAssertions(t *testing.T) {
	s := buggyFuncReturningNil()

	if s == nil {
		t.Log("assertion failed, expected a value, got nil")
		t.Fail()
	}

	if len(*s) == 0 {
		t.Log("assertion failed, expected a value, got blank string")
		t.Fail()
	}
}

func buggyFuncReturningNil() *string {
	return nil
}
```

Let's jump straight to the test execution and see what happens.

```shell
$ go test                                                                                           
--- FAIL: TestMultipleAssertions (0.00s)
    multipleassertions_test.go:9: assertion failed, expected a value, got nil
panic: runtime error: invalid memory address or nil pointer dereference [recovered]
        panic: runtime error: invalid memory address or nil pointer dereference
```

Oh no, we have a null pointer exception. The error message shows that the first assertion was 
successful and we also find the expected log message. The error occurs because the assertions are 
based on each other and the next assertion expects that the value can be dereferenced. If you 
want to cover this case, then you should use 
[FailNow()](https://golang.org/src/testing/testing.go?s=24706:24732#L699) as already mentioned.

Let's take another look at an example where multiple test cases are tested sequentially using the 
[t.Run()](https://golang.org/src/testing/testing.go?s=37631:37678#L1125) function with different 
parameters.

```golang
func TestWithSubTests(t *testing.T) {
	testCases := []struct {
		foo string
		bar string
	}{
		{"foo", "bar"},
		{"foo", ""},
		{"", "bar"},
		{"bar", "foo"},
	}

	for _, tc := range testCases {
		t.Run(fmt.Sprintf("%s-%s", tc.foo, tc.bar), func(t *testing.T) {
			s := buggyFuncCouldReturnBlankString(tc.foo, tc.bar)

			if len(s) == 0 {
				t.Fail()
			}
		})
	}
}

func buggyFuncCouldReturnBlankString(foo, bar string) (s string) {
	if len(foo) == 0 || len(bar) == 0 {
		return
	}

	s = fmt.Sprintf("%s::%s", foo, bar)
	return
}
```

This is a common pattern in Go testing to test a bunch of test cases against a function. First, you
declare your test cases within a slice. Then you loop over these test cases and start a sub-test 
with [t.Run()](https://golang.org/src/testing/testing.go?s=37631:37678#L1125). The first parameter
is the name of the sub-test and the second one is the sub-test function. 

Let's run the test with `go test`:

```shell
$ go test                                                                                        
--- FAIL: TestWithSubTests (0.00s)
    --- FAIL: TestWithSubTests/foo- (0.00s)
    --- FAIL: TestWithSubTests/-bar (0.00s)
FAIL
exit status 1
FAIL    github.com/lrotermund/testing/pkg/subtests   0.001s
```

Here you can see very nicely how `go test` displays the failed sub-tests indented, which quickly 
shows which of the sub-tests failed and which parameter combinations did not work.

### Stop test execution directly with the FailNow function

Let's have a look at the [FailNow()](https://golang.org/src/testing/testing.go?s=24706:24732#L699) 
code before we jump into an example.

```golang
func (c *common) FailNow() {
	c.Fail()

	// Calling runtime.Goexit will exit the goroutine, which
	// will run the deferred functions in this goroutine,
	// which will eventually run the deferred lines in tRunner,
	// which will signal to the test loop that this test is done.
	//
	// A previous version of this code said:
	//
	//	c.duration = ...
	//	c.signal <- c.self
	//	runtime.Goexit()
	//
	// This previous version duplicated code (those lines are in
	// tRunner no matter what), but worse the goroutine teardown
	// implicit in runtime.Goexit was not guaranteed to complete
	// before the test exited. If a test deferred an important cleanup
	// function (like removing temporary files), there was no guarantee
	// it would run on a test failure. Because we send on c.signal during
	// a top-of-stack deferred function now, we know that the send
	// only happens after any other stacked defers have completed.
	c.finished = true
	runtime.Goexit()
}
```

(Source: [testing/testing.go](https://golang.org/src/testing/testing.go?s=24706:24732#L699))

[FailNow()](https://golang.org/src/testing/testing.go?s=24706:24732#L699) first executes 
[Fail()](https://golang.org/src/testing/testing.go?s=23815:23838#L670) to mark the test as failed. 
You can read more about this in the previous section 
[Mark a Go test as failed](#mark-a-go-test-as-failed). Finally, the test is marked as "finished" and 
the current goroutine is terminated via `runtime.Goexit()`. Exiting the goroutine will execute the 
next test or benchmark.

Now let's pick up the previous example and replace the 
[Fail()](https://golang.org/src/testing/testing.go?s=23815:23838#L670) function with the 
[FailNow()](https://golang.org/src/testing/testing.go?s=24706:24732#L699) function and look at the 
output of `go test`.

```golang
func TestMultipleAssertionsWithFailNow(t *testing.T) {
	s := buggyFuncReturningNil()

	if s == nil {
		t.Log("assertion failed, expected a value, got nil")
		t.FailNow()
	}

	if len(*s) == 0 {
		t.Log("assertion failed, expected a value, got blank string")
		t.FailNow()
	}
}

func buggyFuncReturningNil() *string {
	return nil
}
```
```shell
$ go test
--- FAIL: TestMultipleAssertionsWithFailNow (0.00s)
    multiplefailnowassertions_test.go:9: assertion failed, expected a value, got nil
FAIL
exit status 1
FAIL    github.com/lrotermund/testing/pkg/failnow   0.004s
```

This time we were more lucky and our tests could be executed without an unexpected exception. The 
test was successfully terminated on the first call to 
[FailNow()](https://golang.org/src/testing/testing.go?s=24706:24732#L699).

### Simplified logging when marking a test as failed with the Error/ Errorf function

In the previous examples, I often printed the error messages of the Go tests via the 
[t.Log()](https://golang.org/src/testing/testing.go?s=27069:27110#L766) 
function and subsequently marked the test as failed via 
[t.Fail()](https://golang.org/src/testing/testing.go?s=23815:23838#L670) - fortunately, the Go 
standard library provides a way to avoid this boilerplate code: 
[t.Error()](https://golang.org/src/testing/testing.go?s=27660:27703#L776) and 
[t.Errorf()](https://golang.org/src/testing/testing.go?s=27799:27858#L782)

Let's take a look at the code.

```golang
func (c *common) Error(args ...interface{}) {
	c.log(fmt.Sprintln(args...))
	c.Fail()
}
```

(Source: [testing/testing.go](https://golang.org/src/testing/testing.go?s=27660:27703#L776))

As you can see, nothing really happens here except that the passed arguments are logged and then 
[Fail()](https://golang.org/src/testing/testing.go?s=23815:23838#L670) is called. Now let's replace 
[Log()](https://golang.org/src/testing/testing.go?s=27069:27110#L766) and 
[Fail()](https://golang.org/src/testing/testing.go?s=23815:23838#L670) with
[Error()](https://golang.org/src/testing/testing.go?s=27660:27703#L776) in our first example.

```golang
func TestValidateStringNotBlank(t *testing.T) {
    s := buggyFuncReturningBlankStr()

    if len(s) == 0 {
		t.Error("String returned by buggyFuncReturningBlankStr() is blank")
    }
}

func buggyFuncReturningBlankStr() string {
    return ""
}
```
```shell
$ go test
--- FAIL: TestValidateStringNotBlank (0.00s)
    validatorwitherror_test.go:9: String returned by buggyFuncReturningBlankStr() is blank
FAIL
exit status 1
FAIL    github.com/lrotermund/testing/pkg/validationwitherror   0.001s
```

Now let's look at [Errorf()](https://golang.org/src/testing/testing.go?s=27799:27858#L782) which 
calls the [c.log()](https://golang.org/src/testing/testing.go?s=25730:25763#L736) function with a 
formatted string to output the passed arguments in the specified formatting.

```golang
func (c *common) Errorf(format string, args ...interface{}) {
	c.log(fmt.Sprintf(format, args...))
	c.Fail()
}
```

(Source: [testing/testing.go](https://golang.org/src/testing/testing.go?s=27799:27858#L782))

Let's look at an example of how 
[Errorf()](https://golang.org/src/testing/testing.go?s=27799:27858#L782) can be used.

```golang
func TestPrintingFormattedError(t *testing.T) {
    input := "foobar"
    expected := "barfoo"

    s := buggyFuncReturningWrongStr(input)

    if s != expected {
		t.Errorf("assertion failed, expected %s, got %s", expected, s)
    }
}

func buggyFuncReturningWrongStr(s string) string {
    return "abcde"
}
```
```shell
$ go test
--- FAIL: TestPrintingFormattedError (0.00s)
    validatorwitherrorf_test.go:12: assertion failed, expected barfoo, got abcde
FAIL
exit status 1
FAIL    github.com/lrotermund/testing/pkg/validationwitherrorf   0.001s
```
