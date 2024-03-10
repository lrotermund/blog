---
type: post
title: "HTMX & Symfony: The pleasure of purified web development"
tags: ["symfony", "php", "htmx", "golang", "development"]
date: 2024-02-17T21:00:03+00:00
images: ["/assets/pexels-andreea-airinei-13442515.webp"]
description: |
    JS frameworks have professionalized UI web development, but they have also
    made it clumsy. HTMX, on the other hand, with its back-to-the-roots
    character, puts the focus back on simplicity and efficiency.
summary: |
    HTMX revives simplicity in UI web development, contrasting the complexity of
    JS frameworks with a back-to-the-roots approach for efficient design!
toc: false
draft: false
---

HTMX, a simple and powerful library for
{{< abbr "AJAX" "Asynchronous JavaScript And XML" >}},
{{< abbr "CSS" "Cascading Style Sheets" >}} transitions, WebSockets, and
server-sent events directly in {{< abbr "HTML" "Hypertext Markup Language" >}},
via attributes. With this promise, HTMX, which grew out of intercooler
{{< abbr "JS" "JavaScript" >}}, is currently rising to fame. To test if it
delivers what it promises, I built a proof of concept implementation using HTMX
and Symfony. 

{{< toc >}}

## Challenges in today's web development ecosystem

Developers who have slowed down active frontend development around 2015 and want
to develop a feature or two again in today's professional frontend world may
feel uncomfortable with the overhead of frameworks, libraries, and
{{< abbr "JS" "JavaScript" >}} build pipelines that have emerged since jQuery.

Back then, the state of the current application was determined in the backend,
generated as {{< abbr "HTML" "Hypertext Markup Language" >}}, and displayed.
Today, there is usually a {{< abbr "JSON" "JavaScript Object Notation" >}}
{{< abbr "API" "Application Programming Interface" >}}. Of course, this still
responds with a current state based on a
{{< abbr "JWT" "JSON Web Token" >}}-based authorization, but the result is
processed much differently than with the old
{{< abbr "HTML" "Hypertext Markup Language" >}} controllers/
{{< abbr "APIs" "Application Programming Interfaces" >}}.

{{< abbr "JS" "JavaScript" >}} frameworks, enabled by Node.js, Bun or Deno build
processes, duplicate/mimic this backend state processing. Modularized Vue,
React, or Angular components, triggered by various bindings, send their
{{< abbr "XHR" "XMLHttpRequest" >}} requests via encapsulated
{{< abbr "API" "Application Programming Interface" >}} services against the
backend {{< abbr "JSON" "JavaScript Object Notation" >}}
{{< abbr "APIs" "Application Programming Interfaces" >}}. Always in accordance
with the roles and permissions contained in the corresponding
{{< abbr "JWT" "JSON Web Token" >}} issued by the OAuth server.

The question quickly arises, why all the extra effort? Why all these additional
transformation layers that states, users and data have to go through? At what
point did we decide that it would be a good idea to scatter these frameworks
across all front-end applications and thus build an additional tech stack that
should not be underestimated?

I have tried once or twice to catch up with frontend development and develop
applications with Angular or Vue. Unfortunately, I failed each time due to a
lack of knowledge about the correct usage and common patterns of these
frameworks. 

Fair enough, this is clearly a skill issue for me. But isn't this also true for
other developers? Frameworks often involve a completely different software
architecture and syntax. Knowledge that has been painstakingly acquired in one
framework, often with a very flat learning curve, is generally difficult to
apply to other frameworks.

This skill issue, coupled with the overhead of state, user, and data
transformations, and the still unaddressed problem that dozens of
{{< abbr "JS" "JavaScript" >}} libraries that my
{{< abbr "UI" "User Interface" >}} uses get declared vulnerable every night,
often actively enabling security vulnerabilities in your own application, is
what makes front-end development so unattractive to me right now.

## We need simple & boring again, we need the Golang way

When developing applications, every developer and every team has their own
focus, which is often on complexity. After all, anyone who builds complex
applications and uses as many patterns as possible must be a really good,
superior developer. But is this really the case?

As developers, our goal cannot be to glorify complexity. Complexity leads to a
flat learning curve for new colleagues, a false sense of superiority over other
developers, and ultimately more complex legacy software. Nobody wants that.

