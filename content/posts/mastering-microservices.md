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

Meanwhile, I've been working with microservices for some years. This year my employer
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
and control each part of the code, whether it's a monolith or several hundreds of microservices.

Within healthy organizations and teams there are and there will always will be natural, individual
information islands. This is a totally normal process of growth, professionalization, employee and
project development. This shouldn't be handled as a problem because it's OK and sometimes even
wanted.

Depending on the organization these information islands are an intended result – the concept is
called **information hiding**. Think about your organization. Where are your information islands?
With a look at HR or management, I'm sure you'll agree.

Not every piece of information is meant for every consumer. We need these artificial and natural
borders to protect teams and employees from an unnecessary, unwanted and sometimes secret
information. You'll find and need the same borders of information hiding in software architectures.

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

The average developer associates monoliths with an easy to handle software architecture. It feels
like you have everything under control, and they are easy to test. That was my feeling when working
with big Dotnet, PHP or Java projects.

It was normal for me to wait 30, 60 or sometimes over 100 minutes for the build step to finish. I
thought it's because of all my complex and valuable business logic, but it wasn't. It's totally the
rule for monolithic architectures, and it was the same over all my projects of the past years,
whether it's the "small" Dotnet monolith within my Teamcity pipeline, or the massive PHP project
within my Bitbucket pipeline.

Directly after the build time follows the long startup time. It can be 15 minutes in average,
depending on how much the monolithic code is interwoven with dependencies, third parties and 
required manual actions. I remember painful deployments with manual database migrations & rollbacks,
changes on server configurations and missing linked libraries from the shared
{{< abbr "NFS" "Network File System" >}}.

Taking all these factors into account, it is not surprising that monolithic applications have a
deployment rhythm of several weeks to months. The time range of projects were I was involved goes
from two weeks until quarterly. That is hardly surprising when a deployment and further quality
assurance takes hours to days.

The worst part for me was when new features appeared over time. That's because the biggest part of
monolithic systems are often reciprocal relationships, which lead to dependency cycles. Modules and
services seam to be separated, but everything is closely coupled around their entities and helper or
utility functions. Integrating new functions is therefore like running the gauntlet.

Of course, this can be blamed on bad, unclean coding. But in reality it's often caused due to the
fact, that it is bloody easy to use the existing entity from another module because you are to lazy
to build clean context boundaries and think critical about your system's architecture, the correct
bounded context and about the concept of information hiding.

In the end it's just to easy to make this kind of mistakes and to accumulate technical debt.
Looking back at the common picture of monolithic applications, it's often the opposite. They are not
easy to handle, you have less control, and they are hard to test.

### Effects from multiple daily deployments

So what is the alternative and our goal to be able to build competitive software solutions and 
architectures? Back from my time in a web agency I can clearly say it's the ability to make multiple
daily deployments.

Especially the effect of a **better time to market** comes to my mind when I think about the 
wishes of our customers. When you have the ability of providing multiple new features and bug fixes
a day, then you can get a faster customer and user feedback about what works and what doesn't. 

As I already said, it's not only about new features. It's also about bug fixes. With small and fast
deployments it's easy to react to an unwanted behavior or bug(s) within your last deployment. Which
leads to the next effect of multiple daily deployments – **fewer burnouts**.

Thinking back at deployment days, I often feel uncomfortable. I remember going to work knowing that 
I will spend hours and hours preparing, performing and fixing deployments, that I have been 
working on for the past few weeks. Sometimes with my customers sitting right behind me.

Depending on your employer, your team and your customers it's more or less likely that you or your
colleagues end up with burnout.

Just the ability of deploying small features within minutes to production, knowing that a mistake is
fixed within minutes is a relief. There are no more deployment days with multiple daily deployments,
and no more stressful testing & deployment sessions with our customers.

But how are multiple daily deployments possible? How do I deploy code within minutes, and how am I 
able to test everything within a few minutes? The answer to these questions brings us to the subject
of this article – microservices. 

Small or big projects, written and wrapped around a bounded context. Think about domain driven code 
and interfaces, closely evolved within your or your customer's domain. There are clear and 
easy-to-test domain events, making it easy to ensure functionality of new features.

### To many modules on a single architectural layer lead to problems

When I talk with friends or other software developers about microservices, I've sometimes heard the
fear of an uncontrolled, incrementing amount of microservices, when giving the product teams the
choice to choose the best fitting software architecture.

They have pictures in their heads of a cluster with at least a thousand microservices communicating
and running there business logic with having no one being able to control all these services.

