---
type: post
title: "Deferred code execution in PHP, C and Rust – like in Go"
tags: ["golang", "php", "c", "rust", "development"]
date: 2023-10-26T12:40:09+02:00
images: ["/assets/pexels-pixabay-277458.webp"]
image_alt: |
    Greyscale photography of several clocks on posts in front of a forest.
description: |
    Go's defer keyword was a game changer. Let's see if we can implement it in
    other languages like PHP, C and Rust as well!
summary: |
    Make your code more readable with Golang's defer keyword in PHP, C and
    Rust. Learn how to implement it easily and efficiently. Start improving your
    code today!
toc: false
draft: false
---

Since the release of the Go language, there has been a new tool, the `defer`
keyword, to ensure that certain code is executed when a function is exited.
This simply gives Go developers the ability to clean up code that needs to be
cleaned up, such as file handles, various network connections, or even
specialized processes within the domain.

Wouldn't it be nice to have a similar tool in PHP, C or Rust? After all, file
handles & network connections need to be closed and processes from the
corresponding domain need to be finished.

{{< toc >}}

## What makes go's defer so special?

There are built-in constructs in other languages, such as C#'s `using` keyword,
Java's try-with-resource, C++'s
{{< abbr "RAII" "Resource Acquisition Is Initialization" >}}, and Python's
`with` keyword, that perform similar tasks to the `defer` keyword, but not with
its capabilities. In these languages, the corresponding constructs are often
used to simply free resources, which is only a fraction of what `defer` does.

### Discover defer: Golang's handy feature

You've never seen go's `defer` before, and now you're wondering what the hell
I'm talking about? Then let's take a quick look at `defer` and the wonderful new
way of working with resources that it has brought with it.

In the following example, we open a file in go, which creates a handle that we
can use to read from or write to the file. File handles must always be closed,
otherwise they remain, taking up more system resources and possibly causing
subsequent errors, since no other user and no other program can access these
files. 

How would this be solved without `defer`? Basically, the resource had to be
closed at the end of the function and at any point that left the function early.

```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open("some-integers.txt")
	if err != nil {
		fmt.Println("Error opening file:", err)

		return
	}

	scanner := bufio.NewScanner(file)

	if !scanner.Scan() {
		fmt.Println("Failed to read first line.")
        file.Close()

		return
	}

	firstLineValue, err := strconv.Atoi(scanner.Text())
	if err != nil || firstLineValue >= 42 {
		fmt.Println("First line is not a number below 42.")
        file.Close()

		return
	}

	if !scanner.Scan() {
		fmt.Println("Failed to read second line.")
        file.Close()

		return
	}

	if crossfoot(scanner.Text()) > 10 {
		fmt.Println("Crossfoot of second line is greater than 10.")
        file.Close()

		return
	}

    file.Close()
	fmt.Println("Success!")
}

func crossfoot(s string) int {
	sum := 0
	for _, r := range s {
		value, err := strconv.Atoi(string(r))
		if err == nil {
			sum += value
		}
	}

	return sum
}
```

A lot of unnecessary code, right? This is where `defer` comes in. Immediately
after opening the file, we tell go with `defer` that no matter how the function
is exited, i.e. with a panic, a return, or if it was simply run to the end, it
should please close our file.

```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open("some-integers.txt")
	if err != nil {
		fmt.Println("Error opening file:", err)

		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	if !scanner.Scan() {
		fmt.Println("Failed to read first line.")

		return
	}

	firstLineValue, err := strconv.Atoi(scanner.Text())
	if err != nil || firstLineValue >= 42 {
		fmt.Println("First line is not a number below 42.")

		return
	}

	if !scanner.Scan() {
		fmt.Println("Failed to read second line.")

		return
	}

	if crossfoot(scanner.Text()) > 10 {
		fmt.Println("Crossfoot of second line is greater than 10.")

		return
	}

	fmt.Println("Success!")
}

func crossfoot(s string) int {
	sum := 0
	for _, r := range s {
		value, err := strconv.Atoi(string(r))
		if err == nil {
			sum += value
		}
	}

	return sum
}
```

Not only does the code now contain less boilerplate, it is also more
maintainable and secure. There is now only one place responsible for closing the
file.

