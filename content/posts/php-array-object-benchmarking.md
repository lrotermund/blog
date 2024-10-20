---
type: post
title: "PHP arrays have driven me mad"
tags: ["php", "c", "benchmarking", "development"]
date: 2024-09-01T20:00:10+02:00
images: ["/assets/923a6a.webp"]
image_alt: |
    This meme shows a man, labeled "LUKAS," frantically pointing at a chaotic
    board covered with red string and notes, as if trying to explain a complex
    conspiracy. The board is filled with programming terms like
    "array<string, int>", "IMMUTABILITY", "Sets", "ArrayObject", and more. The
    image humorously represents the confusion or intensity of trying to make
    sense of a complex research topic filled with related terms and ideas.
description: |
    Larry Garfield's 'Never* use arrays' talk really confused me. How can it be
    that objects in PHP save 50% memory? How can every PHP developer not be
    excited about this? And why don't you hear about it anywhere?
summary: |
    Larry Garfield's 'Never* use arrays' talk really confused me. How can it be
    that objects in PHP save 50% memory? How can every PHP developer not be
    excited about this? And why don't you hear about it anywhere?
toc: false
draft: false
---

A few weeks ago, while I was doing the dishes or folding the laundry (I can't
really remember what I was doing), I was scrolling through my YouTube home
screen, hunting for fresh educational content for software developers, as I
always do, when I am cleaning, cooking or shopping.
['Never* use arrays'](https://www.youtube.com/watch?v=nNtulOOZ0GY) from the
PHPKonf. That was my pick of the day. And it was the pick that drove me mad
(until today).

[Larry Garfield](https://www.garfieldtech.com/), a member of the
[PHP-FIG](https://www.php-fig.org/) Core Committee, was the speaker. This made
it even more interesting. So I watched and watched. The first third of the talk
was about why arrays aren't your friend, and the traps they contain. The next
part was about available alternatives to insecure plain old PHP arrays. Larry
showed how to implement modern[^modern] and type-safe arrays, sets and sequences
in PHP. At the end, Larry presented some benchmarks and talked about over 50%
memory savings - that was the moment I stopped the video and posted on our
team's slack channel that we should stop using boring, plain old native arrays
to hold data and mappings. But... I should have listened more closely to what
Larry was saying. That's what happens when you listen to this kind of talk while
you're doing your chores.

But let's look at the basics first.

{{< toc >}}

## PHP arrays are not your friend

Arrays (as a basic theoretical construct) are THE way to hold a list, set or map
of data - in almost every common programming language. As always, there may be
exceptions. What an array is varies from language to language.

In languages such as Fortran, C or C++, arrays have direct access to blocks of
memory. The languages offer zero (to a little in C++) security when working with
arrays. And developers have to manage and free memory blocks on their own,
because there is no runtime and no garbage collector to clean up. This gives a
lot of power and performance options. But if you have a single array offset
wrong or calculate sizes wrong, then shit hits the fan.

At the other end of the spectrum, languages like PHP and Python provide a really
high level of abstraction for arrays. There is no way for you as a developer to
access the memory directly, because all interaction with it goes through the
runtime, and the runtime takes care of writing to and reading from the memory
blocks.

In C, C++, and unsafe Rust, accessing an element involves using pointer
arithmetic. An array in these languages is essentially a block of memory, with
the array itself acting as a pointer to the beginning of that block. To access a
specific element, you provide an index, which determines the offset from the
start of the array. For example, if our array has 10 elements and the pointer to
the array starts at address `0x1000` (hexadecimal), accessing the first element
is straightforward: the index (0) multiplied by the size of the element's type
(e.g., 4 bytes for integers) results in no offset, so the first element is at
`0x1000`. Similarly, to access the second element (index 1), we calculate the
address as `0x1000 + (1 * 4) = 0x1004`, since each integer occupies 4 bytes.
This is effectively what happens when you write `int_array[0]` for the first
element of our array with the name "int_array" or `int_array[1]` for the second
element in C.

TL;DR:
- int arr[10], `int_array`, address `0x1000`
  - int (`int_array[0]`), address `0x1000`, value `42`
  - int (`int_array[1]`), address `0x1004`, value `123`
  - int (`int_array[2]`), address `0x1008`, value `321`
  - etc...

Due to the high level of abstraction in PHP, arrays do not behave the way you
might think now. This is where things get dirty, so I hope you've got your
favourite rubber boots on.

Lets stick with our previous example. We have a PHP script with an array called
`$int_array`, and yes, we are in PHP now, so we have a $ prefix.

```php
$int_array[] = array(1, 2, ... 9, 10);

print_r($int_array);

// Prints:
// Array
// (
//     [0] => 1
//     [1] => 2
//     ...
//     [8] => 9
//     [9] => 10
// )
```

PHP in general
has a C-like syntax and its runtime is developed in C, so we'll see a
similarity. Accessing an element looks like in C => `$int_array[42]` which tries
to read the element at the index 42. But PHP fools you. You could think now,
that we are reading the element from a well sorted block of memory, with an
offset of `0x1000 + (42 * 4) = 0x10A8`. But wrong. Arrays in PHP are associative
arrays, or simplified hash maps - at least sometimes, sometimes not... It
depends.

And in case you haven't heard, PHP is basically a heap memory only language. All
data is stored in a heap allocated structure called zval (an abbreviation for
Zend Value), for which the PHP runtime allocates a block of 16 bytes on 64 bit
systems on the memory through memory alignment. The zval C struct looks
simplified like this:

| member                | type                         | size    |
| --------------------- | ---------------------------- | ------- |
| value                 | `zend_long`                  | 8 bytes |
| type                  | union[^union] of uint32 and a struct | 4 bytes |
| optimization/ padding | union[^union] of different uint32's  | 4 bytes |

This facts result in an interesting memory allocation. The array `$int_array` is
stored within the zval struct and looks like:

| member | value    |
| ------ | -------- |
| value  | pointer to a `_zend_array`[^zend_array] (inh. from `zend_refcounted_h`) struct |
| type   | IS_ARRAY |

Exactly. Our `$int_array` doesn't really contain the "array" but a pointer to
another heap allocated structure `zend_array`[^zend_array] that holds the
"array". Now it depends which content our array holds. I'll go into what I mean
by that later, otherwise I am already spoiling the fun. My fun, not yours.

Some time has passed since we defined our PHP array `$int_array` above and
filled it with 10 integer values. Let's remove the last element and append a new
integer 42, let's see how our array looks now.

```php
// remove the 10th element
unset($int_array[9]);

// append 42
$int_array[] = 42;

print_r($int_array);

// Prints:
// Array
// (
//     [0] => 1
//     [1] => 2
//     ...
//     [8] => 9
//     [10] => 42
// )
```

Oops, a jump from index 8 to 10? It might look like PHP has a counting weakness,
but no, on the contrary, it can count really well. PHP's internal array struct
`_zend_array`[^zend_array] has a `zend_long` member called `nNextFreeElement` that holds the
next free integer (`zend_long`) key that will be used, when no explicit key is
provided, e.g. `$int_array[] = 42;`.

```c
struct _zend_array {
	...
	zend_long         nNextFreeElement;
	...
};
```

This can be particularly inconvenient if you are working with a normal for loop.
The following example would lead to a PHP error and crash your script without a
try-catch block:

```php
$int_array = array(1, 2, 3, ... 9, 10);
unset($int_array[9]);
$int_array[] = 42;

for($i = 0; $i < count($int_array); $i++) {
    // PHP throws an E_WARNING when reaching $i = 9
    // Warning: Undefined array key 9 in ...
    echo $int_array[$i];
}
```

The only way to prevent this, is to reindex an auto indexed array after
unsetting & appending via `array_values`:

```php
$int_array = array(1, 2, 3, ... 9, 10);
unset($int_array[9]);
$int_array[] = 42;

// Array
// (
//     [0] => 1
//     [1] => 2
//     ...
//     [8] => 9
//     [10] => 42
// )

$int_array = array_values($int_array);

// Array
// (
//     [0] => 1
//     [1] => 2
//     ...
//     [8] => 9
//     [9] => 42
// )
```

**IMPORTANT: When you work with auto indexed arrays, use `array_values` when
iterating them within a for loop and every time you assume a correct auto
incremented index. This prevents you from producing big vulnerabilities like
drupal's [SA-CORE-2014-005 (SQL injection)](https://github.com/drupal/drupal/commit/19b32a3ab40e8c89495ee260e46a5e8375ad3756).**

Now back to the `zend_array` struct that holds our integer array. PHP
distinguishes two different kind of array values within its struct
implementation via a union[^union]. The first kind are hash tables via `arHash`
and `arData` as well as packed arrays within `arPacked`.

```c
typedef struct _Bucket {
	zval              val;
	zend_ulong        h;                /* hash value (or numeric index)   */
	zend_string      *key;              /* string key or NULL for numerics */
} Bucket;

struct _zend_array {
	...
	union {
		uint32_t     *arHash;   /* hash table (allocated above this pointer) */
		Bucket       *arData;   /* array of hash buckets */
		zval         *arPacked; /* packed array of zvals */
	};
	...
};
```

Auto indexed PHP array without string keys and without "gaps" in the keys, are
saved within a packed array. A packed array is a simple C array of zvals. Due to
the equal index, these arrays are way more performant and smaller then the
alternative, hash tables. Hash tables are an array of Buckets, holding the zval
and a hash value of the key.

A packed array with simple data types like
`$int_array = array(1, 2, ... 9, 10);` looks just like the following list in C:

- zval, address 0x7fffabc11b00 `{ value: 0x7fffabc11f10, type: IS_ARRAY }`
  - zend_array, address 0x7fffabc11f10, ***arPacked**:
    - zval, address 0x7fffabc11f20 `{ value: 1, type: IS_LONG }`
    - zval, address 0x7fffabc11f30 `{ value: 2, type: IS_LONG }`
    - ...
    - zval, address 0x7fffabc11fa0 `{ value: 9, type: IS_LONG }`
    - zval, address 0x7fffabc11fb0 `{ value: 10, type: IS_LONG }`

And with complex data types like objects:

- zval, address 0x7fffabc11b00 `{ value: 0x7fffabc11f10, type: IS_ARRAY }`
  - zend_array, address 0x7fffabc11f10, ***arPacked**:
    - zval, address 0x7fffabc11f20 `{ value: 0x7ffeab123780, type: IS_OBJECT }`
      - zend_object, address 0x7ffeab123780 ...
    - zval, address 0x7fffabc11f30 `{ value: 0x7ffee1ac9020, type: IS_OBJECT }`
      - zend_object, address 0x7ffee1ac9020 ...
    - ...
    - zval, address 0x7fffabc11fa0 `{ value: 0x7ffdf45ab660, type: IS_OBJECT }`
      - zend_object, address 0x7ffdf45ab660 ...
    - zval, address 0x7fffabc11fb0 `{ value: 0x7ffdca87f320, type: IS_OBJECT }`
      - zend_object, address 0x7ffdca87f320 ...

I found it particularly interesting how PHP adds values to the packed array. I
didn't quite understand how to properly concatenate the zval's of the existing
data in an `arPacked` memory area without changing their memory address.

Kudos to
[Derick Rethans, author of Xdebug and part of the PHP Foundation](https://derickrethans.nl/),
for pointing me to the right place in the code on Mastodon. Thanks to him, I
quickly understood that PHP creates new zvals for the array and then simply
takes the pointer to the other zval's value as the value of the
array-zval[^zvalcopy]. So both zvals point to the same object. Smart.

It is easy with simple values, these are not referenced, they are simply stored
directly in the zval and copied.

And a hash map of simple data types may look like this:

- zval, address 0x7fffabc11b00 `{ value: 0x7fffabc11f10, type: IS_ARRAY }`
  - zend_array, address 0x7fffabc11f10, ***arHash***:
    - Bucket, index 0, address 0x7fffabc11f20
      - key: "one"
      - zval `{ value: 1, type: IS_LONG }`
    - Bucket, index 1, address 0x7fffabc11f30
      - key: "two"
      - zval `{ value: 2, type: IS_LONG }`
    - ...
    - Bucket, index 8, address 0x7fffabc11fa0
      - key: "nine"
      - zval `{ value: 9, type: IS_LONG }`
    - Bucket, index 9, address 0x7fffabc11fb0
      - key: "ten"
      - zval `{ value: 10, type: IS_LONG }`

And again with complex data types like objects:

- zval, address 0x7fffabc11b00 `{ value: 0x7fffabc11f10, type: IS_ARRAY }`
  - zend_array, address 0x7fffabc11f10, ***arHash***:
    - Bucket, index 0, address 0x7fffabc11f20
      - key: "one"
      - zval `{ value: 0x7ffeab123780, type: IS_OBJECT }`
        - zend_object, address 0x7ffeab123780 ...
    - Bucket, index 1, address 0x7fffabc11f30
      - key: "two"
      - zval `{ value: 0x7ffee1ac9020, type: IS_OBJECT }`
        - zend_object, address 0x7ffee1ac9020 ...
    - ...
    - Bucket, index 8, address 0x7fffabc11fa0
      - key: "nine"
      - zval `{ value: 0x7ffdf45ab660, type: IS_OBJECT }`
        - zend_object, address 0x7ffdf45ab660 ...
    - Bucket, index 9, address 0x7fffabc11fb0
      - key: "ten"
      - zval `{ value: 0x7ffdca87f320, type: IS_OBJECT }`
        - zend_object, address 0x7ffdca87f320 ...

So the moment, we've unset the 10th element from our `$int_array` and appended a
new integer without re-indexing the array first, we've created a gap and
therefore transformed our packed array into a hash map.

## The lack of type safety in PHP arrays

As you must have noticed, PHP array lack type safety. Arrays in form of a hash
table, as well as packed arrays are just holding zvals in the end and a zval can
hold any value.

```php
$int_values = array(1, 2, 3, $tshirt, 5, 6, "Hello, world!");

print_r($int_array);

// Prints:
// Array
// (
//     [0] => 1
//     [1] => 2
//     [2] => 3
//     [3] => Tshirt Object
//         (
//             [color] => white
//         )
//     [4] => 5
//     [5] => 6
//     [6] => Hello, world!
// )
```

It is easy to forget that PHP is an object-oriented language and that we can
build our own structures based on internal array containers to make our everyday
life with PHP type-safe. This was also the subject of the second part of Larry's
talk.

And not only do we have the option to work type-safe here, we can also implement
things like the previously highlighted re-indexing centrally.

Here is a simple example of how to implement a strict integer array that also
ensures at runtime that only integer values can be stored in the array:

```php
class IntArray extends \ArrayObject {
    public function offsetSet($index, $new_value): void {
        if (is_int($new_value) === false) {
            throw new \TypeError('Given value is not an integer...');
        }

        parent::offsetSet($index, $new_value);
    }
}

$int_array = new IntArray();
$int_array[] = 1;
$int_array[] = 42;

print_r($int_array);

// Prints:
// IntArray Object
// (
//     [storage:ArrayObject:private] => Array
//         (
//             [0] => 1
//             [1] => 42
//         )
// 
// )
```

Appending a string would lead to `\TypeError` as defined in `offsetSet`:

```php
// Warning: Uncaught TypeError: Given value is not an integer...
$int_array[] = "Hello, world!";
```

The next step would be to ensure that the array only uses int keys and that our
packed array can never become a hash map.

The main way to add elements is with the `add` function, which basically just
appends values. There is also a `set`, but it uses `count` on the internal array
to ensure that values are only added in the allowed range, so there are no gaps
in the index order.

When removing values, we cannot simply use unset, otherwise we would create gaps
in the array. However, PHP provides a way to replace values in an array using
the `array_splice` function, and keep the index order correct.

Our new array object also implements the `\Iterable` interface, which allows us
to iterate over it in a foreach loop.

```php
class IntArray implements \Iterator {
    /** @var array<int, int> */
    private array $array = [];
    private int $position = 0;

    public function set(int $index, int $new_value): void {
        if ($index > count($this->array)) {
            throw new \OutOfRangeException(
                "The index must be the next sequential integer, or within the current range.",
            );
        }

        $this->array[$index] = $new_value;
    }

    public function add(int $new_value): void {
        $this->array[] = $new_value;
    }

    public function get(int $index): int {
        if (!array_key_exists($index, $this->array)) {
            throw new \OutOfBoundsException(
                "Index does not exist in the array.",
            );
        }

        return $this->array[$index];
    }

    /** @return array<int, int> */
    public function all(): array {
        return $this->array;
    }

    public function remove(int $index): void {
        if (!array_key_exists($index, $this->array)) {
            throw new \OutOfBoundsException(
                "Index does not exist in the array.",
            );
        }

        array_splice($this->array, $index, 1);
    }

    public function count(): int {
        return count($this->array);
    }

    // Iterator interface methods
    public function current(): int {
        return $this->array[$this->position];
    }

    public function key(): int {
        return $this->position;
    }

    public function next(): void {
        ++$this->position;
    }

    public function rewind(): void {
        $this->position = 0;
    }

    public function valid(): bool {
        return isset($this->array[$this->position]);
    }
}
```

Examples like the previous one can be applied to all possible constellations.
This allows you to build immutable arrays that can be safely passed to other
functions. Using static code analysis via PHPStan, generic type-safe arrays can
be built using `/** @template T */`, which also perform a type check at runtime.
All of this, except the packed array example, and much more, can be found in
Larry's presentation, so I don't need to repeat it here:

[PHPKonf 2021 - Larry Garfield: Never* use arrays \[YouTube\]](https://www.youtube.com/watch?v=nNtulOOZ0GY)

## TL;DR: The moment I went mad...

As mentioned at the beginning, towards the end of his talk Larry showed a
benchmark. In this benchmark, he showed that using PHP objects can save ~50% of
memory compared to native arrays. I have copied the benchmarking into the
following table:

| Technique            | Runtime (s)      | Memory (bytes)          |
|----------------------|------------------|-------------------------|
| Associative array    | 9.4311 (n/a)     | 541,450,384 (n/a)       |
| stdClass             | 11.2173 (+18.94%)| 589,831,120 (+8.94%)    |
| Public properties    | 8.2172 (-12.87%) | 253,831,584 (-53.12%)   |
| Private properties   | 11.0881 (+17.57%)| 253,833,000 (-53.12%)   |
| Anonymous class      | 8.1095 (-14.07%) | 253,832,368 (-53.12%)   |

Each test was performed with 1,000,000 objects or array entries.

In my amazement, and due to my mental absence during the housework I was doing
at the same time, I missed the fact that Larry was comparing the basic storage
of data in an object with that in an array, i.e:

```php
$placeholder_foobar = [
    "name"    => "foobar",
    "yob"     => 1960,
    "friends" => [
        "fizz bazz",
        "lorem ipsum",
        "john doe",
        "jane doe",
    ],
];

// VS

class Placeholder {
    /** @param array<int, Placeholder> $friends */
    public function __construct(
        public readonly string $name,
        public readonly int|null $yob = null,
        public readonly array|null $friends = null,
    ) {
    }
}

$placeholder_foobar = new Placeholder(
    name: "foobar",
    yob: 1960,
    friends: [
        new Placeholder("fizz bazz"),
        new Placeholder("lorem ipsum"),
        new Placeholder("john doe"),
        new Placeholder("jane doe"),
    ],
);
```

The reason for the ~50% memory saving is explained by Larry here with the fact
that the representation of our 'object' in the form of an array is stored in a
hash map. If, on the other hand, we have a class with fixed, statically typed
parameters, then no hash map is used and PHP can make further optimisations when
storing to memory, especially since PHP knows the maximum amount of data that
can come in. A large object can no longer suddenly be written as a small
integer, which would simply be possible in a native PHP array.

I assumed after the talk that Larry was saying that encapsulating a native array
in an array object like `IntArray` and statically ensuring the values of the
array would result in the encapsulated array occupying only ~50% of the memory
that a native PHP array without encapsulation would occupy.

Complete nonsense :D ...

## Benchmark the hell out of PHP arrays

Well, I thought to myself, how is it that we can save so much memory and it
hasn't been reported in the mainstream press yet... And more importantly, why
isn't it being talked about in the tech bubble?

I wondered how it is that in PHP I am now forced to put all arrays into array
objects, now that I know that this can save ~50% memory...

But what bothered me most was that I didn't understand how this black PHP magic
worked. How could there be such a huge saving in memory when it was the same
data?

So I went on the internet to look around. I posted on Mastodon and,
unfortunately for him, reached Larry, who, luckily for me, replied :D. At the
same time, I started creating a [PHP array and array object benchmarking
repository for 8.1, 8.2, 8.3 and 8.4 alpha](https://github.com/lrotermund/php-array-benchmarking),
in which I created and benchmarked a wide variety of array constellations.

Interestingly, when benchmarking, I found that arrays with (auto-indexed)
integer keys consume well over ~50% less memory than their counterpart with a
string key... I wonder why :D!

## A few final thoughts

In retrospect, it paid off for me to become PHP array obsessed. And it also paid
off that I didn't listen to Larry's talk very well, otherwise I would still be
writing PHP every day without knowing anything about packed arrays and hash
maps.

Over the last few years, I have become increasingly passionate about motivating
people around me to look behind the curtain. Every obstacle and hurdle in my
career has made me grow a little and become a little better at what I do and
appreciate all day long.

I would be a different developer today if I had simply turned around every time
I encountered a problem. If I hadn't taken different paths each time. And if I
hadn't always tried to get to the bottom of things with a healthy dose of
madness. So I would like to use this article as an opportunity to motivate you,
the reader, to continue to educate yourself, to face and overcome hurdles, and
to find a way out of dead ends. Sure, it's all a bit simplistic, but it works.

I firmly believe that our profession thrives on the fact that developers like
you and me have a spark burning inside of us. It is that spark that keeps us
going, that keeps us solving problems, that keeps us getting to the bottom of
things, that keeps us not just accepting what is written, spoken or heard, but
testing it, verifying it... benchmarking it.

Thank you for taking the time to read this article.

I hope I was able to tell you something exciting about PHP arrays that you
didn't already know. And please, take my findings and benchmark them for
yourself. Have a look at the
[PHP source code in heap space](https://heap.space/xref/) and challenge what I
am telling you here.

If you enjoyed this article, please share it with your friends and colleagues.
And let me know what you think. I am generally easy to reach on
[LinkedIn](https://www.linkedin.com/in/lukas-rotermund/) and
[Mastodon (social.tchncs.de)](https://social.tchncs.de/@lukasrotermund).

## General sources

- zval structure and internals: [php-src docs > zval](https://php.github.io/php-src/core/data-structures/zval.html)
- PHP array internals:
  - [php-src docs > Reference counting](https://php.github.io/php-src/core/data-structures/reference-counting.html)
  - [Zend PHP Extensions > 9. PHP Arrays](https://www.zend.com/resources/php-extensions/php-arrays)

[^modern]: modern: In the world of PHP... Languages like my beloved fried Go,
    Rust, or Zig doesn't come with crazy problems like that.
[^union]: union: A union in C is a data structure. It allows different data types to
    share the same memory location. When it comes to storing the data, only one
    value is stored at the memory location, using always the size of the largest
    type. When reading from a union, its possible to access all members of a
    union, the data stored at the memory location is then interpreded as the
    type of the member. E.g.  a union between an int, a float and a character:
    `union Data {int i; float f; char c; };`
[^zend_array]: zend_array: PHP internal array struct: [php src Github > _zend_array](https://github.com/php/php-src/blob/7771ec07e5cb00f2400055fa5d2d08af4bc92809/Zend/zend_types.h#L388)
[^zvalcopy]: Adding new values happens within `_zend_hash_index_add_or_update_i`, the
    [copying for packed arrays takes place in line 1130](https://heap.space/xref/PHP-8.3/Zend/zend_hash.c?r=b175ea42#1130).
    The macro `ZVAL_COPY_VALUE` then copies the zvals value, simple or pointer,
    without increasing the first zvals refcount:
    [php src heap.space > ZVAL_COPY_VALUE](https://heap.space/xref/PHP-8.3/Zend/zend_types.h?r=45c7e3b0#1399)
