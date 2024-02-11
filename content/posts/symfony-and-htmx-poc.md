---
type: post
title: "HTMX & Symfony: The pleasure of purified web development"
tags: ["symfony", "php", "htmx", "go", "development"]
date: 2024-02-10T13:10:03+00:00
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

HTMX, a simple and powerful library for AJAX, CSS transitions, WebSockets, and
server-sent events directly in HTML, via attributes. With this promise, HTMX,
which grew out of intercooler JS, is currently rising to fame. To test if it
delivers what it promises, I built a proof of concept implementation using HTMX
and Symfony. 

{{< toc >}}

## Challenges in today's web development ecosystem

Developers who have slowed down active frontend development around 2015 and want
to develop a feature or two again in today's professional frontend world may
feel uncomfortable with the overhead of frameworks, libraries, and JS build
pipelines that have emerged since jQuery.

Back then, the state of the current application was determined in the backend,
generated as HTML, and displayed. Today, there is usually a JSON API. Of course,
this still responds with a current state based on a JWT-based authorization, but
the result is processed much differently than with the old HTML controllers/
APIs.

JS frameworks, enabled by Node.js, Bun or Deno build processes, duplicate/mimic
this backend state processing. Modularized Vue, React, or Angular components,
triggered by various bindings, send their XHR requests via encapsulated API
services against the backend JSON APIs. Always in accordance with the roles and
permissions contained in the corresponding JWT issued by the OAuth server.

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
transformations, and the still unaddressed problem that dozens of JS libraries
that my UI uses get declared vulnerable every night, often actively enabling
security vulnerabilities in your own application, is what makes front-end
development so unattractive to me right now.

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
way to do something in Go, from loops, an API, and coroutines to formatting the
code.

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
to just ~14k, quickly delivered via a CDN:

```html
<script src="https://unpkg.com/htmx.org@1.9.10"></script>
```

That's it, now you're ready to go productive and develop your first components
that work with the features of HTMX. But what are these features? What are the
benefits for me?

HTMX gives you the ability to send XML HTTP requests, or short XHR, which are
asynchronous, non-blocking GET, POST, PUT & DELETE requests from any HTML
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
previous example, the `li` element executes a GET XHR when the element is
displayed in the browsers viewport.

So far, so good, but what I haven't mentioned is what happens to the result of
the XHR. The default behavior of HTMX requests is that the content of the
response replaces the **innerHTML** of the triggering element. However, this
behavior can be overridden using the `hx-swap` attribute. Possible targets here
include **outerHTML** or, as in the example, **afterend**, which places the
result after the triggering element, as well as a few others.

Okay, that's it. **Now you are officially an HTMX expert** and know everything
relevant about HTMX that you need to effectively build simple frontends - no
joke.

## Back to the standard: The incredible closeness to HTML

What I really like is how close HTMX is to HTML. HTMX is HTML-compliant by
definition if only the custom `data-hx` attributes are used. Otherwise, HTMX
does not deviate much from HTML with the `hx` attributes. All modern browsers
can handle non-conforming HTML5 attributes without any problems, but of course
no browser can guarantee this.

The large German Internet portal spiegel.de also frequently uses
non-HTML5-compliant HTML attributes such as `x-data` or `:class`, and here in
particular there seem to be no conflicts with SEO and browser compatibility.

If you want to be absolutely sure & HTML5 compliant, you must use the `data-hx`
attributes. This can be done using an HTML5 validator/linter in the merge
request or deployment pipeline of your choice.

With or without the data prefix, HTMX allows us to build frontends close to the
standard, efficiently, and without adding a significant new tech stack to the
application.

## Get your hands dirty to learn: HTMX & Symfony in practice 

To try out HTMX myself in a three to four hour PoC, I decided to build a
minimalist, fantasy online store for handbags and suitcases for the Swiss
market - **AlpenGepaeck.ch**.

You can have a look at the PoC and play around with HTMX by cloning the
repository on Github and running it with Docker Compose in less than a minute.

- [tasko-products/poc-symfony-htmx](https://github.com/tasko-products/poc-symfony-htmx)

The choice of Symfony as PHP framework for the backend is simply based on the
fact that we at [tasko Products GmbH](https://www.tasko.de/) primarily use PHP
and Symfony for backend development and the PoC was created as a training
experiment for tasko.

Of course, you can implement HTMX with any backend language. In particular,
based on my personal preference, I would recommend taking a look at Golang. The
two are a good match based on their claim to simplicity and efficiency alone.
In addition, Go's templates provide you with a wonderful tool for preparing and
rendering customizable HTMX components on the backend side.

If you want to learn more about HTMX and Golang, I can highly recommend the
tutorial by ThePrimagen and Frontend Masters:

{{< _figureCupper
img="https://static.frontendmasters.com/assets/courses/2024-01-21-htmx/posterframe.jpg"
imgLink="https://frontendmasters.com/courses/htmx/"
alt="An image of ThePrimagen, trainer of the Frontend Masters course \"HTMX & Go\""
caption="ThePrimagens and Frontend Masters course [HTMX & Go](https://frontendmasters.com/courses/htmx/)." >}}

### Setting up a docker based symfony project

### Include HTMX in your base template

### Lazy loading rows of products

### Creating a dynamic product search

### Add products to your shopping basket

## There it is again: The joy of developing frontends

## An invitation to you...
