---
type: post
title: "Software development with a focus on the core business concepts"
tags: []
date: 2021-08-15T09:07:06+02:00
# Nice IDE image: https://carbon.now.sh/?bg=rgba%28171%2C+184%2C+195%2C+1%29&t=monokai&wt=none&l=text%2Fx-go&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=
images: ["/assets/pexels-guduru-ajay-bhargav-1044302.webp"]
image_alt: ""
description: "How should we write software and how do we actually do it often? This is a brief overview of how to focus on core business concepts with DDD."
summary: "How should we write software and how do we actually do it often? This is a brief overview of how to focus on core business concepts with DDD."
toc: false
draft: true
---

How do you write software? Take a short break before you continue reading and think about your past
few software projects for customers. In today's post, we'll take a look at how to focus your 
software development projects on the customer's core business concepts and why this is the most 
sustainable way of software development. Furthermore, we'll look at Domain-driven Design as a 
toolbox providing best practices and patterns to achieve the focus on the core business concepts.

{{< toc >}}

## Isn't the focus already on core business concepts?

I can't answer this question in general, just for my past projects. When I think about all the 
software projects I was involved, there was never a *focus* on the customer's core business 
concepts. 

But what do I mean by **focus on the core business concepts**? When your customer tells you the 
requirements, and you add them to your backlog or to the contract, isn't that a focus? 

Let's think about the user story: "**As an investor in ETF funds, I want to be able to suspend my 
savings plan so that I don't have to invest during times when I have less money available.**". The 
customer passes the user story to the product owner, and he maybe adds some tasks to the board, 
let's say:
- Add an update function to the fund management to disable or enable a fund
- Add a filter to the debit module to ignore disabled funds when debiting the settlement accounts

The software development team is now starting by estimating and planning and giving some story 
points — or whatever — to the tasks and subtasks. Then they'll implement the requirements and 
everything is fine?

### The artificially delayed communication

What happened to the user story? The customer is an expert in his business field, and he knows his 
product like no other. The product owner has a similar expertise and understands the requirements of 
the user story. It gets exciting with the developers. They have usually no concrete idea of the 
customer's business field, their products and their processes. Furthermore, the customer has no idea 
of the technical language and terms of the developers. This often leads to massive problems in
communication. 

They both rely on the product owner in the role of a translator. He weaves a web of mappings between 
the customer's business terms and requirements, to the technical language of the developers. And at 
this point, a gap, a resistance in the flow of communication occurs. We are artificially delaying 
the communication, and we pay with a loss of information.

The software developers often have their own, wrong picture of the customer's business concepts, and
they are applying their own language and their processes to the software. Tiny little mistakes due
to miscommunication become bugs. Bugs are slowly but continuous filling the backlog until the 
customer calls the product owner and asks what is going wrong in development of his software.

### We lose information

Let's jump back to the user story and the tasks. Another problem is the lack of information, as I 
said before. We lose information not only within the resulting tasks, but also in the code. The
tasks do not contain a single word about the investor's intention of suspending the savings plan.
Maybe the developers added a simple update function to change the enabled state of the plan, at 
least that's how I would have done it in the past. But at this point we already lost the focus. 

Every interaction with a software and every process of a software should have the goal to be 
business oriented. A user doesn't suspend his savings plan because it's so cool and make's so much
fun to disable or enable the plan. The user has an intention, and we lose it by setting the focus to
technical concepts. 

### The non-ubiquitous language

I have witnessed so many escalation-meetings with customers. I missed the goal, lost the focus and
developed the wrong processes into the customer's application. Often it ends in meetings where my 
team and I tried to re-focus on the customer's core business concepts. We started building language 
maps to map the *customer's language* to our own weird self-created business language with the 
simple goal to talk within the same language context. The worst thing was, that I couldn't stop 
thinking and talking like a developer. I often confused the customers by talking about things like 
creating, updating and deleting entities, that we should use message queues and deploy with CI/CD.

On the other hand, our customers talked about strange concepts, operations and intentions. I just
couldn't figure out, what our customers are talking about. This often got me down. And all we 
accomplished was the use of BPMs and language maps.

