---
title: "io - a pearl of the Go standard library"
tags: ["go-standard-library", "development", "golang", "io"]
date: 2021-01-12T21:02:34+01:00
draft: false
---

Input and output are probably the most frequently occurring tasks within a program and are therefore important modules of a programming language. In Go, C, C++ and many other languages byte operations are a common, if not the best choice for processing all kinds of data. 

{{< toc >}}

In this article I will take a closer look at the io library of Go. I take a look at the provided interfaces and functions and provide code examples to show the possibilities they offer – often some lines of code say more than thousand words.

## Inputs and outputs have a higher significance than one might initially assume

From writing and reading a file, to writing and reading an HTTP response, to processing database operations, all processes are based on I/O. 

The io standard library aims to abstract these existing processes and tasks, which appear in countless places, into a shared interface. In this way a separation of concept and implementation is achieved.

## io interfaces – a first look at Reader

One of the two essential components of I/O is the input. io offers the simplest possible interface for this, the reader.

The reader interface only contains the signature for the function Read.

```golang
type Reader interface {
    Read(p []byte) (n int, err error)
}
```
(Source: [golang.org/src/io/io.go](https://golang.org/src/io/io.go?s=3303:3363#L67))

To become aware of the possibilities of this simple interface you should look for its implementations. Fortunately io is very often used in the other packages of the standard library. For simplicity's sake, the following is the integration in the string package.

```golang
type Reader struct {
	s        string
	i        int64
	prevRune int
}
```
(Source: [golang.org/src/strings/reader.go](https://golang.org/src/strings/reader.go?s=446:576#L7))

```golang
func NewReader(s string) *Reader { return &Reader{s, 0, -1} }
```
(Source: [golang.org/src/strings/reader.go](https://golang.org/src/strings/reader.go?s=3567:3599#L144))

```golang
func (r *Reader) Read(b []byte) (n int, err error) {
	if r.i >= int64(len(r.s)) {
		return 0, io.EOF
	}
	r.prevRune = -1
	n = copy(b, r.s[r.i:])
	r.i += int64(n)
	return
}
```
(Source: [golang.org/src/strings/reader.go](https://golang.org/src/strings/reader.go?s=1042:1213#L28))

What happens in these three examples? The `strings.Reader` first provides a function `NewReader(s string)` which creates a Reader struct with the given string and returns the pointer. On the returned Reader pointer the function `Read(b []byte)` can be executed, which reads the slice size of `b` from the string `s` and writes it back to `b`. 

The result of `Read(b []byte)` is the number of bytes written to buffer `b`. So if this number is greater than zero, the read buffer can be used for further processing. Finally, check whether the error contained in the result is set and, if necessary, terminate the read operation.

This simple implementation of the reader interface results in an incredible number of possible uses. This generic reader can now be used in every imaginable scenario, because it doesn't matter what originally created the reader, the function Read fills the buffer you give it with bytes, no more and no less.

Let's take a look at some possible uses of the returned Reader `r`. 

As already mentioned, here is an example with the direct use of the `Read(b []byte)` function.

```golang
b := make([]byte, 124)
n, err := r.Read(b)
```

Via the package ioutil the function `ReadAll(r io.Reader)` can be used to read the entire content of `r`. As result a byte slice `[]byte` is returned.

```golang
b, err := ioutil.ReadAll(r)
```

If our Reader `r` contains a JSON string, it can be passed directly into a JSON decoder `NewDecoder(r io.Reader)`. With the function `Decode(v interface{})` our string can then be written into the passed pointer `gl`. 

```golang
type GoLibrary struct {
	Name, Link string
}
var gl GoLibrary
err := json.NewDecoder(r).Decode(&gl)
```

## io Writer – the generic way to generate output

Of course, the standard library also provides a generic way to output data – the Writer. The Writer interface also has a very simple structure, as shown in the following code of the standard library.

```golang
type Writer interface {
    Write(p []byte) (n int, err error)
}
```
(Source: [golang.org/src/io/io.go](https://golang.org/src/io/io.go?s=3794:3855#L80))

The integration of the Writer is as easy as the integration of the Reader, but it is always best to demonstrate this with a code example. 

Before we get to the code example, let's take a look at how the Writer is used, so that the concept and idea behind this decoupling can be clarified at the same time.

```golang
package main

import (
	"io"
	"log"
	"os"
	"strings"
)

func main() {
	r := strings.NewReader("some io.Reader stream to be read\n")

	if _, err := io.Copy(os.Stdout, r); err != nil {
		log.Fatal(err)
	}
}
```
(Source: [golang.org/pkg/io](https://golang.org/pkg/io/#Copy))

The reader `r` created in the above example is passed as a parameter to `io.Copy`, which results in the output of "some io.Reader stream to be read" when the program is executed. Where the output of an input takes place, a Writer can be assumed. 

Let's take a closer look at the `io.Copy` function and the public variable Stdout of the os library, which is passed as a writer parameter to the Copy function.

```golang
func Copy(dst Writer, src Reader) (written int64, err error) {
	return copyBuffer(dst, src, nil)
}
```
(Source: [golang.org/src/os/file.go](https://golang.org/src/os/file.go?s=2156:2335#L54))

```golang
var (
	Stdin  = NewFile(uintptr(syscall.Stdin), "/dev/stdin")
	Stdout = NewFile(uintptr(syscall.Stdout), "/dev/stdout")
	Stderr = NewFile(uintptr(syscall.Stderr), "/dev/stderr")
)
```
(Source: [golang.org/src/os/file.go](https://golang.org/src/os/file.go?s=2156:2335#L54))

The variable Stdout is of type File associated with one of the three standard data streams in the UNIX operating system, or similar. 

But why can a variable of type File be passed as a parameter in a function that expects a Writer? 

The answer can be found in the os library, the struct File is developed against the interface Writer and has the function Write.

```golang
func (f *File) Write(b []byte) (n int, err error) {
	if err := f.checkValid("write"); err != nil {
		return 0, err
	}
	n, e := f.write(b)
	if n < 0 {
		n = 0
	}
	if n != len(b) {
		err = io.ErrShortWrite
	}

	epipecheck(f, e)

	if e != nil {
		err = f.wrapErr("write", e)
	}

	return n, err
}
```
(Source: [golang.org/src/os/file.go](https://golang.org/src/os/file.go?s=4844:4893#L139))

To complete this example, we now change the `os.File` Writer to a `bytes.Buffer` Writer. This change causes the buffer, which is now passed to the `io.Copy` function, to be filled with the string. The String function of the buffer should now return the string of the reader `r`.

```golang
package main

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"strings"
)

func main() {
	r := strings.NewReader("some io.Reader stream to be read\n")
	var b bytes.Buffer

	if _, err := io.Copy(&b, r); err != nil {
		log.Fatal(err)
	}

	fmt.Println(b.String())
}
```

## My conclusion about the io library

Input and output are the basics of a computer - what should it calculate if it receives no input and what should it output if it has no output medium? Even today in software architecture systems are still decoupled according to the [IPO model](https://en.wikipedia.org/wiki/IPO_model) and this is exactly what the team behind Go has created with the io library.

It is definitely worth taking a deeper look behind the scenes of io. I am convinced that some of the structs in Go projects could be enriched with the interfaces offered.

In the upcoming Go projects I am involved in, I will be thinking more often about whether I can use the io interfaces for myself to write simpler, more generic and more interchangeable code.

What do you think about the io library and do you use it in your projects? Your opinion interests me and if you feel like talking about it, please leave a comment.