But it is understandable. Over the last decade, a mostly unspoken desire for
complexity has developed, precisely out of the desire to be perceived as a good,
senior developer who can bend complexity. After all, we all depend on a good
salary, and that is often enhanced by a good developer image.

When I stumbled across Golang during a job application process, I was amazed. It
was exactly what I had been missing for years. Golang is meant to be a simple
language. When I wrote my first lines of Go, I was shocked at how easy it was to
write simple, secure, and highly scalable code compared to C# and PHP - all
without a framework & without a single external library.

After a short time in Go, you realize one thing: Go is boring - but it is
effective. Go, with its greatly reduced set of about 25 keywords and its huge
standard library, makes development highly efficient. There is usually only one
way to do something in Go, from loops, an
{{< abbr "API" "Application Programming Interface" >}}, and coroutines to
formatting the code.

In Go, it's not about arguing endlessly about the use of sophisticated patterns,
libraries and frameworks, or about perfect code formatting, or about tabs vs.
spaces, it's about getting your shit done - Go takes care of the rest.

In my opinion, this is what front-end development needs right now. We need
simplicity to increase the learning curve and make front-end development more
attractive again. And we need efficiency to finally get projects back on track
smoothly and quickly, without framework discussions, without expensive, superior
& rare vue/ react/ angular developers, and without mapping all states and data
back and forth between backend and frontend.

## HTMX: From first impression to expert

HTMX is quickly integrated into the project with a simple script tag. No build
pipeline, no Node.js & no npm, no bun, no deno - just a script. HTMX is minified
to just ~14k, quickly delivered via a
{{< abbr "CDN" "Content Delivery Network" >}}:

```html
<script src="https://unpkg.com/htmx.org@1.9.10"></script>
```

That's it, now you're ready to go productive and develop your first components
that work with the features of HTMX. But what are these features? What are the
benefits for me?

HTMX gives you the ability to send
{{< abbr "XML" "Extensible Markup Language" >}}
{{< abbr "HTTP" "Hypertext Transfer Protocol" >}} requests, or short
{{< abbr "XHR" "XMLHttpRequest" >}}, which are
asynchronous, non-blocking GET, POST, PUT & DELETE requests from any
{{< abbr "HTML" "Hypertext Markup Language" >}}
element - why should this only be allowed for `<a>` and `<form>`?

```html
<ul>
    <li class="post" hx-get="/post/2"
                     hx-trigger="revealed"
                     hx-swap="afterend">
        <a href="/posts/htmx-symfony">
            HTMX & Symfony: The pleasure of purified web development
        </a>
    </li>
</ul>
```

This, and of course the HTMX script tag at the beginning, is all that is needed
on the frontend side for a lazy loading list of blog posts. HTMX provides
several functions via attributes prefixed with `hx` or long `data-hx`. In the
previous example, the `li` element executes a GET
{{< abbr "XHR" "XMLHttpRequest" >}} when the element is displayed in the
browsers viewport.

So far, so good, but what I haven't mentioned is what happens to the result of
the {{< abbr "XHR" "XMLHttpRequest" >}}. The default behavior of HTMX requests
is that the content of the response replaces the **innerHTML** of the triggering
element. However, this behavior can be overridden using the `hx-swap` attribute.
Possible targets here include **outerHTML** or, as in the example, **afterend**,
which places the result after the triggering element, as well as a few others.

Okay, that's it. **Now you are officially an HTMX expert** and know everything
relevant about HTMX that you need to effectively build simple frontends - no
joke.

## Back to the standard: The incredible closeness to HTML

What I really like is how close HTMX is to
{{< abbr "HTML" "Hypertext Markup Language" >}}. HTMX is
{{< abbr "HTML" "Hypertext Markup Language" >}}-compliant by definition if only
the custom `data-hx` attributes are used. Otherwise, HTMX does not deviate much
from {{< abbr "HTML" "Hypertext Markup Language" >}} with the `hx` attributes.
All modern browsers can handle non-conforming
{{< abbr "HTML5" "Hypertext Markup Language 5" >}} attributes without any
problems, but of course no browser can guarantee this.

The large German Internet portal spiegel.de also frequently uses
non-{{< abbr "HTML5" "Hypertext Markup Language 5" >}}-compliant
{{< abbr "HTML" "Hypertext Markup Language" >}} attributes such as `x-data` or
`:class`, and here in particular there seem to be no conflicts with
{{< abbr "SEO" "search engine optimization" >}} and browser compatibility.