Of course, it's not possible to control such a software architecture that grows like weed in an
abandoned garden. But who thinks that this just could happen with microservices is wrong.

If seen perfect antipattern god-classes and build them on my own, too. A thousand and more 
functions, several thousand lines of code and a hell of a maintenance monster. 

Whether it's the monolith with it's god-class, or the microservice software architecture with a
thousand services, providing to many modules on a single architectural layer lead always to 
problems.

Instead of writing your monolith god-class, you should consider using (other) design patterns like 
the observer-, the singleton-, or the strategy-pattern to refactor your code to build better & 
cleaner architectural layers within your monolith.

And instead of deploying all thousand microservices to the same layer within your cluster, you
should consider stepping back and think about more granular layers for your edge services and for
the (potential) critical paths.

I don't want to say that it's easy and always a clear picture of what is wrong within your monolith
or your microservices. We all start at a specific point, and we learn continuously to work with our
architectural decisions.

It is always the same with software architecture and code. Both evolves over the time and we as
developers are responsible to continuously overthink and refactor our code and architecture.

### Microservices inherently come with higher risk

Looking at all different kind of software architectures, microservices have occasionally a big
potential of aberration. As all other things with a high risk, the potential is higher than with low
risk architectures like monoliths.

For me, it's comparable to the financial industry. In Germany, we have something called "Sparbuch",
which is just an account with the focus on saving money with an interest rate similar to the
European key interest rate, but not equal. It's an easy model with a low risk and potential that is
almost zero – and sometimes below.

The opposite is the investment market and the stock exchange. When you are open to a higher risk
and invest your money in an {{< abbr "ETF" "Exchange Traded Fond" >}} with a good, preferred market
risk, the interest rate increases significantly. Of course, now there is the risk of a stock market
crash, but that's your trade-off to increase your real interest rate to more than zero.

Switching back to microservices, it's a bad design or an ill-considered, unnecessary switch from a
monolith that leads to problems and a high(er) risk. 

In case you have a well working monolith, and you transfer it into a microservice architecture that
works like before, then you will have more problems and a higher failure potential than with your
monolith.

The most problems are caused by a poor design with close coupled, coherent services. This service
coherence is often the result of entity-focused services – not seldom as a result of rewrite from
an entity-centered monolith. 

Unlike bad designed microservices, well-designed microservices are easy to understand and easy to
deploy. The inherently higher risk is fully exploited here and systems flourish that perform far
above the capabilities of other software architectures.

### Well designed microservices due to modules

