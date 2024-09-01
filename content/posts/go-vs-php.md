---
type: post
title: "A Go vs PHP Showdown: Building and Benchmarking a CMS"
tags: ["symfony", "php", "htmx", "golang", "development"]
date: 2024-03-14T20:00:03+00:00
images: ["/assets/chatgpt-gopher-figthing-an-elephant.webp"]
description: |
    Discover the strengths and weaknesses of Go and PHP by developing a CMS.
    This in-depth comparison covers everything from setup to performance
    benchmarks.
summary: |
    Discover the strengths and weaknesses of Go and PHP by developing a CMS.
    This in-depth comparison covers everything from setup to performance
    benchmarks.
toc: false
draft: true
---

I've been developing PHP and Golang applications for a while now, usually driven
by language requirements from my employer or clients. In this in-depth article,
I want to directly compare the two languages by developing a CMS system in
Golang and PHP, using the same frontend in both projects and offering the same
APIs.

I'm looking to understand the strengths and weaknesses of Golang and PHP,
particularly with regard to how each deals with dockerisation, in order to make
an informed decision for myself. I will also do some benchmarks with the
finished containers. This will give me some reliable data to base my opinion on.

All images and repositories are available for your own testing and benchmarking
at the following links:

- TODO dockerhub
- TODO github

{{< toc >}}

## The CMS requirements

The CMS should meet very comprehensive requirements for this comparison, as I
want to do a realistic project comparison. It should not feel like the
development of a demo project with only the facade at the end. Also, the
benchmarks should be more realistic than with an endpoint that returns "Hello"
per 200 OK to our API.

I have the following requirements for the projects:

**Frontend Generation**: The frontend must be generated via a templating engine
and have HTMX as output.

**Deployment**: The entire project can be deployed via a single Docker image.

**Database Use**: The projects must use the document database MongoDB.

**Command-Line Interface (CLI)**: The projects must offer a CLI via which the
database can be prepared and filled with demo data.

**User Authentication**: The projects must provide a login for users. Login to
the UI is session based. Both projects should use http-only cookies. 

**User Management**: There must be the ability to create, edit and delete users
in the CMS UI.

**API Token Management**: There must be the ability to create and delete API
tokens in the CMS UI.

**Project Management**: It must be possible to create, edit, and delete projects
in the CMS UI.

**Content Management**: It must be possible to create, edit, and delete
content for a project in the CMS UI.

**Webhook Maintenance**: It must be possible to maintain webhooks for projects
in the CMS UI that are called when content is changed.

**REST API Implementation**: A REST API needs to be implemented for projects and
their content, which can be used to retrieve the entire content of a project, as
well as individual pieces of content. Authorisation against the API takes place
via an API token, which also restricts which projects the client can access. The
token must be passed by the client as a bearer in the Authorisation Header.

**Security**: JWT tokens are valid for half an hour. After this time, the token
must be renewed using the enclosed refresh token. All forms in the UI should
have CSRF protection.

In summary, there are some realistic requirements for a CMS for the projects. A
direct comparison should give a good picture of the advantages and disadvantages
of the two environments.

## Set up both projects

## Performance and resource benchmarking