If you want to be absolutely sure &
{{< abbr "HTML5" "Hypertext Markup Language 5" >}} compliant, you must use the
`data-hx` attributes. This can be done using an
{{< abbr "HTML5" "Hypertext Markup Language 5" >}} validator/linter in the merge
request or deployment pipeline of your choice.

With or without the data prefix, HTMX allows us to build frontends close to the
standard, efficiently, and without adding a significant new tech stack to the
application.

## Get your hands dirty to learn: HTMX & Symfony in practice 

To try out HTMX myself in a three to four hour
{{< abbr "PoC" "Proof of concept" >}}, I decided to build a minimalist, fantasy
online store for handbags and suitcases for the Swiss
market - **AlpenGepaeck.ch**.

You can have a look at the {{< abbr "PoC" "Proof of concept" >}} and play around
with HTMX by forking the repository on Github and running it with Docker Compose
in less than a minute.

- [tasko-products/poc-symfony-htmx](https://github.com/tasko-products/poc-symfony-htmx)

The choice of Symfony as PHP framework for the backend is simply based on the
fact that we at [tasko Products GmbH](https://www.tasko.de/) primarily use PHP
and Symfony for backend development and the
{{< abbr "PoC" "Proof of concept" >}} was created as an experiment for tasko.

Of course, you can implement HTMX with any backend language. In particular,
based on my personal preference, I would recommend taking a look at Golang. The
two are a good match based on their claim to simplicity and efficiency alone.
In addition, Go's templates provide you with a wonderful tool for preparing and
rendering customizable HTMX components on the backend side.

### Setting up a docker based symfony project

Setting up Symfony with Docker is very simple. In this short _Getting Started_,
we will use the Docker-based installer recommended by Symfony. This was
developed by Kévin Dunglas, the founder of
[Les-Tilleuls.coop](https://les-tilleuls.coop/en), the company behind
[Api Platform](https://api-platform.com/), and the maintainer of
[FrankenPHP](https://frankenphp.dev/), a modern Go-based application server.

Clone the repository or just download it as a zip from Github:
- [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker)

The installer runs automatically when you start the Docker Compose environment,
and the entrypoint placed in `frankenphp>docker-entrypoint.sh` also
automatically starts the installation of the composer Symfony skeleton. But
first you need to build the frankenphp images for the project, just run the
following command:

```sh
docker compose build --no-cache
```

Ok, this may take a while. Once the build is complete, you can simply launch the
Docker Compose environment. The build step of `symfony-docker-php-1` will take a
while, this is where the composer project is created. If you have previously
configured a database in `compose.yaml`, the system will also wait for it to
start.

To start the Docker Compose environment, just run:

```sh
docker compose up --pull always -d --wait
```

Now we have a running Symfony project without even having PHP, nginx, apache,
MySQL... you name it, installed on the development environment.

### Include HTMX in your base template

Adding HTMX to your project is a matter of seconds. Simply create a `templates`
folder in your project root and create a `base.html.twig` file there. Now add
the script tag to the header of this file to load HTMX from the unpkg
{{< abbr "CDN" "Content Delivery Network" >}}:

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://unpkg.com/htmx.org@1.9.10"></script>
    </head>
    <body>
        {% block body %}{% endblock %}
    </body>
</html>
```

### Lazy loading rows of products

Now for the fun part. Staying with the {{< abbr "PoC" "Proof of concept" >}}
example, we will now implement a home page with a lazy loading product section.
The product section iterates over a number of products provided by the
controller using Symfony's Twig template engine. The last product receives the
`hx` attributes for reloading when it is revealed to the user in the viewport.

It is always lazy loaded page by page, as with classic pagination. The last lazy
loaded product  always knows the next page; this information is always rendered
based on the current page.

Now create a `home.html.twig`:

```html
{% extends 'base.html.twig' %}

{% block body %}
<section class="products" id="products">
    {{ include('products/products.html.twig', {products, page}) }}
<section>
{% endblock %}
```

The next step is to integrate the `products/products.html.twig` template, which
we have here as a separate component, so that we can reuse it later for our lazy
loading.

```html
{% for product in products %}
{{ include('products/product.html.twig', {product, page}) }}
{% endfor %}
```

and finally the included `products/product.html.twig`:

```html
{% if loop.last %}
<section itemscope
         itemtype="https://schema.org/Product"
         class="product" 
         hx-get="{{ path('products', {'page': page + 1}) }}"
         hx-trigger="revealed"
         hx-swap="afterend">
{% else %}
<section itemscope itemtype="https://schema.org/Product" class="product">
{% endif%}
    <a href="{{ path('product', {'number': product.number}) }}">
        <img itemprop="image"
             src="{{ product.listingImage.url }}"
             alt="{{ product.listingImage.alt }}">
        <div class="label">{{ product.label }}</div>
        <div itemprop="brand" class="brand">{{ product.brand }}</div>
        <h1 itemprop="name" class="name">{{ product.name }}</h1>
        <div itemscope
             itemprop="offers"
             itemtype="https://schema.org/Offer"
             class="price">
            {% if product.price.isReduced == false %}
            <meta itemprop="price" content="{{ product.price }}">
            <meta itemprop="priceCurrency" content="EUR">
            {{ product.price }} Euro
            {% else %}
            <meta itemprop="price" content="{{ product.price.reduced }}">
            <meta itemprop="priceCurrency" content="EUR">
            <div itemscope
                 itemprop="priceSpecification"
                 itemtype="https://schema.org/PriceSpecification">
                <meta itemprop="price" content="{{ product.price.reduced }}">
                <meta itemprop="priceCurrency" content="EUR">
                <link itemprop="valueAddedTaxIncluded" href="true" />
            </div>
            <span class="original-price">
                <meta itemscope
                      itemprop="referencePrice"
                      itemtype="https://schema.org/PriceSpecification">
                <meta itemprop="price" content="{{ product.price }}">
                <meta itemprop="priceCurrency" content="EUR">
                {{ product.price }} Euro
            </span>
            <span class="reduced">{{ product.price.reduced }} Euro</span>
            {% endif %}
        </div>
    </a>
</section>
```

The hx block is particularly exciting, and this is where HTMX comes into play.
`hx-get` is used to define that a GET request is sent to the generated route
`path("products", {"page": page + 1})`.

The GET request is triggered when the last product becomes visible. This
behavior can be controlled with the `hx-trigger` attribute.

```html
<section itemscope
         itemtype="https://schema.org/Product"
         class="product" 
         hx-get="{{ path('products', {'page': page + 1}) }}"
         hx-trigger="revealed"
         hx-swap="afterend">
```

All we need for lazy loading of products in the backend is a well-defined
repository and two controllers to connect the template with the data from the
repositories.

The corresponding `HomeController` for the home page initially delivers six
products, so that the next products do not have to be loaded directly via lazy
loading. It also initially sets the corresponding page to 1, so that the correct
subsequent products can be loaded during further lazy loading.

```php
<?php

declare(strict_types=1);

namespace App\Controller\Htmx;

use App\Repository\ProductRepositoryInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class HomeController extends AbstractController
{
    public function __construct(
        private readonly ProductRepositoryInterface $productRepository,
    ) {
    }

    #[Route("/", name: "home")]
    public function home(Request $request): Response
    {
        return $this->render(
            "home/index.html.twig",
            [
                "products" => $this->productRepository->findAll(
                    offset: 0,
                    limit: 6,
                ),
                "page" => 1,
            ],
        );
    }
}
```

To enable lazy loading, we now need the corresponding `ProductController`. This
one renders three products by default, i.e. one row in the frontend.

```php
<?php

declare(strict_types=1);

namespace App\Controller\Htmx;

use App\Repository\ProductRepositoryInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Uid\Uuid;

class ProductController extends AbstractController
{
    private const PRODUCTS_PER_PAGE = 3;

    public function __construct(
        private readonly ProductRepositoryInterface $productRepository,
    ) {
    }

    #[Route("/products", name: 'products',  methods: Request::METHOD_GET)]
    public function products(Request $request): Response
    {
        $page = $request->query->get('page', 1);

        return $this->render(
            "products/products.html.twig",
            [
                "products" => $this->productRepository->findAll(
                    offset: $page * self::PRODUCTS_PER_PAGE,
                    limit: self::PRODUCTS_PER_PAGE,
                ),
                "page" => $page,
            ],
        );
    }
}
```

### Creating a dynamic product search

Creating a dynamically reloading search was one of the most "difficult" tasks -
although my problem here was more with the
{{< abbr "CSS" "Cascading Style Sheets" >}} for positioning the search results
box instead of the HTMX.

In the following example, you can see the component from the header. The
component contains an input field for the query, a div for the search results
and a load indicator in case the response takes a long time, which should not
happen.

What you also see is the simple implementation of the `onfocusout` event in the
input field. Just because we're using HTMX here doesn't mean we can't still
write {{< abbr "JS" "JavaScript" >}} code to reset the search results, as in
this case.

```html
<div class="search-container">
    <input type="text"
           name="query"
           placeholder="Search..."
           hx-get="/search"
           hx-trigger="input changed delay:500ms"
           hx-target="#search-results"
           hx-indicator="#loading-indicator"
           onfocusout="clearResults()">
    <div id="search-results"></div>
    <div id="loading-indicator" style="display: none;">
        Loading...
    </div>
</div>
```

You already know most of the HTMX attributes from the previous examples. New in
this example are the `hx-target` and the `hx-indicator`. The `hx-trigger` is a
bit more complex than in the previous examples.

The trigger here combines simple {{< abbr "JS" "JavaScript" >}} events with
various modifiers to react to a specific event. In the example, we are
interested in the input changed event and then add a delay of 500 ms before
sending the GET request. If the event occurs again within the 500ms, the delay
will be reset.

The `hx-target` changes only the target element, whose innerHTML is replaced by
the response content. hx-indicator defines the element that receives the
`htmx-request` class for the duration of the request. This is a very simple way
to indicate via {{< abbr "CSS" "Cascading Style Sheets" >}} that the search is
not yet complete.

A simple `SearchController` is now provided in the backend, which searches the
repository for results using the simplest means and renders them via a Twig
template.

```php
<?php

declare(strict_types=1);

namespace App\Controller\Htmx;

use App\Repository\ProductRepositoryInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class SearchController extends AbstractController
{
    public function __construct(
        private readonly ProductRepositoryInterface $productRepository,
    ) {
    }

    #[Route("/search", name: "search",  methods: Request::METHOD_GET)]
    public function search(Request $request): Response
    {
        $query = $request->query->get('query');
        if ($query === null) {
            return $this->render("search/404.html.twig");
        }

        return $this->render(
            "search/products.html.twig",
            [
                "products" => $this->productRepository->findByName($query),
            ],
        );
    }
}
```

For the search results, we simply use an unsorted list of classic links. After
all, HTMX is not about turning all elements into links, but about giving every
element the ability to send requests. **Anything else would not be accessible**,
for links you should still use the classic a-tag.

```html
<ul>
{% for product in products %}
    <li>
        <a href="{{ path("product", {"number": product.number}) }}">
            {{ product.name }}
        </a>
    </li>
{% endfor %}
</ul>
```

### Add products to your shopping basket

Finally, a lighter example. We are still using the session for our demo store
to save a basket. For this, we still need a product detail page that has a
button that sends a POST request to our backend, which in turn sends back the
number of products in the basket as a response.

Let's take a look at the product detail page and the HTMX button first.

```html
<section class="product__detail"
         itemscope
         itemtype="https://schema.org/Product">
    <img itemprop="image"
         src="{{ product.listingImage.url }}"
         alt="{{ product.listingImage.alt }}">
    <div class="label">{{ product.label }}</div>
    <section class="content">
        <p itemprop="brand" class="brand">{{ product.brand }}</p>
        <h1 itemprop="name">{{ product.name }}</h1>
        <div itemscope
             itemprop="offers"
             itemtype="https://schema.org/Offer"
             class="price">
            {% if product.price.isReduced == false %}
            <meta itemprop="price" content="{{ product.price }}">
            <meta itemprop="priceCurrency" content="EUR">
            {{ product.price }} Euro
            {% else %}
            <meta itemprop="price" content="{{ product.price.reduced }}">
            <meta itemprop="priceCurrency" content="EUR">
            <div itemscope
                 itemprop="priceSpecification"
                 itemtype="https://schema.org/PriceSpecification">
                <meta itemprop="price" content="{{ product.price.reduced }}">
                <meta itemprop="priceCurrency" content="EUR">
                <link itemprop="valueAddedTaxIncluded" href="true" />
            </div>
            <span class="original-price">
                <meta itemscope
                      itemprop="referencePrice"
                      itemtype="https://schema.org/PriceSpecification">
                <meta itemprop="price" content="{{ product.price }}">
                <meta itemprop="priceCurrency" content="EUR">
                {{ product.price }} Euro
            </span>
            <span class="reduced">{{ product.price.reduced }} Euro</span>
            {% endif %}
        </div>

        <button hx-post="{{ path("add-to-basket") }}"
                hx-vals='{"number": "{{ product.number }}"}'
                hx-target=".cart .count">
            Add to basket
        </button>

        <p itemprop="description">{{ product.listingImage.alt }}</p>
    </section>
</section>
```

Again, we already know `hx-post` and `hx-target`, only `hx-vals` is new. The
exciting thing here is that our button can simply send a POST request and the
values come from the `hx-vals` attribute, which contains a
{{< abbr "JSON" "JavaScript Object Notation" >}} with the data we want to
submit. The target is defined as a {{< abbr "CSS" "Cascading Style Sheets" >}}
selector for the basketcount component in the header, which is a little round
label above the basket icon that shows the number of items in the basket. This
also replaces the innerHTML in a response.

This is the basket header item:

```html
<div class="cart">
    <span class="count">{{ itemCount }}</span>
    <svg...>
</div>
```

Now we need the `BasketController` to populate the basket for incoming requests
and store it in the session. The following `BasketController` uses a
`BasketService` that encapsulates the basket handling.

```php
<?php

declare(strict_types=1);

namespace App\Controller\Htmx;

use App\Repository\ProductRepositoryInterface;
use App\Service\BasketServiceInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Uid\Uuid;

class BasketController extends AbstractController
{
    public function __construct(
        private readonly ProductRepositoryInterface $productRepository,
        private readonly BasketServiceInterface $basketService,
    ) {
    }

    #[Route(
        "/add-to-basket",
        name: 'add-to-basket',
        methods: Request::METHOD_POST,
    )]
    public function products(Request $request): Response
    {
        $number = $request->get('number');
        if ($number === null) {
            return new Response(
                'missing required number parameter',
                status: Response::HTTP_BAD_REQUEST,
            );  
        }

        if (!is_string($number) || !Uuid::isValid($number)) {
            return new Response(
                'invalid required number parameter',
                status: Response::HTTP_BAD_REQUEST,
            );  
        }

        $product = $this->productRepository->findByNumber(
            Uuid::fromRfc4122($number),
        );

        if ($product === null) {
            return new Response(
                'not found',
                status: Response::HTTP_NOT_FOUND,
            );  
        }

        $itemCount = $this->basketService->addProductToBasket(
            $product,
            $request->getSession(),
        );

        return new Response((string)$itemCount, status: Response::HTTP_OK);
    }
}
```

## There it is again: The joy of developing frontends

I was already biased before the experiment because I had already read about the
strengths and weaknesses of HTMX. However, I had not yet developed with it.

When I started to build the lazy loading and search, I really enjoyed frontend
development for the first time in years, and my project, including the lazy
loading, was up and running within minutes, without any prior knowledge of HTMX
attributes.

For me, my goal was accomplished. I have found a {{< abbr "JS" "JavaScript" >}}
library that makes frontend development modern, fast, and boring while keeping
the learning curve steep. I could well imagine to implement one or two more
frontends with HTMX in the future.

## An invitation to you...

If you've read this far, I hope you like HTMX. Why don't you grab a small
project and try to realize something realistic in a reduced context, like I did
with my fantasy shop. I am convinced that everyone will see at least some
benefit in HTMX.

If you don't feel like building something yourself, feel free to fork the
{{< abbr "PoC" "Proof of concept" >}} and play around with the endpoints and
functions, maybe you could build a checkout or a dynamic slider on the homepage?
In any case, there are a lot of possibilities.

## Of course, we still need Vue, React, and the like

If you're a frontend developer specializing in Vue, React, or Angular, I hope I
didn't hurt your feelings - that would never be my goal.

There will still be frontends in the future that need to be built in Vue, React
or Angular, because HTMX as a library doesn't fit at all. The mobile care
services in Germany come to mind, as we still have a lot of dead spots where
there is no mobile internet. The data about the route and the people being
cared for does not necessarily have to be synchronized with a server in real
time; a synchronization as soon as the Internet is available again is
sufficient.

Similarly, not every backend developer in every company can start building
frontends again. Rightly so, companies of a certain size often have their own
specialized teams with defined tech stacks.

All I wanted to do in this article was to fill your developer toolbox with
information about one more tool. Different projects have always required
different tools, so maybe you can use HTMX at some point if it turns out to be
the best tool for the job.
