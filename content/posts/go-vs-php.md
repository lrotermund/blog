---
type: post
title: "A Go vs PHP Showdown: Building and Benchmarking a space ship game"
tags: ["symfony", "php", "echo", "golang", "development"]
date: 2024-12-26T11:00:03+00:00
images: ["/assets/chatgpt-gopher-figthing-an-elephant.webp"]
image_alt: ""
description: |
    Discover the strengths and weaknesses of Go and PHP by developing a space
    ship game. This in-depth comparison covers everything from setup to
    performance benchmarks.
summary: |
    Discover the strengths and weaknesses of Go and PHP by developing a space
    ship game. This in-depth comparison covers everything from setup to
    performance benchmarks.
toc: false
draft: true
---

I've been developing PHP and Golang applications for a while now, usually driven
by language requirements from my employer or clients. In this in-depth article,
I want to directly compare the two languages by developing a space ship game in
Golang (echo) and PHP (symfony), using the same API in both projects.

I'm looking to understand the strengths and weaknesses of Golang and PHP,
particularly with regard to how each deals with dockerisation, in order to make
an informed decision for myself. I will also do some benchmarks with the
finished containers. This will give me some reliable data to base my opinion on.

All images and repositories are available for your own testing and benchmarking
at the following links:

- TODO dockerhub
- TODO github

{{< toc >}}

## The game requirements

The game should meet very comprehensive requirements for this comparison, as I
want to do a realistic project comparison. It should not feel like the
development of a demo project with only the facade at the end. Also, the
benchmarks should be more realistic than with an endpoint that returns "Hello"
per 200 OK.

I have the following requirements for the projects:

**Deployment**: The entire project can be deployed via a single Docker image.

**Database use**: The projects must use the document database SQLite.

**Command-Line interface (CLI)**: The projects must offer a CLI via which the
database can be prepared and filled with demo data.

**Space ship management**: There must be the ability to create and destroy the
space ships of the projects API.

**Prometheus support**: The projects must track created and destroyed
spaceships as Prometheus metrics and provide a matrix endpoint.

**Security**: The APIs a secured with a simple basic authentication.

In summary, there are some realistic requirements for a project, e.g. metrics,
entities, a database, an API and an API authentication.. A direct comparison
should give a good picture of the advantages and disadvantages of the two
environments.

## Set up both projects

## Performance and resource benchmarking