Today I know want went wrong. We all spoke our own languages. There was a non-stop language mapping
in all conversations, meetings and in our minds. But we were on good way. We started with a simple,
helpful, but not perfect language map. We tried to share a deeper knowledge about our languages.

You may be wondering now what exactly the problem is. The use of a language map is a common tool to
improve the communication between different groups with divergent knowledge. You find the problem 
in its name. The problem is the mapping. Like as I wrote before, due to the mapping we artificially 
delay the communication.

As we know now, the key to a successful communication lies in speaking the same language. And I'm
not talking about mapping the customer's language to the "technical" language. I'm talking about a
language that is focused only on the customers business, processes, technics, etc. All of these 
aspects together, as well as each separately, are called "domain". So what we are looking for is a
domain-centric, omnipresent language. This language should be used by all project participants in 
all meetings and communications. Furthermore, the language is used in the later code. No more weird, 
self-chosen domain words and technical terms that sooner or later lead to problems, bugs and a lack
of communication.


## Using Domain-driven Design to focus on core business concepts

## Domain-driven Design by Eric Evans (Blue Book)

## Domain-driven Design by Vaughn Vernon (Red Book)

## Domain-driven design in everyday work and in cooperation with customers

## Implementing Domain-driven Design — a brief overview

## Books, websites and people who have interesting things to say about Domain-driven Design

### International books

- Eric Evans: Domain-Driven Design. Tackling Complexity in the Heart of Software. Addison-Wesley, 
  2003, ISBN 9780321125217
- Eric Evans: Domain-Driven Design Reference: Definitions and Pattern Summaries. Dog Ear Publishing, 
  LLC, 2014, ISBN 9781457501197
- Vaughn Vernon: Implementing Domain-Driven Design. Addison Wesley, 2013, ISBN 9780321834577
- Floyd Marinescu, Abel Avram: Domain-Driven Design Quickly. Lulu Press, 2006, ISBN 9781411609259 
  ([free ebook from infoq.com](https://www.infoq.com/minibooks/domain-driven-design-quickly/))

### German books

- Eric Evans: Domain-driven Design Referenz: Definitionen & Muster. Independently Published, 2019, 
  ISBN 9781794172593 ([free ebook from leanpub.com](https://leanpub.com/ddd-referenz))

### International websites

- [https://domaindrivendesign.org](https://domaindrivendesign.org/)
- [https://github.com/ddd-crew](https://github.com/ddd-crew)
  - [Welcome to Domain-Driven Design (DDD)](https://github.com/ddd-crew/welcome-to-ddd)
  - [Domain-Driven Design Starter Modelling Process](https://github.com/ddd-crew/ddd-starter-modelling-process)

### German websites

- [https://software-architektur.tv](https://software-architektur.tv/)

### German speaker and software architects

#### Eberhard Wolff — maintainer of software-architektur.tv

[Eberhard Wolff](https://ewolff.com) has more than 15 years of experience as an architect and 
consultant and is a model for me. He is an important software architecture influencer, author, 
speaker, maintainer of [https://software-architektur.tv](https://software-architektur.tv/) and a 
member of the [iSAQB](https://www.isaqb.org/). Eberhard Wolff is working as a Fellow at 
[INNOQ](https://innoq.com/) — one of the best-known and most innovative technology consulting 
companies in Germany.

#### Golo Roden — founder and CTO of the native web GmbH

Golo Roden is an inspiring person, a great speaker, an outstanding software architect and an
emerging influencer for software developers and architects. Furthermore, Golo Roden is the founder
and CTO of [the native web GmbH](https://thenativeweb.io/). The team behind 
[the native web GmbH](https://thenativeweb.io/) are the maintainers of the open-source CQRS and 
event-sourcing framework [wolkenkit](https://github.com/thenativeweb/wolkenkit).

#### Michael Plöd — author of "Hands-on Domain-driven Design - by example" on Leanpub 

Michael Plöd has over 15 years of experience in software architecture / development consulting. He 
is a regular speaker at national and international conferences with over 150 talks delivered and 
various awards for top presentations. Furthermore he is the author and translator of many articles 
and some books, e.g. *Hands-on Domain-driven Design - by example* and *Domain-driven Design 
Referenz: Definitionen & Muster*

## Disclaimer

{{< disclaimer >}}
