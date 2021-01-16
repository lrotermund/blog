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
        t.Error("String returned by buggyFuncReturningBlankStr() is blank")
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
[t.Error](https://golang.org/pkg/testing/#T.Error) function and the test is marked as failed - we'll 
look at how all this happens later.

It is important to note here that the test deliberately results in a failed test to illustrate the 
result of the [t.Error](https://golang.org/pkg/testing/#T.Error) function. Of course, the goal is 
always to have successful tests - in other words, to get the tests green at the end.

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
ways to mark a test as failed - let's dive into the Go standard library and start with the "Fail" 
function.

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

Why do we have so many code in here for a simple fail function? We can find the answer to this 
question already in the first few lines of Code. `if c.parent != nil` shows us that there may be a 
parent test that produced the current test. Let's have a look at the common struct (in a shortened 
form).



```golang
type common struct {
    ...
    mu     sync.RWMutex // guards this group of fields
	done   bool         // Test is finished and all subtests have completed.
	hasSub int32        // Written atomically.
	parent *common
    sub    []*T         // Queue of subtests to be run in parallel.
    ...
}
```
(Source: [testing/testing.go](https://golang.org/src/testing/testing.go?s=14406:14426#L384))

Ok, whats going on here? There is a common pointer `parent *common` that indicates a parent test and
there is a slice of  