So, what is a well-designed microservice, and how do we build them? A good approach is a look at the
paper [Information distribution aspects of design methodology](https://cseweb.ucsd.edu/~wgg/CSE218/Parnas-IFIP71-information-distribution.PDF)
from David Parnas, an early pioneer of software engineering who developed the concept of information
hiding in modular programming and modular architectures.

**Modules as described in the paper**

A first important aspect is the presence of public interfaces. As long as our microservice serves
its interfaces it can be changed or replaced without further ado. That's because all data and all
information provided by our service will be used by other systems from the moment they are
available.

Knowing this, our goal should be to hide as much information as possible. The less information we
reveal, the easier it is to change or exchange the logic of our module. If we transfer this to the
teams and departments of a company, we find the same consequences and results. The less involved
people are in the processes and in decision-making, the easier it is to change the project
management framework and the tooling in general and to agree on team goals.

In {{< abbr "OOP" "Object-oriented programming" >}}, classes with private fields and methods as well
as public methods defined by an interface are a well-known and fine granular example for 
information hiding. A good tool to visualize the classes responsibilities and collaborations is the
{{< abbr "CRC" "Class-Responsibility-Collaboration" >}} model, developed in the 90th by Ward 
Cunningham and Kent Beck.

The **bounded context** is a more coarse-granular concept from Eric Evans book "Domain Driven
Design". It's used to represent infrastructure and system boundaries. As with classes, the
[bounded context canvas](https://github.com/ddd-crew/bounded-context-canvas) from the
[Domain-Driven Design Crew](https://github.com/ddd-crew) exists to document responsibilities and
collaborations for microservices.

An important commonality of {{< abbr "CRC" "Class-Responsibility-Collaboration" >}} and the bounded
context canvas is, that they are function-driven and not data-driven. It is remarkable that a
relatively old concept and a fairly new concept for representing responsibilities of collaborations
share such a commonality.

Therefore, it is legitimate to derive the following conclusions:
- You shouldn't build a system/ module based on data like orders, users, etc.
- Instead, you should build your system/ module function-driven, e.g, order service, registration
service, etc.

Everything we just mentally applied to our code also applies to our database and messages.
Information hiding in our databases and messages is as important as it is within our classes or our
bounded contexts. Sharing data via your database or your events is the same as exposing your private
class variables and functions.

**The bounded context**

We have now already clarified that microservices can be cut/ defined using a bounded context, but
what is a bounded context? What sounds simple and abstract now becomes a bit more abstract. 

A so-called "bounded context" binds our models from our code to a ubiquitous language. Ubi-what?
Roughly generalized, the ubiquitous language is a language agreed upon by all participants for a
given domain. It's used by the project manager, the domain expert, the web designer and in the code
by the software engineer.

We can use the bounded context to structure and group functionalities. Let's look at some examples
for different bounded contexts:
1. Invoicing and VAT can be grouped to an invoicing process
2. Package tracking and delivery can be grouped within a shipping process
3. Providing a shopping card and accepting orders can be grouped as an order process

Within our bounded contexts, internal data models now emerge, driven by functionality. The invoicing
service requires a billing address which is totally separated and independent of the shipping
address from the shipping service. When users change their address, the information must not be 
shared automatically with all modules. If this would automatically lead to a change of address in
the invoicing, this could even have consequences for the tax office (in Germany), depending on the
necessity.

Not only do the data models differ between bounded contexts, but the design decisions can be, and
often are, fundamentally different. From data storage, to the programming language, to the
frameworks used, all of these decisions are cleverly hidden behind the module's public interfaces.

All of this makes a bounded context a good module, and good modules are exactly what our
microservices should be.

### Microservices and productivity

Let's now consider the expectation, that microservices increase and improve our all in all
productivity. But how do we define productivity? What is it that we want to improve that leads to
a good productivity?

Our goal are **small and frequent deployments**. We don't want deployments that span several
thousand lines of code and intersect multiple context boundaries. It's a lot easier to build,
review and test a new feature without touching other context boundaries – especially when it comes
to understanding the domain requirements.

This is often not possible within monolithic applications. It's possible that multiple people and
multiple teams are working on the same code base. Changes and new features may interfere with other 
features and releases.

As a rule, the own changes are always held back and published with further changes to make as few
releases as possible.

{{< blockquote
quote="What is important is enabling teams to make changes to their products or services without depending on other teams or systems." 
author="Nicole Forsgren, Jez Humble, Gene Kim" 
title="Accelerate: The Science of Lean Software and DevOps: Building and Scaling High Performing Technology Organizations"
link="https://books.google.de/books?id=Kax-DwAAQBAJ&pg=PT83&lpg=PT83&dq=%22What+is+important+is+enabling+teams+to+make+changes+to+their+products+or+services+without+depending+on+other+teams+or+systems.%22&source=bl&ots=orBE5ygkEQ&sig=ACfU3U3pyyyx_937acheMC-5wcWya0K8xg&hl=en&sa=X&ved=2ahUKEwjFwNKDo8L6AhWB3KQKHZi2AR4Q6AF6BAgmEAM#v=onepage&q=%22What%20is%20important%20is%20enabling%20teams%20to%20make%20changes%20to%20their%20products%20or%20services%20without%20depending%20on%20other%20teams%20or%20systems.%22&f=false" >}}

Microservices are by nature modules and loosely coupled. They are build upon and around bounded
contexts, so it's unlikely that you will find multiple teams working on the same code. Furthermore,
microservices enable you and your team to do independent technology decisions, depending on your
or your companies guidelines.

### Microservices won't fix your organization

One last thought. The switch from a **working**, unwanted, messy, deeply coupled, non-modular
system or from a monolithic applicable to several, well-designed microservices requires a lot of
trust in your developers and domain experts.

There are reasons that lead to such systems and the concept, the idea behind this is well-known as
**Conway's law**.

{{< blockquote
quote="Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure." 
author="Melvin E. Conway" 
title="Committees Paper"
link="http://www.melconway.com/Home/Committees_Paper.html" >}}

Trusting that and how your developers make these decisions is critical. Otherwise, only the 
disadvantages remain, such as complexity.

## Microservice communication – Let's talk about protocols

## Micro Frontends – Decoupling down to the user interface

## Tackling cross-cutting concerns within your software architecture

## Transactions within and across microservices - Sounds like fun!

## Sources 
### My conference notes
### Heise's "Mastering Microservices" – About the conference 
#### The speakers


## Disclaimer

{{< disclaimer >}}