When I read this code now, whether in a code review or because I want to
understand and extend the code, I can check off "close file" as a task in my
head when I encounter the `defer`. And as I extend the function with more
checks, I don't have to think about closing the file.

### Close TCP connections with go's defer

In the following example, our Go code accepts incoming
{{< abbr "TCP" "Transmission Control Protocol" >}} connections on port 5000 and
closes them with `defer` after the connection is processed.

`defer` gives Go control over a {{< abbr "LIFO" "Last-in-First-out" >}} stack of
deferred functions that will be processed no matter how and where the function
is exited.

Deferred instructions to clean up or complete processes are placed as early as
possible and as late as necessary, usually right after the code that needs to be
cleaned up or completed. This approach has several advantages. 

1. it is not forgotten, and
2. once deferred, the cleanup or completion task is out of mind, so you can
focus on the business logic

In the following example you will find the `defer` keyword in the
`handleConnection` function.

```go
package main

import (
    "fmt"
    "net"
)

func main() {
    l, err := net.Listen("tcp", ":5000")
    if err != nil {
        fmt.Println("Failed to initialize a TCP listener on port 5000", err)

        return
    }

    fmt.Println("Started TCP server on port 5000")

    for {
        c, err := l.Accept()
        if err != nil {
            fmt.Println("Failed to accept incoming TCP connection", err)

            continue
        }

        go handleConnection(c)
    }
}

func handleConnection(c net.Conn) {
    defer c.Close()

    buf := make([]byte, 1024)
    _, err := c.Read(buf)
    if err != nil {
        fmt.Println(err)
        
        return
    }

    fmt.Printf("Received: %s", buf)
}
```

#### Binding random ports with go's net.Listen

Another quick tip for `net.Listen`, if the port is not important, you can define
a listener without specifying a port, or with port 0, this will automatically
assign a random, available port.

```go
package main

import (
	"fmt"
	"net"

	"github.com/pkg/errors"
)

func main() {
    p, err := bindRandomPort()
    if err != nil {
        fmt.Println(err)

        return
    }

    fmt.Printf("Bind random port %d", p)
}

func bindRandomPort() (int, error) {
    l, err := net.Listen("tcp", ":0")
    if err != nil {
        return 0, errors.Wrap(err, "Failed to bind a random port")
    }
    defer l.Close()

    addr := l.Addr()

    return addr.(*net.TCPAddr).Port, nil
}
```

### Compensation of a failed transaction with go's defer

As noted above, `defer` can be used not only for the classic cleanup of
resources and connections, but for just about anything that needs to happen at
the end of a function, no matter how the function is exited.

In the following e-commerce example, our
{{< abbr "API" "Application Programming Interface" >}} has received a
`create order` command. However, during processing, we notice the race condition
of a slightly earlier order that has already ordered all available items. At
this point, our transaction with the order service has failed, and we need to
compensate for the failed order.

The following code is for illustrative purposes only and does not represent a
valid, complete & secure {{< abbr "API" "Application Programming Interface" >}}.
You can still rebuild it this way and play around with the `defer`. Let's start
with the `main.go`:

```go
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/lrotermund/defer-compensation/internal/order"
	"github.com/lrotermund/defer-compensation/internal/response"
	"github.com/lrotermund/defer-compensation/internal/stock"
)

type (
	Order struct {
		ArticleNumber string `json:"articleNumber"`
		Count         int    `json:"count"`
	}

	API struct {
		StockService StockGetter
		OrderService OrderService
	}
)

type (
	StockGetter interface {
		GetStock(articleNumber string) int
	}

	OrderService interface {
		CreateOrder(articleNumber string, count int) error
		AbandonOrder(articleNumber string)
	}
)

func StatusLoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ww := &response.ResponseWriterWithStatus{ResponseWriter: w}
		next.ServeHTTP(ww, r)
	})
}

func main() {
	api := API{
		StockService: stock.NewService(),
		OrderService: order.NewService(),
	}

	http.HandleFunc("/create-order", api.createOrderHandler)

	fmt.Println("Starting server on port 8080")

	err := http.ListenAndServe(
		":8080",
		StatusLoggingMiddleware(http.DefaultServeMux),
	)
	if err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}

func (a *API) createOrderHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)

		return
	}

	var order Order

	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&order)
	defer r.Body.Close()

	if err != nil {
		http.Error(w, "Failed to parse order", http.StatusBadRequest)

		return
	}

	defer func() {
		status := w.(*response.ResponseWriterWithStatus).Status()

		if status != http.StatusCreated {
			a.OrderService.AbandonOrder(order.ArticleNumber)
		}
	}()

	stock := a.StockService.GetStock(order.ArticleNumber)
	if stock-order.Count < 0 {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("Order abandoned, our stock is too low!"))

		return
	}

	err = a.OrderService.CreateOrder(order.ArticleNumber, order.Count)
	if err != nil {
		http.Error(w, "Failed to create order", http.StatusInternalServerError)

		return
	}

	w.WriteHeader(http.StatusCreated)
	w.Write([]byte("Order created successfully!"))
}
```

