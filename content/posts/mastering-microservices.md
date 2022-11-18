---
type: post
title: "Mastering microservices"
tags: ["microservice", "software-architecture", "conference"]
date: 2022-08-28T13:42:15+02:00
images: ["/assets/heaven-gd38ed956a_1280.webp"]
description: "Many developers today have a rough definition of microservices in their head. Let's take a look at all the essential elements that make up microservices."
summary: "Many developers today have a rough definition of microservices in their head. Let's take a look at all the essential elements that make up microservices."
toc: false
draft: false
---

Most developers today have a more or less good definition of microservices in their head. Some are
developing within a microservice architectural environment and some are not. Long time I've
developed monolithic web applications and internal services/
{{< abbr "API" "Application Programming Interface" >}}'s without knowing of further software architectures.

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

Within healthy organizations and teams there are and there will always be natural, individual
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
the invoicing, this could even have consequences, depending on the necessity, where the tax office
(in Germany) gets involved.

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

One last thought. The switch from a **working** but unwanted, messy, deeply coupled, non-modular
system or from a monolithic application to several, well-designed microservices requires a lot of
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

German-speaking readers will find some valuable information about Conway's law (& software 
architecture) in one of Eberhard Wolff's podcast episodes on
[software-architektur.tv](https://software-architektur.tv).

{{< _figureCupper
img="https://software-architektur.tv/thumbnails/folge110.png"
imgLink="https://software-architektur.tv/2022/02/18/folge110.html"
alt="Preview image of the German software architecture podcast Software Architektur im Stream"
caption="Software Architektur im Stream [Folge 110 - Conway's Law](https://software-architektur.tv/2022/02/18/folge110.html)." >}}

## Microservice communication – Let's talk about protocols

Now let's move from abstract organizational communications and their influences to something more 
technical – how do our systems talk to each other? 

As in the Tower of Babel, dozens, hundreds of ways exist for systems to communicate. There is not
the one perfect communication system or protocol to rule them all. Every protocol, every technology
has advantages and disadvantages depending on its use case.

Among all these protocols & communication systems, two appear particularly frequently,
{{< abbr "REST" "Representational state transfer" >}} and message brokers. And among message
brokers, Kafka and RabbitMQ are among the most common. Other of the common cloud providers are
Amazon's {{< abbr "SQS" "Simple Queue Service" >}} and Google's Cloud Pub/Sub.

### REST vs. message broker

First, a rough classification, for all those who have not yet heard of one or both systems.

#### What is REST?

{{< abbr "REST" "Representational state transfer" >}}, abbreviation of representational state
transfer, is an architectural style, an internet protocol for synchronous communication between
systems, usually over the internet. Clients send requests to a system and expect responses. Each
request targets a specific, usually known and expected version of the requested resource, e.g. v1,
or v2. It's easy for an endpoint provider to provide multiple versions of given resources, and it is
just as easy for the consumer to switch to an older or a newer version.

The communication with {{< abbr "REST" "Representational state transfer" >}} is a client-driven
communication. The only way to receive information is to actively request a resource. The resource
never sends the information to all possible consumers.

{{< 
    mermaid 
    caption="mermaid flowchart diagram of an HTTP REST request from a client to a server"
    responsive="true"
>}}
flowchart LR
    subgraph oauth REST API
        direction TB
        subgraph v1
            direction RL
            a[auth adapter] -->|/api/v1/users| b[user resource]
            b[user resource] -->|users response| a[auth adapter]
        end
        subgraph v2
            direction RL
            c[auth adapter] -->|/api/v2/users| d[user resource]
            d[user resource] -->|users response| c[auth adapter]
        end
    end
    cl[Client] --- v1 --- op[oauth Provider]
    cl[Client] --- v2 --- op[oauth Provider]
{{< /mermaid >}}

#### What is a message broker?

A message broker is an application that receives and dispatches messages. You can think of it as a
phone system. A person/ system can send or dispatch a message to a mailbox. The owner or consumer of
this mailbox can read all the messages and answer each of them.

The hole concept behind a message broker is an asynchronous communication. It allows systems to
communicate with each other on a time-delayed basis without knowing the recipient(s) of the mailbox,
as well as the sender(s) of the message. The consumer may be another system, a dozen of systems or
nobody.

Due to the message character of this system, the communication is so called producer-driven. Usually
messages represent events from the producer's domain, e.g. "shipment failed". The producer
dispatches a message to a shared queue of the message broker. The message has the version of the
data, at the moment of sending. But most important, a message is not necessarily retrieved directly.
It can take milliseconds or even months.

{{< 
    mermaid 
    caption="mermaid flowchart diagram of a message broker receiving and providing the messages of its queues"
    responsive="true"
>}}
flowchart LR
    subgraph mb[message broker]
        direction TB
        q1[(user registration queue)]
        q2[(shipment queue)]
    end
    up1[producer 1] -->|"user registered (version 1)"| q1[(user registration queue)] --- ur1[consumer 1]
    upN[producer N] -->|"user registered (version N)"| q1[(user registration queue)] --- urN[consumer N]
    sp1[producer 1] -->|"shipment failed (version 1)"| q2[(shipment queue)] --- sr1[consumer 1]
    spN[producer N] -->|"shipment failed (version N)"| q2[(shipment queue)] --- srN[consumer N]
{{< /mermaid >}}

#### What are we looking for?

If we consider only these two approaches to inter-service-communication, we already see huge
differences in terms of availability of information and its version security.

Depending on the responsiveness of the development teams, both ways offer advantages and
disadvantages. In the context of small teams or individual developers in small companies, there will
hardly be many parallel changes of system interfaces and a quick reaction/ update is not necessary.
Therefore, the choice here falls more on the simpler, easier-to-implement communication. This is
probably just {{< abbr "REST" "Representational state transfer" >}}.

This contrasts in the context of distributed systems and large team structures of different bounded
contexts, where changes to interfaces can occur frequently. Thus, both ways in their pure form are
not what we are looking for.

Here we can't just choose the simplest and easiest-to-implement communication. We need rules and
fixed boundaries for our {{< abbr "API" "Application Programming Interface" >}}'s and their
development. These rules and boundaries some in form of contracts. Through contracts, we can enforce
message formats as well as there syntax.

Unfortunately, the contracts are not enough. In addition, contracts must be able to evolve and
regress. This compatibility can prevent unwanted/ unplanned breaking changes on the format and the
maximum possible format changes are limited to a certain known number.

In summary, we achieve a particularly high level of consumer safety through the contracts and their
development. Without the fixes that come from unannounced or poorly communicated breaking changes,
the focus shifts back to planned development, driven by stability, away from reactive
{{< abbr "API" "Application Programming Interface" >}} patchwork.

By decoupling producers and consumers via contracts, we avoid the implicit coupling that would
result from implementing non-contract message structures. You can recognize these implicit couplings
when you have to deploy your services simultaneously to prevent the system from crashing.

### Communication via REST

Pure {{< abbr "REST" "Representational state transfer" >}} communication between services is a valid
software architectural decision. It does not always require communication with a high compatibility
that is contractually enforced.

It is not my intention to demonize the common, widely used
{{< abbr "REST" "Representational state transfer" >}} in any way. I use it a lot myself and I love
the lightness and speed when implementing the resource endpoints. If I wanted to demonize it, that
would be hypocritical.

{{< abbr "REST" "Representational state transfer" >}} as well as other lightweight, architectural
{{< abbr "API" "Application Programming Interface" >}} decisions, like
{{< abbr "CQRS" "Command-Query-Responsibility-Segregation" >}}, show their full potential when used
in encapsulated, team and software architectures that in particular do not rely on parallel,
independent deployment processes.

If the decision is finally made to use {{< abbr "REST" "Representational state transfer" >}}, then
it is important to adhere to some basic pillars from the beginning that ensure a certain
{{< abbr "API" "Application Programming Interface" >}} compatibility.

One of these pillars is a versioned {{< abbr "API" "Application Programming Interface" >}}.
Depending on the quality attributes of changeability and maintainability as well as portability, it
is important to determine within the team and with the customer how many versions of the resources
must be provided.

At the outermost architecture level, it must now be ensured that different resource versions can be
provided in coexistence.

Eventually we end up with something that is similar to a contract between our the
{{< abbr "API" "Application Programming Interface" >}} consumer and the provider. In the first place
the {{< abbr "API" "Application Programming Interface" >}} is provider-/ producer-driven. If
necessary, endpoints required for consumers are provided separately. However, in all cases,
endpoints must be implemented by the consumer and provided by the provider.

But how does an {{< abbr "API" "Application Programming Interface" >}} consumer ensure that the
given, implemented endpoints do not change? How does the
{{< abbr "API" "Application Programming Interface" >}} provider ensure that the endpoints match the
consumers requirements? For example, an [OpenAPI](https://www.openapis.org/) documentation could be
used as a contractual artifact. Both sides could agree on this and even more, they could use
appropriate tooling to test the generated specification in an automated way.

Unfortunately, with pure {{< abbr "REST" "Representational state transfer" >}} we can't get around
verbal agreements and usually manual {{< abbr "API" "Application Programming Interface" >}} tests.
Even then, we run the risk of overlooking that one important email or Slack message from a
colleague alerting us that the "v1 endpoint" is about to be shut down.

What remains is, at best, an [OpenAPI](https://www.openapis.org/) specification of the endpoints
and manual end-to-end tests in test environments or constructed, complex end-to-end tests in
container environments developed specifically for this purpose, which are started up per release.

Consumer-driven contracts offer a way out of this. The entire
{{< abbr "API" "Application Programming Interface" >}} integration, including the request and
response models, is driven by the consumer, not the provider. 

### Consumer-Driven Contracts within a REST/ HTTP based communication

If we take a closer look at consumer-driven contracts, we come across a tool- & file-based
verification of these very theoretical "contracts". For
{{< abbr "HTTP" "Hypertext Transfer Protocol" >}} there is a valued tool called
[Pact](https://docs.pact.io/). It is a tool for code-first contract testing. 

#### HTTP CDC by Pact

Within {{< abbr "HTTP" "Hypertext Transfer Protocol" >}} you can test a single interaction between a
consumer and a provider, or a sequence of interactions. This interaction is called a "pact". To
create a new pact/ {{< abbr "CDC" "Consumer-Driven Contract" >}} we first need to write a unit test.

##### What are unit tests?

Unit tests are small pieces of code that test a small unit and/ or a behavior of the code. Usually
software developers use this to ensure, that a wanted behavior of their code fulfills a specific
domain requirement.

You can imagine the code as a black box with two openings, one for the input(s) and one for the
output. Within our test we specify the input(s), and we set our expectation(s) for the output. If
the actual output differs from our expectation, then the test is considered failed.

##### Set up a contract

With Pact, we can now use these tests not only to specify the pact, but we can also ensure that our
own code (consumer) adheres to this contract. Pact now tests if the address of our request is
correct and if we have provided all the required information for the producer. The information can
be found at two places of the request. First in the so-called header, which precedes the request,
and in the body, which is the core of our request.

To help Pact recognize our request, we first define a matching in the test, where we determine what
our request to the producer looks like. Additionally, we define the expected response from the
producer that should be returned in case of a successful request matching.

Now that Pact knows our contract, it spins up a so-called provider mock. This mock intercepts all
requests against our producer, checks if our request, i.e. the consumer side of the contract is
correct. If everything is as expected, Pact returns the previously specified & expected response. If
our request is not correct, then Pact returns an error.

As a further result of a successful test, Pact generates a machine-readable contract. These
contracts are in {{< abbr "JSON" "JavaScript Object Notation" >}} format and can be verified and
processed manually or automatically by further tools from Pact's toolbox.

##### Verify a contract

The verification is a part of the "further processing". For Pact itself it's not necessary to
automatically verify a generated contract.

The easiest way to verify a contract is to send it to the person or team responsible for it,
hereafter provider, and get confirmation that it can be honored.

Verification of contracts is the task of the providers. Pact also provides a tooling to verify
contracts in form of pact files within the providers tests. The tooling provides multiple ways to
verify a contract:

1. The easiest way is to just load a pact file within a unit test and to verify it with a simple
provider configuration.

The next steps require a so-called **Pact broker**. What this Pact broker is and how to use it, we
will look at in the next section.

2. You can automate your pact management with a Pact broker. The first way to verify a pact with a
Pact broker is to verify pacts by a tag, e.g. `master` or by an environment like `prod`.

3. Last but not least you can verify all contracts of a provider without specifying a tag.

In the verifier configuration it can be specified that the results are shared with the configured
broker. Both, the consumer and the provider, can make use of the results with Pacts "can I deploy"
feature, which allows stopping a deployment when the contracts can't be honored.

#### The Pact broker

As its name suggests, the Pact broker is a piece of software that takes over various tasks between
the consumers and the providers. Its main purpose is to provide pacts to providers, retrieved by
cosumers manually or by their {{< abbr "CI" "Continuous Integration" >}} pipeline.

As already mentioned in the last section, the broker collects the providers pact-test results to
share a "can I deploy" information with all contracting parties.

The Pact broker itself is published under the
{{< abbr "MIT" "Massachusetts Institute of Technology" >}} license. This allows you to use it
commercially and to make modifications to the code if necessary.

You can find the Pact broker repository at Github:
[pact-foundation/pact_broker](https://github.com/pact-foundation/pact_broker). This way you can
easilly setup your own broker.

##### Self-hosted

As with many software solutions out there, it is possible to operate a Pact broker yourself in
various ways.

The not-so-elegant way is to set it up yourself. Rent a server and follow the few
[roll-out instructions on Github](https://github.com/pact-foundation/pact_broker#rolling-your-own).
This will probably only make you popular in your conservative IT department, but not with your other
colleagues.

Of course, it is much cooler and more contemporary via a containerised approach. Pact has put
together some information for you on this, whether you just want to use the
[Pact broker Docker image](https://github.com/pact-foundation/pact-broker-docker) or deploy it via
[Terrafrom on AWS](https://github.com/nadnerb/terraform-pact-broker).

##### SaaS

If you don't want to take care of the hosting yourself, that's no problem either. In the end, Pact
also wants to earn some money with its broker and provides it as
{{< abbr "SaaS" "Software as a Service" >}} for this purpose, win-win situation. You can find the
service at [pactflow.io](https://pactflow.io/).

### Consumer-Driven Contracts within a message broker based communication


Nevertheless, I would like to sharpen your and my focus on the essentials. Whether we use a
technology or not depends in essence on several influencing factors. These factors are so-called
"non-functional requirements".

### Non-functional requirements

## Micro Frontends – Decoupling down to the user interface

## Tackling cross-cutting concerns within your software architecture

## Transactions within and across microservices - Sounds like fun!

## Sources 
### My conference notes
### Heise's "Mastering Microservices" – About the conference 
#### The speakers


## Disclaimer

{{< disclaimer >}}
