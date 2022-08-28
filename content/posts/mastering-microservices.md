---
title: "Mastering microservices"
tags: []
date: 2022-08-28T13:42:15+02:00
images: ["/assets/heaven-gd38ed956a_1280.webp"]
description: "Many developers today have a rough definition of microservices in their head. Let's take a look at all the essential elements that make up microservices."
summary: "Many developers today have a rough definition of microservices in their head. Let's take a look at all the essential elements that make up microservices."
toc: false
draft: false
---

Most developers today have a more or less good definition of microservices in their head. Some are
developing within a microservice architectural environment and some are not. Long time I've
developed monolithic web applications and internal services/ APIs without knowing of further
software architectures.

Meanwhile, I've been working with microservices for some years. This year
[Tasko](https://www.tasko.de/) offered me to visit Heise's
[Mastering Microservices](https://konferenzen.heise.de/mastering-microservices/) to deepen my
knowledge. I'm really thankful for this opportunity. 

This article is a summary of what I learned during the conference and from all these skilled
and talented software architects and speakers.

{{< toc >}}

## Monoliths, microservices – It's all about modules

Are you involved in every aspect, every domain-related edge case of all your organization's software 
projects? Congratulation! It looks like you are an important and revised employee. This is often the
exception rather than the rule.

### Today, teams are the biggest challenge for software engineering

Not every team member is able to understand all projects down to the smallest detail. It's the same
with software architecture. Depending on the size of a project it's nearly impossible to understand
and control each part of the code, whether it's monolith or several hundreds of microservices.

Within healthy organizations and teams there are and there will always will be natural, individual 
information islands. This is a totally normal process of professionalization, employee and project
development. This shouldn't be handled as a problem because it's OK and sometimes even wanted.

Depending on the organization these information islands are an intended result – the concept is 
called **information hiding**. Think about your organization. Where are your information islands?
With a look at HR or management, I'm sure you'll agree. 

Not every piece of information is for every consumer. We need these artificial and natural borders
to protect teams and employees from an unnecessary, unwanted and sometimes secret information. 
You'll find and need the same borders of information hiding in software architectures.

Organizations like Netflix run a countless number of microservices. Just as countless is the number 
of borders and hidden information. They are continuously shipping new features and services for 
their customers and are still in the market. From this, we can conclude that they can handle their
architecture.

### What does a typical monolith looks like?

As well as with microservices, developers have a more or less good definition of monolithic 
applications in their head. When I talk about a monolith, a so-called **deployment monolith** is 
meant. This is a piece of software which is deployed within a single deployment. Whether you have 
one big code repository or a dozen submodules, in the end they are getting deployed within a single
deployment, manually or automatically. 



## Microservice communication – Let's talk about protocols

## Micro Frontends – Decoupling down to the User Interface

## Tackling cross-cutting concerns within your architecture

## Transactions within and across microservices - Sounds like fun!

## Sources 
### My conference notes
### Heise's "Mastering Microservices" – About the conference 
#### The speakers


## Disclaimer

{{< disclaimer >}}