The `defer` keyword performs several tasks here, freeing up resources and
compensating and documenting a failed order. Every event in an event-sourced
system is relevant, so the example is figuratively relevant. 

The {{< abbr "API" "Application Programming Interface" >}} uses a middleware to
track status changes to the response. Here is the `internal\response` package:

```go
package response

import "net/http"

type ResponseWriterWithStatus struct {
	http.ResponseWriter
	status int
}

func (w *ResponseWriterWithStatus) WriteHeader(code int) {
	w.ResponseWriter.WriteHeader(code)
	w.status = code
}

func (w *ResponseWriterWithStatus) Status() int {
	return w.status
}

func (w *ResponseWriterWithStatus) Write(b []byte) (int, error) {
	if w.status == 0 {
		w.status = http.StatusOK
	}

	return w.ResponseWriter.Write(b)
}
```

The stock is returned by a simple service that always returns a zero value as a
result.

```go
package stock

type Service struct{}

func NewService() *Service {
	return new(Service)
}

func (s *Service) GetStock(articleNumber string) int {
	return 0
}
```

And last but not least, the minimalist ordering service:

```go
package order

import (
	"log"

	"github.com/pkg/errors"
)

type Service struct{}

func NewService() *Service {
	return new(Service)
}

func (s *Service) CreateOrder(articleNumber string, count int) error {
	return errors.New("something went wrong!")
}

func (s *Service) AbandonOrder(articleNumber string) {
	log.Println("order abandoned!")
}
```

Enough of Go's defer, beautiful as it is! Now let's see if we can translate it
into other languages.

## Go's defer in PHP

To use the `defer` keyword in PHP, we take advantage of PHP's object orientation
and its [destructor](https://www.php.net/manual/en/language.oop5.decon.php). To
keep the handling simple and not unnecessarily bloated, we simply use a global
function that can be called from anywhere, making it effectively a keyword.

But how do we combine a global function with a destructor? Simple, with an
anonymous class! All we need is a {{< abbr "LIFO" "Last-in-First-out" >}} stack
that we can process in the destructor, for which PHP provides us with the
[SplStack](https://www.php.net/manual/en/class.splstack.php).

```php
function defer(?SplStack &$context, callable $callback): void
{
    $context ??= new class() extends SplStack {
        public function __destruct()
        {
            while ($this->count() > 0) {
                \call_user_func($this->pop());
            }
        }
    };

    $context->push($callback);
}
```

I did not come up with this charming solution myself, there is a brilliant
package called [php-defer/php-defer](https://github.com/php-defer/php-defer),
which is based on the idea of
[tito10047/php-defer](https://github.com/tito10047/php-defer), but implements it
much more cleverly.

### Install php-defer

To use php-defer, all you need is a short composer command:

```sh
composer require "php-defer/php-defer:^3.0|^4.0|^5.0"
```

If you haven't heard of the Composer tool, you should definitely check it out.
It's easy to integrate into projects, and it's easy to run from docker if you
don't want to install it locally. 

I also use Composer only in the development container of my projects. There is
also a section on
[getting started with composer](https://getcomposer.org/doc/00-intro.md).

### Deferred code execution in PHP with php-defer 

The following example will show you how php-defer works. In the example we have
a Symfony application in which a command, which could be triggered by a cron, is
responsible for loading the latest orders and storing them serialized in an S3
bucket to make them available to other applications in an archived form. How
useful all this is is debatable, but it is a simple and reasonably realistic
example.

```php
<?php

declare(strict_types=1);

namespace App\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use App\Repository\OrderRepository;
use App\Repository\OrderService;
use League\Flysystem\FilesystemWriter;

#[AsCommand(name: 'app:archive-orders')]
final class ArchiveOrdersCommand extends Command
{
    public function __construct(
        private readonly OrderRepository $orderRepository,
        private readonly OrderService $orderService,
        private readonly FilesystemWriter $orderArchive,
    ) {
        parent::__construct();
    }

    protected function execute(
        InputInterface $input,
        OutputInterface $output,
    ) {
        $orders = $this->orderRepository->findNewOrders();
        defer(
            $_,
            fn() => $this->orderService->markAsArchived($orders),
        );

        $serializedOrders = serialize($orders);

        $tempFilePath = tempnam(sys_get_temp_dir(), 'orders_');
        defer($_, fn() => unlink($tempFilePath));

        file_put_contents($tempFilePath, $serializedOrders);

        $stream = fopen($tempFilePath, 'rb');
        defer($_, fn() => fclose($stream)); 

        $this->orderArchive->writeStream
            (basename($tempFilePath),
            $stream,
        );

        return Command::SUCCESS;
    }
}
```

In the example, the `defer` function has been called three times, and the
following {{< abbr "LIFO" "Last-in-First-out" >}} stack has been created:

1. mark orders as archived
2. delete temporary file
3. close stream to temporary file

You may also have noticed the somewhat unusual `defer` parameter syntax, which
includes this `$_` at the beginning. This is an homage to Go's syntax of dealing
with unneeded function return values. For example, if a function returns a value
and an error, but I don't need the value, I can just ignore it locally:

```go
func foobar() (string, error) {
    return "foo", errors.New("bar!")
}

func main() {
    _, err := foobar()
    if err != nil {
        panic(err)
    }
}
```

Basically, `$_` is just a new variable in the current context. But because this
context is usually not used and only `defer` needs it, we write it this way.
This syntax is also recommended by php-defer.

So before the `Command::SUCCESS` function returns, first the stream is closed,
then the temporary file is cleaned up and finally the given orders are marked
as "archived" via a service.

### Understanding the implementation of php-defer

Let's take a line-by-line look at how the team behind php-defer,
[Bartłomiej Krukowski](https://github.com/bkrukowski),
[Trevor N. Suarez](https://github.com/Rican7), and
[djunny](https://github.com/djunny) wrote this
{{< abbr "IMHO" "In My Humble Opinion" >}} elegant code.

```php
function defer(?SplStack &$context, callable $callback): void
```

To use the deconstructor at the right time, `defer` must exist in the context of
the function in which it is to be deconstructed by the garbage collector. This
is possible by taking a reference to an (initially empty) variable `$context`
from that context. When the function is exited, this variable is also
deconstructed, which we can use in the following.

In addition, we get a simple `callable` with the `$callback` to place on our
{{< abbr "LIFO" "Last-in-First-out" >}} stack to be executed during
deconstruction.

```php
$context ??= new class() extends SplStack {
```

Using the null coalesce assignment operator `??=`, PHP detects on the first call
of `defer` that `$context` is still null, and instantiates and assigns a new
anonymous class to the context that inherits from PHP's
[SplStack](https://www.php.net/manual/en/class.splstack.php).

Any further calls to `defer` will cause this line to be skipped by the null
coalesce assignment operator.

This is one of the few, extremely intelligent uses of an anonymous class that
I've come across.

```php
$context->push($callback);
```

Now we jump to the end of the `defer` function. At this point, a new entry with
the passed `$callback` is placed on our
[SplStack](https://www.php.net/manual/en/class.splstack.php). If `defer` is
called multiple times within a function, this is the only code that will be
executed from the second call of `defer` on. From the second call on, the
`$context` is no longer empty, so the initialization is completely skipped.

```php
public function __destruct()
```

If we go back to our anonymous stack class, we will first find the `__destruct`
function. The two underscores "__" in front of "destruct" indicate that this
function is a
[PHP magic method](https://www.php.net/manual/en/language.oop5.magic.php). PHP
will call this function via its garbage collector as soon as there is
[no longer a reference to the object](https://www.php.net/manual/en/language.oop5.decon.php#object.destruct)
of our anonymous class.

```php
while ($this->count() > 0) {
```

The function `count` comes from the double linked list parent class
[SplStack](https://www.php.net/manual/en/class.splstack.php) and it counts all
remaining entries of the stack. This means that the body of the while loop is
executed until the stack has no more entries.

```php
\call_user_func($this->pop());
```

`pop`, also a function from our stack, allows us to take the next item from our
stack and return it. The stack size has now decreased. 

Since we have a stack of `callable` items, `pop` also returns a `callable`. We
can now execute the `callable` using the
[PHP function `\call_user_func`](https://www.php.net/manual/en/function.call-user-func.php).
This will execute the callback specified by the user in the context of the
calling function.

## Go's defer in C

Let's move on to C, which is in stark contrast to PHP. We lack the object
orientation that simplified the defer implementation before, as well as various
automatisms that, for example, automatically close a file handle or a database
connection for us when a request is finished.

However, this is usually what many people are looking for at the same time. Less
automation, less magic, more control. This is exactly where I found the
implementation of a defer so interesting. It allows us to write readable &
magic-free code that has so much convenience due to deferred code execution.

In C it gets a bit uncomfortable for some clean coders because we use `goto` and
a macro. The implementation is as simple as possible and shows a clever way to
work in C with a defer-like solution, and because we don't have a destructor
like PHP, we fall back on simpler tools of the language.

I took this implementation from the [Twitch](https://www.twitch.tv/tsoding) and
[Youtube](https://www.youtube.com/@TsodingDaily) channel Tsoding by
[Alexey Kutepov](https://github.com/rexim). Alexey regularly uses the following
`return_defer` construct. It is important to note that in this simple
implementation, unlike go's defer, no {{< abbr "LIFO" "Last-in-First-out" >}}
stack is built.

### The `return_defer` marco

Let's start with the macro, the flexible pivot point that all functions can use:

```c
#define return_defer(value) do { result = (value); goto defer; } while(0)
```

The macro is kept fairly simple and follows common implementation patterns. Our
statements are preceded by a `do { ... while(0)` to make the macro call safe.
Inside the one-time loop, `result = (value);` is used to set the result that our
function returns, and then the execution jumps to the `defer` label of our
function via `goto defer;`. It is important that the `result` exists as a
variable inside the function, as well as the defer label.

### The `return_defer` implementation

Now let's look at how it might be used. Let's say we need a function that
acquires a lock on a given parameter and releases it at the end. The parameter
is then used to perform "complex" calculations. If a calculation does not
produce the desired result, we exit with an early `return_defer`.

```c
int calculate_and_return(int number) {
    int result;
    
    char lock[50];
    snprintf(lock, sizeof(lock), "some-calc-lock_%d", number)

    bool lockOK = lock_acquire(lock);
    if (!lockOK) {
        return_defer(-1);
    }
    
    if (number < 0) {
        return_defer(-1);
    }
    
    if (number % 2 == 0) {
        return_defer(number / 2);
    } else {
        return_defer(3 * number + 1);
    }

defer:
    if (lockOK) {
        lock_release(lock);
    }

    return result;
}

int main() {
    int val = calculate_and_return(3);
    printf("Result for 3: %d\n", val);

    val = calculate_and_return(-5);
    printf("Result for -5: %d\n", val);

    val = calculate_and_return(10);
    printf("Result for 10: %d\n", val);

    return 0;
}
```

As simple as the example is, you can see that even in C it can be handy to have
a defer-like construct that allows us to write important code only once, so that
it always runs and we don't have to worry about it anymore.

### Ensuring MongoDB connection closure with `return_defer`

Now let's look again at a more complex and realistic example – closing a MongoDB
connection. Below we have a C script that reads the new orders from our MongoDB
that are not yet marked as processed, and then prints them to the terminal. With
the `return_defer` macro in the main function, we make sure that the database
connection is closed on all early returns.

```c
#include <stdio.h>
#include <stdlib.h>
#include <bson.h>
#include <mongoc.h>

#define return_defer(value) do { result = (value); goto defer; } while(0)

typedef struct {
    mongoc_client_t *client;
} MongoDBConnection;

MongoDBConnection* open_mongodb_connection() {
    mongoc_init();

    MongoDBConnection *conn = malloc(sizeof(MongoDBConnection));
    conn->client = mongoc_client_new("mongodb://mongodb:27017");

    if (!conn->client) {
        free(conn);

        return NULL;
    }

    return conn;
}

void close_mongodb_connection(MongoDBConnection* conn) {
    if (!conn) return;

    if (conn->client) {
        mongoc_client_destroy(conn->client);
    }

    free(conn);
    mongoc_cleanup();
}

typedef struct {
    int orderID;
    char* item;
    int processed;
} Order;

Order* fetch_unprocessed_orders(
    MongoDBConnection* conn,
    int* numOrders,
    int limit
) {
    if (!conn || !conn->client) return NULL;

    mongoc_collection_t *collection;
    mongoc_cursor_t *cursor;
    const bson_t *doc;
    bson_t *filter = BCON_NEW("processed", BCON_INT32(0));

    collection = mongoc_client_get_collection(conn->client, "shop", "orders");
    cursor = mongoc_collection_find_with_opts(collection, filter, NULL, NULL);

    Order* orders = (Order*) malloc(sizeof(Order) * limit);
    *numOrders = 0;

    while (mongoc_cursor_next(cursor, &doc)) {
        char *str = bson_as_canonical_extended_json (doc, NULL);
        printf ("%s\n", str);
        bson_free (str);

        bson_iter_t iter;
        
        if (
            bson_iter_init_find(&iter, doc, "orderID")
            && BSON_ITER_HOLDS_INT32(&iter)
        ) {
            orders[*numOrders].orderID = bson_iter_int32(&iter);
        }

        if (
            bson_iter_init_find(&iter, doc, "item")
            && BSON_ITER_HOLDS_UTF8(&iter)
        ) {
            orders[*numOrders].item = strdup(bson_iter_utf8(&iter, NULL));
        }

        if (
            bson_iter_init_find(&iter, doc, "processed")
            && BSON_ITER_HOLDS_INT32(&iter)
        ) {
            orders[*numOrders].processed = bson_iter_int32(&iter);
        }

        (*numOrders)++;
    }

    bson_destroy(filter);
    mongoc_cursor_destroy(cursor);
    mongoc_collection_destroy(collection);

    return orders;
}

int main() {
    int result = 0; 

    MongoDBConnection* conn = open_mongodb_connection();
    if (!conn) {
        printf("Failed to establish connection.\n");
        return_defer(-1);
    }

    int numOrders;
    Order* orders = fetch_unprocessed_orders(conn, &numOrders, 100);
    if (!orders) {
        printf("Error, missing mongodb client.\n");

        return_defer(0);
    }

    if (numOrders == 0) {
        printf("No new orders found.\n");

        return_defer(0);
    }

    printf("Unprocessed Orders:\n");
    for (int i = 0; i < numOrders; i++) {
        printf(
            "Order ID: %d, Item: %s\n",
            orders[i].orderID,
            orders[i].item
        );

        free(orders[i].item);
    }

    return_defer(0);

defer:
    if (orders) {
        free(orders);
    }

    if (conn) {
        close_mongodb_connection(conn);
        printf("Database connection closed.\n");
    }

    return result;
}
```

#### Try the example with Docker

If you want to try the example, you can simply set up a MongoDB via Docker and
create the database, as well as the collection from the example, and populate it
with sample orders. Make sure that the MongoDB and the C script are on the same
bridge network.

```sh
docker run -p 27017:27017 --name some-mongo -d mongo --net deferc
```

Next, you build the following Docker image and run it to execute the script and
retrieve the orders you previously created in MongoDB.

```dockerfile
FROM ubuntu:mantic@sha256:13f233a16be210b57907b98b0d927ceff7571df390701e14fe1f3901b2c4a4d7

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    clang \
    pkg-config \
    libmongoc-1.0-0 \
    libbson-1.0-0 \
    libmongoc-dev \
    libbson-dev

ENV PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

WORKDIR /app

COPY . .

RUN clang $(pkg-config --cflags libmongoc-1.0) -o ./build/deferc ./src/main.c $(pkg-config --libs libmongoc-1.0)

CMD ["./build/deferc"]
```

To build the image just run `docker build` within the folder of the Dockerfile:

```sh
docker build -t defer-c:dev .
```

To run the script just run the container within the "deferc" network:

```sh
docker run --net deferc defer-c:dev
```

## Go's defer in Rust

From the object-oriented PHP to simple C, now with Rust another object-oriented
language. In my opinion, Go and Rust often find a similar developer community
and it is not uncommon for discussions to break out on the Internet about which
language is better. But that's not the point of this post. Rather, I want to use
the best components of all languages in my daily work, as much as possible.
And with respect to Go's `defer`, this is definitely possible with Rust.

As with PHP, we can again rely on the deconstructor provided by the drop trait
in Rust (a trait is usually called an interface in other languages). The
difference to PHP is most obvious in the implementation, because except for the
destructor, the two implementations are not similar at all.

As in C, in Rust we rely on a defer macro. Inside the macro, we initialize an
instance that implements the drop trait and contains a closure. ***Now it gets
exciting***. Where we relied on the {{< abbr "LIFO" "Last-in-First-out" >}}
[SplStack](https://www.php.net/manual/en/class.splstack.php) in PHP, we now take
advantage of Rust's automatic {{< abbr "LIFO" "Last-in-First-out" >}} memory
deallocation – espacially for implementation's of the drop trait.

Essentially, each call to our defer macro creates an object, and all of those
objects are cleaned up and deallocated from the end of the function to the
beginning of the function.

The following implementation once again, as with PHP and C, goes back to a
smarter mind than mine and that is
[Huon Wilson](https://huonw.github.io/) and
[his answer on StackOverflow](https://stackoverflow.com/a/29963675).

### The `defer!` macro

As mentioned before, the Rust implementation of Go's `defer` is all about a
macro, as well as another helper macro.

```rust
macro_rules! expr { ($e: expr) => { $e } } // tt hack
macro_rules! defer {
    ($($data: tt)*) => (
        let _scope_call = ScopeCall {
            c: Some(|| -> () { expr!({ $($data)* }) })
        };
    )
}
```

Our defer macro expects a pattern `$data` of type token tree `$data: tt` and
that arbitrarily often `$($data: tt)*`. A token is meant to be somewhat
abstract, similar to the tokens used in lexical analysis during compilation.
When several of them come together, commands and expressions are created, from
that moment on we have a token tree. So exactly what we want to pass when we
call `defer`, an example follows.

There's a lot going on in the body of the macro, so let's break it down piece by
piece. Let's start with the inside and work our way out. Inside another macro
`expr!` is called with a block of statements `({ ... })`. The statements come
from disassembling our passed token tree into individual statements `$($data)*`.

The result of this helper macro will be the body of a parameterless closure `||`
with no return value `-> ()`. This closure is wrapped by the `Some()`-Option
enum and passed as a value to the `c` field of the `ScopeCall` struct.

The `ScopeCall` we just initialized is now written to the variable
`_scope_call`. With this variable we are only interested in its lifetime in the
function context and it is not used anywhere else, so we have to ignore the
corresponding compiler warning with the `_` prefix. 

```rust
struct ScopeCall<F: FnOnce()> {
    c: Option<F>
}
impl<F: FnOnce()> Drop for ScopeCall<F> {
    fn drop(&mut self) {
        self.c.take().unwrap()()
    }
}
```

Now let us take a look at the no less important component, the previously
initialized `ScopeCall` structure. This is the struct that implements the drop
trait and thus plays a central role in the operation of the `defer!` macro.

The struct has a single field `c` of the enum type `Option<>` which wraps the
generic type `F`. The generic type `F` is defined in the struct signature and
must implement the `FnOnce` trait, which means that you can pass anything as `F`
[that can be called at most once](https://doc.rust-lang.org/std/ops/trait.FnOnce.html).

Finally, we find the implementation of the drop trait on the `ScopeCall`. Here
we can assume that our `Option<F>` field contains a value, since we populate it
with the `Option` enum `Some` inside the `defer!` macro. Therefore, we use
`self.c.take()` to take the closure `F` from the `Option` and assign the new
`Option` enum `None` so that the closure `c` is empty from now on.

This `Option<T>`, which `take` returns, corresponds to our defer-closure, we now
have to unpack it by `unwrap()` to be able to call it directly, which can be
recognized by the last pair of parentheses `()`.

#### The `tt` token tree hack

The mentioned "tt hack", i.e. `macro_rules! expr { ($e: expr) => { $e } }` is
used in the defer macro to treat the passed token trees as one big expression
bundled into one block. Essentially, this makes the defer macro call more
flexible and allows blocks of expressions to be processed correctly in addition
to single expressions. 

It's a subtlety of Rust that forces us to handle expressions this way, best to
try juggling the defer parameters yourself, then you might understand the
problem better than I can explain it, Rust is not my language of choice.  

### The `defer!` implementation

Now let's look at a simple example of how the defer macro might be used. It is
important to note that I am not a Rust developer, but I plan to learn Rust so
that I can make better use of it. The latter also caused me a lot of problems
when writing the example, as Rust's borrowing mechanism had problems with
borrowing the mutable file for the defer macro.

If you are a Rust developer, I would love to see better and different ways to
play around with the defer macro to get the most out of this great concept in
Rust. Maybe you have a tip for me on how to better understand the borrow
mechanism.

Now for the example. In the example, a TCP listener is started on port 7878 and
writes a request of more than 100 bytes to a file. The success response, as well
as the flushing of the file, are in defer blocks.

```rust
use std::fs::File;
use std::io::{self, Write, Read};
use std::net::TcpListener;

struct ScopeCall<F: FnOnce()> {
    c: Option<F>
}
impl<F: FnOnce()> Drop for ScopeCall<F> {
    fn drop(&mut self) {
        self.c.take().unwrap()()
    }
}

macro_rules! expr { ($e: expr) => { $e } }
macro_rules! defer {
    ($($data: tt)*) => (
        let _scope_call = ScopeCall {
            c: Some(|| -> () { expr!({ $($data)* }) })
        };
    )
}

fn main() -> io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:7878")?;
    println!("Server listening on port 7878...");

    let (mut stream, addr) = listener.accept()?;
    println!("Connection received from: {}", addr);

    let mut buffer = [0; 1024];
    let bytes_read = stream.read(&mut buffer)?;
    if bytes_read <= 100 {
        stream.write_all(b"Error: Received data is less than or equal to 100 bytes")?;

        return Ok(());
    }

    defer! {
        let response = format!("Finished processing {} bytes via TCP", bytes_read);
        let _ = stream.write_all(response.as_bytes());
    }

    let message = String::from_utf8_lossy(&buffer[..bytes_read]);
    let mut file = File::create("defer-rust.txt")?;
    file.write_all(message.as_bytes())?;

    defer! {
        let _ = file.flush();
        let _ = file.sync_all();
    }

    Ok(())
}
```

To start the server itself, create a new binary project with cargo:

```sh
cargo new defer_rust --bin
```

Then copy my example into `src/main.rs` and build it, again with cargo:

```sh
cargo build
```

Now you can start the server via `./target/debug/defer_rust` and send a netcat
request of exactly 101 bytes to test the functionality. Feel free to remove a
character to provoke an error.

```sh
nc localhost 7878 <<< "In Go, defer schedules calls to run before the enclosing function ends. A powerful tool for cleanup\!"
```

### The scopeguard crate

If you don't want to implement the macro yourself, there is also
[**scopeguard**, a crate that provides defer](https://crates.io/crates/scopeguard).

You can easily add scopeguard via cargo:

```sh
cargo add scopeguard
```

## My conclusions

Go's defer is a really handy tool. The concept behind defer is another tool that
allows you as a developer to write more readable and secure code. I think it's
worth adapting this concept to other languages and playing around with the
possibilities that arise from this implementation.

In PHP and C, it worked very well for me, and in Rust, I had problems with a
good implementation due to my skill issue. I will work on that though.

Last but not least, I am interested in your perspective. What do you think about
defer? Have you ever tried to implement it in another language, or is there
already an implementation for that language? Feel free to drop me a line on
[Mastodon](https://social.tchncs.de/@lukasrotermund)!

