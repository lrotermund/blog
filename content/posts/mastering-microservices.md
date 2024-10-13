---
type: post
title: "Mastering microservices"
tags: ["microservice", "software-architecture", "conference"]
date: 2023-09-25T00:30:15+02:00
images: ["/assets/heaven-gd38ed956a_1280.webp"]
image_alt: ""
description: "Many developers today have a rough definition of microservices in their head. Let's take a look at all the essential elements that make up microservices."
summary: "Many developers today have a rough definition of microservices in their head. Let's take a look at all the essential elements that make up microservices."
toc: false
draft: false
---

Most developers today have a more or less good definition of microservices in their head. Some are
developing within a microservice architectural environment and some are not. Long time I've
developed monolithic web applications and internal services/
{{< abbr "APIs" "Application Programming Interface" >}} without knowing of further software
architectures.

Meanwhile, I've been working with microservices for some years. Last year my employer
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

The **bounded context** is a more coarse-granular concept from Eric Evans book Domain Driven
Design[^bluebook]. It's used to represent infrastructure and system boundaries. As with classes, the
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
fixed boundaries for our {{< abbr "APIs" "Application Programming Interface" >}} and their
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
{{< abbr "CQRS" "Command-Query-Responsibility-Segregation" >}}[^cqrs], show their full potential
when used in encapsulated, team and software architectures that in particular do not rely on
parallel, independent deployment processes.

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
consumers manually or by their {{< abbr "CI" "Continuous Integration" >}} pipeline.

As already mentioned in the last section, the broker collects the providers pact-test results to
share a "can I deploy" information with all contracting parties.

The Pact broker itself is published under the
{{< abbr "MIT" "Massachusetts Institute of Technology" >}} license. This allows you to use it
commercially and to make modifications to the code if necessary.

You can find the Pact broker repository at GitHub:
[pact-foundation/pact_broker](https://github.com/pact-foundation/pact_broker). This way you can
easily set up your own broker.

##### Self-hosted

As with many software solutions out there, it is possible to operate a Pact broker yourself in
various ways.

The not-so-elegant way is to set it up yourself. Rent a server and follow the few
[roll-out instructions on GitHub](https://github.com/pact-foundation/pact_broker#rolling-your-own).
This will probably only make you popular in your conservative IT department, but not with your other
colleagues.

Of course, it is much cooler and more contemporary via a containerized approach. Pact has put
together some information for you on this, whether you just want to use the
[Pact broker Docker image](https://github.com/pact-foundation/pact-broker-docker) or deploy it via
[Terrafrom on AWS](https://github.com/nadnerb/terraform-pact-broker).

##### SaaS

If you don't want to take care of the hosting yourself, that's no problem either. In the end, Pact
also wants to earn some money with its broker and provides it as
{{< abbr "SaaS" "Software as a Service" >}} for this purpose, win-win situation. You can find the
service at [pactflow.io](https://pactflow.io/).

### Contracts (specifications) within a message broker based communication

Not only in the synchronous world do API contracts have to be adhered to, but also in the
asynchronous world of the message brokers. The problem here is the lifetime of the messages that are
exchanged. If a message is sent and retrieved within nanoseconds, this is less of a problem than if
a message is retrieved from a queue that has been sitting there for days or weeks.

The content of messages may well evolve over time, and what is in the body of a message today may
not be needed tomorrow. This is where the concept of scheme evolution comes into play. Because we
must always assume that our messaging scheme will change, we make its evolution part of our
specification.

#### They are not consumer-driven and they are not contracts

Before we look at tooling, we need to take a step back. Unfortunately, we cannot speak of a
{{< abbr "CDC" "Consumer-Driven Contract" >}} for events and messages as we do for
{{< abbr "HTTP" "Hypertext Transfer Protocol" >}}/
{{< abbr "REST" "Representational state transfer" >}}-based communication. Messages are inherently
driven by the producer. Usually, domain events are exchanged via messages to which other services
can react. Messages with a command character not only feel wrong, they are wrong. Just imagine a
command like "submit order" that will not be processed until the next week.

{{< abbr "IMHO" "In My Humble Opinion" >}}, you should send commands synchronously so that you get direct feedback. Often sensitive domain processes depend on these commands, where you can safely do without eventual consistency.

A further problem is the lack of precision. Within a
{{< abbr "HTTP" "Hypertext Transfer Protocol" >}}/
{{< abbr "REST" "Representational state transfer" >}}-based communication, there are a lot of
parameters allowing us to set up a precise contract. We are able to specify the
{{< abbr "HTTP" "Hypertext Transfer Protocol" >}} method, the
{{< abbr "URL" "Uniform Resource Locator" >}}, the
{{< abbr "HTTP" "Hypertext Transfer Protocol" >}} headers and the expected response. On contrary,
for the messages we have only the message body. There is no producer and no consumer information.
We can't check for standardized headers, nor for a specific message queue.

For these reasons, I will not speak of message contracts in the following, but rather of
message specifications that focus only on the content of a message and nothing around it.

#### Message specifications with Message Pact

Pact not only provides a way to handle your {{< abbr "HTTP" "Hypertext Transfer Protocol" >}}-
{{< abbr "CDCs" "Consumer-Driven Contract" >}}, it also provides a way to verify, that a message
consumer can handle a message of a given schema, as well as a way to verify, that a producer is
able to dispatch a message of a given schema.

The verification process is basically the same. You start by writing consumer and provider tests.
Also, the way how pacts getting exchanges between a consumer and a provider is the same. The
consumers pacts are shared with a Pact broker. The provider can test message schemas against pacts
from a given broker.

With Pact, it's not important which message broker you use. It's more important how the broker is
implemented within your project. Pact requires an implementation via the Ports & Adapters pattern so
that it can dock itself as a message broker.

For me, however, Pact is missing an important component to make it practical to use with message
brokers – seamless schema evolution.

Of course, Pact checks if a schema can be used, but in order to evolve a schema, consumers have to
be constantly updated in case of incompatibilities. This is exactly what I want to abstract away
with this tooling. I want my teams to be able to write code for their domains independently, without
having to wait for all the other teams every time. Of course, this doesn't work seamlessly with
schema evolution, but it's a first step in that direction.

#### Message specifications with Apache Avro

One way to get schema evolution is to use [Apache Avro](https://avro.apache.org/). Avro is a system
for a schema-based data serialization. The serialized data is in a binary format and wrapped within
a {{< abbr "JSON" "JavaScript Object Notation" >}}. The binary data has a compact encoding without
any field information.

Another benefit of the schema-based serialization system is the opportunity to use a generic message
wrapper/ generic record to represent the message. If you like it precise, you can also generate the
message record code based on the defined scheme.

The schema or format evolution is an integral functionality within Apache Avro. From sending to
receiving a message, it passes through several stations, all of which pay into this functionality.

##### The schema registry

A supporting software architectural component for schema evolution is the schema registry. The
schema registry is a central software service within our cluster that is used to validate, store and exchange schema information.

All services communicating with versioned schemas like Apache Avro or
[Google's Protobuf](https://developers.google.com/protocol-buffers/) are also always communicating
with the schema registry. It provides an
{{< abbr "ID" "Identification; In the field of computer science, usually a sequential number, or a unique string of characters. Used to identify and reference an entity." >}}
for a schema that can be sent with a message and can in reverse be used to get schema information for an
{{< abbr "ID" "Identification; In the field of computer science, usually a sequential number, or a unique string of characters. Used to identify and reference an entity." >}}.

To retrieve an
{{< abbr "ID" "Identification; In the field of computer science, usually a sequential number, or a unique string of characters. Used to identify and reference an entity." >}}
from the registry the passed schema must be
compatible. The compatibility verification is one of the main tasks of the registry.

##### The compatibility levels

An essential piece of information about a schema is the so-called compatibility level. This is
initially defined for a schema and allows our registry to compare it to another schema version.

There are seven levels of compatibility in the Apache Avro message format. The levels differ in the
allowed schema version, in the allowed changes to the schema, and in who must upgrade first – the
producer or the consumer.

###### The backward compatibility level

The backward compatibility level is a consumer-first level. This means, that:

- fields can be deleted from the schema – deleted fields will be ignored on deserialization
- optional fields can be added
- mandatory fields can be turned into optional fields

An optional field is a field with a default value in case of a missing value within the message.
This way the consumer deserializes the optional field with its default value as long as all
producers are not fully upgraded to the new schema. 

So the backward compatibility level allows the producers to send messages of schema `N` as well as
`N-1`. Which means in other words, that data written within the old schema version can be read by
the new schema version.

To illustrate this more clearly, here is a Golang example for an attempted delivery. The delivery
service (consumer) appends the nullable (nilable in Golang) bytes field `photo` as an optional
field.

The consumer's schema codec:
```json
{
    "type": "record",
    "name": "AttemptedDelivery",
    "fields" : [
        {
            "name": "id",
            "type": {
                "type": "string",
                "logicalType": "uuid"
            }
        },
        {
            "name": "date",
            "type": {
                "type": "int",
                "logicalType": "date"
            }
        },
        {
            "name": "address",
            "type": "some.address.record"
        },
        {
            "name": "photo",
            "type": ["null", "bytes"]
        }
    ]
}
```

The consumer's struct representation of the record, including the new nilable field `Photo`:
```go
type AttemptedDelivery struct {
    ID      uuid.UUID   `avro:"id"`
    Date    time.Time   `avro:"date"`
    Address Address     `avro:"address"`
    Photo   *[]byte     `avro:"photo"`
}
```

The producer's struct representation of the record without the field `Photo`:
```go
type AttemptedDelivery struct {
    ID      uuid.UUID   `avro:"id"`
    Date    time.Time   `avro:"date"`
    Address Address     `avro:"address"`
}
```

This way the consumer's `AttemptedDelivery.Photo` is nil as long as it is not set over the message.


###### The forward compatibility level

The forward compatibility level is the opposite of the
[backward compatibility level]({{< relref "#the-backward-compatibility-level" >}}) and is therefore
a producer-first level. This means, that:

- optional fields can be deleted from the schema
- optional and mandatory fields can be added
- optional fields can be turned into mandatory fields

It is only possible to delete optional field because removing mandatory fields could cause problems
on the consumer side. New fields, on the other hand, whether optional or mandatory, are simply
ignored on the consumer side.

So the forward compatibility level allows consumers with an implementation of the schema `N` can
read data `N+1`. Which means in other words, that data written within the new schema version can be
read by the old schema version.

To illustrate this more clearly, here is a Golang example for an attempted delivery. The shipping
service provider (provider) appends the bytes field `photo` as a mandatory field.

The producer's schema codec:
```json
{
    "type": "record",
    "name": "AttemptedDelivery",
    "fields" : [
        {
            "name": "id",
            "type": {
                "type": "string",
                "logicalType": "uuid"
            }
        },
        {
            "name": "date",
            "type": {
                "type": "int",
                "logicalType": "date"
            }
        },
        {
            "name": "address",
            "type": "some.address.record"
        },
        {
            "name": "photo",
            "type": "bytes"
        }
    ]
}
```

The producer's struct representation of the record, including the new field `Photo`:
```go
type AttemptedDelivery struct {
    ID      uuid.UUID   `avro:"id"`
    Date    time.Time   `avro:"date"`
    Address Address     `avro:"address"`
    Photo   []byte      `avro:"photo"`
}
```

The consumer's struct representation of the record without the field `Photo`:
```go
type AttemptedDelivery struct {
    ID      uuid.UUID   `avro:"id"`
    Date    time.Time   `avro:"date"`
    Address Address     `avro:"address"`
}
```

This way the producer's `AttemptedDelivery.Photo` is not deserialized as long as it is not 
implemented on the consumer's side.

###### The full compatibility level

The full compatibility level is the combination of the
[backward compatibility level]({{< relref "#the-backward-compatibility-level" >}}) and the
[forward compatibility level]({{< relref "#the-forward-compatibility-level" >}}), and accordingly it
does not matter who updates their schema first. This means, that:

- optional fields can be added
- optional fields can be deleted
- it's not possible to change the state of mandatory fields into optional fields
- it's not possible to change the state of optional fields into mandatory fields

It is only possible to add and delete optional field because adding and deleting mandatory fields,
as well as turning them into optional fields could cause problems on the both side.

So the full compatibility level allows consumers with an implementation of the schema `N` can read
data `N+1` and consumers with an implementation of schema `N+1` can read data `N`. Which means in
other words, that data written within the new schema version can be read by the old schema version
and data written within the old schema version can be read by the new schema version.

When choosing full compatibility, one must inevitably ask whether the flexibility gained outweighs
the cost of having only optional fields. Depending on the domain, valuable validations could be lost
as a result.

###### The \*_transitive compatibility levels

All the previously described compatibility levels are testing the new schema version against their
previous schema version. If a test is successful, the new scheme can be registered and messages can
be dispatched matching the corresponding scheme. However, if there may be consumers or producers
that are more than one version apart, there can be problems and incompatibilities with the previous
schemes.

For this purpose, the **\*_transitive** compatibility level exists as an annotation for all previous
compatibility levels. Just attach **\*_transitive** to the compatibility level and the new version
is getting tested against all previous versions. 

Available **\*_transitive** combinations and their meaning:

- **backward_transitive** – the data written in any old schema version can be read with the new
schema version
- **forward_transitive** – the data written in the new schema version can be read by any old schema
version
- **full_transitive** – that data written in the new schema version can be read by any old schema
version and data written in any old schema version can be read by the new schema version

###### The none compatibility level

If you do not want a compatibility check, e.g. because the application is still under development
and the entire domain model is not yet known, you can use compatibility level `none`.

With the none compatibility level, any change to the schema is allowed. It is OK to delete mandatory fields, change their type and so on.

Based on this, it should quickly become clear that any adjustment of the scheme version can lead to
breaking changes between consumers and producers. Therefore, use the none compatibility level only
with very high attention and in very close consultation between the consumers and producers. It is
also best to use it only during development and switch to another compatibility level for a release.

### CDC via HTTP or message specifications?

Finally, I would like to sharpen your and my focus on the essentials. Whether we use a
technology or not depends in essence on several influencing factors. These factors are so-called
**non-functional requirements**.

It's just as legitimate to go for pure {{< abbr "HTTP" "Hypertext Transfer Protocol" >}} based and
purist {{< abbr "CDCs" "Consumer-Driven Contract" >}} as it is to opt for message & schema based
ones in the end.

These primarily customer-driven, non-functional requirements should always serve as the basis for
decision-making in the end and be recorded accordingly. It is important that people who are aware of
these non-functional requirements work them out specifically with the customer and thus understand
the subtleties of the actual requirements.

## Micro front-ends – Decoupling down to the user interface

Within the world of {{< abbr "UIs" "user interface" >}}, modular, decoupled micro front-ends are a
rarity. The common front-end, whether website or native application, is part of a monolith or
monolithic itself. A big piece of software, spanning multiple sub-contexts of a bigger bounded
context or several bounded contexts. And everything deployed within a single deployment.

But why? Front-ends are as modularizable as back-ends.

### What are micro front-ends, and why should you use them?

Rightly, most (front-end) developers wonder at this point why they should use micro front-ends.
Usually it is enough and sufficient for a project to write a React, Angular or Vue based
{{< abbr "SPA" "single-page application" >}}. So why the supposed mental overhead of splitting it up
into parts/ modules as well? Isn't it enough to split the back-end?

In the picture of today's software architectures micro front-ends have simply not arrived yet and
that is understandable.

#### Today's software architectures

To classify the micro front-ends, let's take a brief look at the software architectures commonly
used today. After that, it will also be easier to understand where we can start in order to open up
a sensible alternative to the existing frontend architectures with the micro frontends.

##### The monolith

The monolith is usually a so-called **deployment monolith**. It includes the entire back-end and
front-end code of all bounded contexts, as well as the database. The name of the
**deployment monolith** arises from the fact that the entire code of all bounded contexts is
deployed when changes are made to a single context.

Especially the front-end code is strongly interwoven with the back-end code. Often the front-end
is not {{< abbr "API" "Application Programming Interface" >}}-based, but comes mainly
request-driven via template engines that get the necessary data provided and assemble the
front-end based on it.

Of course, this is only one possible manifestation of front-ends in monoliths. Of course, there are
also monoliths that provide front-end code, which in turn communicates with the
{{< abbr "APIs" "Application Programming Interface" >}} of the application to have clear interfaces
between the back-end and the front-end. Unfortunately, the latter is actually the exception rather
than the rule.

##### Front-end & back-end

A still monolithic software architecture is the separation of front- and back-end. Both are
monolithic despite separation at the level of the code base and deployment.

In the back-end we find a code that, in the best case distributed over several modules, provides
the business logic of the bounded contexts via
{{< abbr "APIs" "Application Programming Interface" >}}. The back-end itself does not provide any
front-end code and does not assemble it.

Also in the front-end we find, in the best case distributed over several modules, the
{{< abbr "UI" "user interface" >}} representation of our bounded contexts. The code is detached
from the back-end and is developed and deployed separately.

##### Microservices

Lastly, we have the combination of a classic monolithic front-end that communicates via an
aggregation layer/ gateway with a distributed microservice back-end.

The architecture of the front-end is built the same as in the previous style of
[front-end & back-end]({{< relref "#front-end--back-end" >}}). There is a monolithic code base,
which in the best case represents all bounded contexts in a modularized way.

In the back-end, on the other hand, there is a clean division of the bounded contexts into
independently deployable services. Each service knows its own domain models, has its own interfaces
and its own data management. Everything is accessible and protected behind an aggregation layer/
gateway.

##### What all have in common

As you can see, micro front-ends are not yet of any significant importance in current software
architectures. All of today's software architectures usually have a monolithic front-end, which
modularizes the bounded contexts sometimes more and sometimes less well, if there is a separation
at all.

That it can be done better is often clear to many developers, but the hurdle is high for many teams
to deal with new things in general, especially when it comes to front-ends.

#### Definition of a micro front-end

Micro front-ends pursue the goal of separating and modularizing bounded contexts in the front-end.
The code is delivered in self-contained parts and is not mixed in a monolithic code base.

They integrate with the holistic goal of separating domains into specialized teams, forming a
completion of the chain in the {{< abbr "UI" "user interface" >}}.

Each feature and requirement of a bounded context is owned by a single specialized team from
definition, through integration in the microservice, to the micro front-end. This includes their
testing, development and **individual deployment**.

#### e-commerce example for a micro front-end

To illustrate this, we will now look at an example from the field of e-commerce, precisely because
this is one of the most tangible and everyday areas in which micro front-ends can generate
significant added value above a certain company size and revenue level.

To make the example a little more precise and mean, let's look at the ownership within the article
detail page. Micro front-ends are not only about responsibilities for certain pages, but in
particular for certain areas and sections.

##### Team Checkout

Checkout is a not insignificant bounded context of the domain in which we operate. Without a good
customer experience on the way to the order, the checkout may well be abandoned.

To provide the best possible {{< abbr "UX" "User Experience" >}} for customers during checkout,
Team Checkout owns the following features on the article detail page:

- The buy button, as it is the first part of the checkout process
- The basket, as it is the gateway to the checkout process

##### Team Inspire

Team Inspire ensures that your shopping cart is as full as possible and that you have an all-round
good feeling after shopping. A bounded context that is probably underestimated but not to be
neglected.

Whether it's the matching pants to the jacket, the
{{< abbr "SATA" "Serial Advanced Technology Attachment" >}} cable to the
{{< abbr "SSD" "Solid State Drive" >}}, the luggage strap to the brand-new suitcase, or the dip for
the dry pizza crust. The matching additional article in the delivery makes the order feel complete
for the customer.

For this reason, the team owns the following features:

- The related articles, as here the customer is shown what all fits to this product and what else
he should think about
- The customers also bought articles, because here the customer is shown that...
  - Other customers have already purchased this item, and...
  - These other customers bought other articles that went well with the current article

##### Team Decide

An article photo that leaves no room for doubt and shows the article from its best side, an article
description that removes the last doubt from the undecided customer and a list with hard technical
facts for the {{< abbr "TL;DR" "Too long; didn't read" >}} faction, all this is delivered by Team
Decide.

Team Decide is the owner of the article detail page. It provides all information of its bounded
context and coordinates with the other teams which features can and should be embedded.

Besides the whole page, the team owns in particular the features:

- The article image(s)
- The article description
- The technical details
- The articles variants

##### And so on...

Probably some more teams like **Customer Satisfaction**, **Customer Communication** or **Legal**
could be pointed out, all of which are responsible for bounding contexts that come into play here,
but the goal and scope that micro front-ends can have, should have become clearer.

The most important thing is that teams emerge around bounded contexts, not dumb entities. A team
always accompanies the entire process of its bounded context and is eventually responsible for its
success.

#### Independent systems due to micro front-ends

We have now learned that teams are being formed around bounded contexts. But how are these teams
structured? Do we now split up our existing software engineering department and raise digital walls
between our colleagues?

##### Cross-functional teams

No, of course we won't do that. These teams do not even consist of software engineers at their
core. It's about a wide range of skills, covering all the essential areas from software
development, data analysis and evaluation, {{< abbr "UI" "user interface" >}} and
{{< abbr "UX" "User Experience" >}} specialists, product owner, to DevOps – in short, it's about
cross-functional teams.

As I write this, I can well imagine a large part of the readers now wondering what kind of
organizational overhead this will create in the end, and that it will never work in this manner.
And you are not completely wrong. Of course, this is not a form of organization for a startup with
four employees that is barely able to pay these few salaries and prays that the next release will
not bring any major bugs that threaten the loss of customers.

This form of organization is aimed at companies with enough staff and their aim is to get the
maximum out of a bounded context, what ultimately leads us to another related goal.

##### End-To-End responsibility

Another effect, as well as an initial goal of these cross-functional teams, is the
{{< abbr "E2E" "End-To-End" >}} responsibility for their bounded context. By concentrating
knowledge and building competence around a bounded context, domain-related questions and processes
can be quickly and easily clarified and implemented.

If these responsibilities and affiliations do not exist, no one is responsible in these matters, no
one who takes care of the process or the correct implementation of specialties. The attention then
lies as often on the whole and not in detail.

##### Enabling & empowerment with self-contained systems

The best way to succeed is to empower and liberate your employees and teams. Work in constricted,
strict and inflexible environments leads to poor results. Teams evolve into technology and decision
followers instead of exploring and driving them freely.

As the competence and responsibility is concentrated in the hands of the cross-functional teams,
they can act independently. From planning to implementation to release, at no point does the team
have to wait for decisions, approvals, or outputs from other teams.

#### Advantages of micro front-ends

By decoupling the teams in bounded-context centered, cross-functional teams, a number of advantages
arise for the company, as well as for the employees.

1. better time to market

Empowered, small teams that are based on a bounded context, self-contained, decoupled and free from
other teams, implement the processes and features of a domain significantly faster than teams that
need to constantly switch between multiple domains/ bounded contexts.

2. efficiency

Due to the low team size, there are short, direct communication channels with a low need for
coordination and clear responsibilities. A team with a size of 6-8 people communicates and works
significantly more effectively on jointly defined goals than a team of 24-30 people.

3. specialized teams

Bundling competencies and goals in cross-functional, specialized teams reduces the coordination
effort enormously. Only the avoidance of dozens of coordination meetings between teams such as
development, specialist department and IT operation saves project and development time.

#### Disadvantages of micro front-ends

Of course, micro front-ends not only bring advantages. Let's first take a look at the most obvious
disadvantage.

1. complex & expensive

Not every company can afford to build cross-functional teams exclusively around bounded contexts. As
a domain is not only composed of a single bounded context, a not inconsiderable part of the
personnel must be used to form these teams. Small companies can hardly afford the advantages,
including cross-functional teams.

2. technology anarchy (antipattern)

The freedoms that the teams have for the development of their micro front-ends can quickly lead to
technological anarchy where the first team uses Vue 3, the next team build its frontend with jQuery
and the last team's micro front-end is based on React.

Should it ever come to that point, which would not be a problem for the functionality, but just for
reasons of interchangeability of employees, the teams should agree on a technology-stack here and,
if necessary, provide a starter kit for a micro front-end.

### How to use micro front-ends

Enough with the pros and cons, let's look at what is important for the integration and
implementation of micro front-ends. We start with the responsibilities around integration.

#### Page ownership

As already broached, each page of our application has an owner. This ownership is assigned to teams
within the domain along the user journey. Let's go back to our e-commerce application for an
example.

##### Team Inspire

The potential buyer searches in the search engine of his choice for a garment from which he snapped
in a conversation that is currently sold out everywhere.

Among the first search results, he unconsciously clicks on one of the ads, as he finds the image
which is also displayed there unusually appealing. The ad directs him to a hip website, the content
of which is only about the garment he was just looking for.

Another potential customer comes to our e-commerce application and is inspired by the trends and
ads on the home page. From time to time, the user leaves the home page in order to find out about
the offers of a certain category of clothing.

Team Inspire's mission is to attract visitors, inspire and impress them, and ultimately turn them
into buyers. Their responsibilities include, but are not limited to:

- landing pages
- home page
- listing pages
- wishlist page

##### Team Decide

There it is finally! Just the garment that the inspired visitor still lacks for the colder, windy
autumn days!

Arriving at the detail page of the article, the visitor now finds beautifully staged model photos
in a golden yellow autumn forest with an orange sun that disappears in the background between the
trees.

The visitor dreamily imagines him or herself walking through the autumnal city park in the new
garment and does not even need the charmingly written description to make a decision. The article
goes into the basket!

Getting inspired visitors to make a decision is very difficult in today's world full of abundance
and offers on every corner. That is the sole task of Team Decide. It requires an enormous effort to
keep neat, convincing and in the context of the time suitable images and texts for all products to
simplify the way to the decision for every undecided person in the end.

So, the only responsibility of the team is the site:

- detail

##### Team Checkout

Clearly structured and without distraction, the journey of the convinced visitor leads via the
basket to the final checkout.

The payment method of previous orders is already selected, great! Oh, but what is this? The visitor
stumbles upon an unmissable banner in the middle of the listing of all items in his basket. If he
or she orders in the next few minutes, he or she will receive a loyalty discount of 20% and an
additional autumn surprise?

Without hesitating any longer, the order is placed! On the confirmation page the website thanks the
buyer for the purchase and offers another voucher for the next visit in exchange for a short
feedback on today's purchase.

To pick up the visitor, not to dissuade him from buying, but to encourage him if possible, if
necessary under slight time pressure, and to let him go with a good feeling after the purchase, so
that he turns into a repeat buyer, these are the responsibilities of Team Checkout.

It is precisely the conversion of buyers into potential repeat buyers that is the focus of the 
overwhelming majority of orders. This is due to the high customer acquisition costs through
advertisements. Usually, a customer only becomes profitable once he or she makes a repeat purchase.

The following areas of responsibility of Team Checkout can be derived from this:

- basket page
- payment page
- confirmation page

##### Fragment/ feature responsibilities

On this fictional user journey, visitors encounter a series of {{< abbr "UI" "user interface" >}}
elements that guide them step-by-step, all the way to the intended purchase. 

Not all of these elements on this journey belong to the respective site owners. The teams provide
features and fragments to each other, which then fall under a different responsibility.

Which elements are placed on the page and which are not, as well as their further maintenance, are
organized by the team that owns the page.

#### Techniques & challenges for micro front-end integration

When you think about the implementation of micro front-ends, a lot of questions probably pop into
your head. As the lion's share of websites has not been implemented based on micro front-ends, the
fewest readers are probably familiar with the technical details.

I'm no different, I haven't built a website based on micro front-ends yet either. Nevertheless, I
want to take you with me and show you what I learned in the talk.

##### Technique overview

Technologically, there are actually many ways to realize micro front-ends. And some of them you
probably won't expect. Let's look at the most obvious one, iFrames.

iFrames are {{< abbr "HTML" "HyperText Markup Language" >}} elements that can be used since
{{< abbr "HTML" "HyperText Markup Language" >}} version 4.0 to embed other web documents into a
{{< abbr "HTML" "HyperText Markup Language" >}} document. While iFrames are now somewhat out of
fashion, they were used productively even until 2019 in Spotify's music player to implement micro
front-ends.

Also, out of fashion since the introduction of the fetch
{{< abbr "API" "Application Programming Interface" >}}, but yet functional is the way over
{{< abbr "AJAX" "Asynchronous JavaScript and XML" >}}.

Another, more modern and stable client-side way are the web components. Web components are custom
web elements that can be defined and used just like any other
{{< abbr "HTML" "HyperText Markup Language" >}} element. These custom elements are supported by any
technology that can handle the standard elements. All elements within a custom web element are
encapsulated and do not collide with the elements in which the element is embedded.

There is more information on the page of the standard of the web components under
[webcomponents.org](https://www.webcomponents.org/).

On the back-end side, we also have different technologies for composing micro front-ends. Both
technologies are no longer the latest, yet modern, powerful systems that compose their front-ends
on the server cannot do without them.

So, on the one hand, we have {{< abbr "SSI" "Server Side Includes" >}}, which focuses on script
commands that are executed by the responsible web server to compose the micro front-end.

On the other hand we have {{< abbr "ESI" "Edge Side Includes" >}}, which basically has the same
functions as {{< abbr "SSI" "Server Side Includes" >}}, but extends it with an alternative include
and error handling. Furthermore, {{< abbr "ESI" "Edge Side Includes" >}}, unlike
{{< abbr "SSI" "Server Side Includes" >}}, focuses on caching.

There are a few more server-side micro front-end technologies, but these are usually very limited
in their applicability as they focus on single languages like
{{< abbr "JS" "JavaScript" >}}. For this reason I will not deal with them further here.

##### Micro front-end composition

As is so often the case in IT and software architecture, many roads lead to Rome. Which direction a
team chooses and which of the paths is better and which is worse is something I do not want to and
cannot determine; in the end, only the team can do that after careful consideration of the
projects {{< abbr "NFRs" "non-functional requirement" >}}. 

###### Server-side composition

As mentioned in the technical overview, we are primarily looking at
{{< abbr "SSI" "Server Side Includes" >}} and {{< abbr "ESI" "Edge Side Includes" >}} on the server
side. We will start with {{< abbr "SSI" "Server Side Includes" >}}, since it is based on a minimal
setup.

Below is a short sequence diagram that shows a request against a product detail page that is owned
by Team Decide and has an {{< abbr "SSI" "Server Side Includes" >}} from Team Checkout.

{{< 
    mermaid 
    caption="mermaid sequence diagram of an HTTP REST request from a client to a nginx server composing a response with SSIs."
    responsive="false"
>}}
sequenceDiagram
    participant client
    participant nginx
    participant decide as Team Decide
    participant checkout as Team Checkout

    %% Step 1
    client ->> nginx: GET /cool-laptop-case
    activate nginx

    %% Step 2
    nginx ->> decide: GET /cool-laptop-case
    activate decide
    %% Step 3
    decide ->> nginx: Product detail response, including SSIs
    deactivate decide

    %% Step 4
    nginx --> nginx: Parse SSIs
    Note right of nginx: Found SSI for "/checkout/add-to-basket"

    %% Step 5
    nginx ->> checkout: GET /checkout/add-to-basket
    activate checkout
    %% Step 6
    checkout ->> nginx: "add to basket" micro frontend response
    deactivate checkout

    %% Step 7
    nginx ->> client: composed front-end
    deactivate nginx
{{< /mermaid >}}

The request flow for an {{< abbr "SSI" "Server Side Includes" >}} composed micro front-end is
relatively straightforward. The client's request first goes to nginx, which acts as an orchestrator
and ensures that the requests are forwarded to the correct endpoints of the responsible teams.

In **step 4**, nginx determines the {{< abbr "SSIs" "Server Side Includes" >}} provided by Team
Decide. These are included in the page resource as follows.

```html
<h1>Cool laptop case</h1>
<img src="/cool-laptop-case.webp"
    alt="Rustic chestnut colored laptop case made of sturdy faux leather." />
<!--#include virtual="/checkout/add-to-basket" -->
```

As in the example, nginx would now recognize "/checkout/add-to-basket" as an
{{< abbr "SSI" "Server Side Includes" >}} and load it from Team Checkout to replace it within the
response document.

Learn more about server-side composition of micro front-ends with
{{< abbr "SSIs" "Server Side Includes" >}} in nginx in the corresponding module documentation:
[ngx_http_ssi_module](https://nginx.org/en/docs/http/ngx_http_ssi_module.html)

Now follows the sequence diagram that again shows a request against the product detail page, but
this time against a Varnish proxy instead of a nginx. The page responsibility is still with Team
Decide. Instead of {{< abbr "SSIs" "Server Side Includes" >}}, the team integrates
{{< abbr "ESIs" "Edge Side Includes" >}} that can be composed by Varnish.

{{< 
    mermaid 
    caption="mermaid sequence diagram of an HTTP REST request from a client to a varnish proxy server composing a response with ESIs."
    responsive="false"
>}}
sequenceDiagram
    participant client
    participant varnish
    participant decide as Team Decide
    participant checkout as Team Checkout

    %% Step 1
    client ->> varnish: GET /slim-briefcase
    activate varnish

    opt No cached object for "/slim-briefcase"
        %% Step 2
        varnish ->> decide: GET /slim-briefcase
        activate decide
        %% Step 3
        decide ->> varnish: Product detail response, including ESIs
        deactivate decide

        %% Step 4
        varnish --> varnish: Add page object to cache
    end

    %% Step 5
    varnish --> varnish: Parse ESI objects
    Note right of varnish: Found object for "/checkout/add-to-basket"

    opt No cached object for "/checkout/add-to-basket"
        %% Step 6
        varnish ->> checkout: GET /checkout/add-to-basket
        activate checkout
        %% Step 7
        checkout ->> varnish: "add to basket" micro frontend response
        deactivate checkout

        %% Step 8
        varnish --> varnish: Add ESI object to cache
    end

    %% Step 9
    varnish ->> client: composed front-end
    deactivate varnish
{{< /mermaid >}}

The {{< abbr "ESI" "Edge Side Includes" >}} composition flow is a bit more extensive than
{{< abbr "SSI" "Server Side Includes" >}} composition and essentially brings the advantage of being
able to cache documents/ objects, which leads to a huge improvement in response time.

If a request arrives at the Varnish proxy at **step 1**, the proxy first checks if it already has a
cached entry for this request or if it has to forward the request.

In **step 5**, Varnish checks if there are {{< abbr "ESIs" "Edge Side Includes" >}} in the cached or
retrieved document. If so, any include found is loaded from the cache, or from the providing team.
The {{< abbr "ESIs" "Edge Side Includes" >}} are included in the page resource as follows.

```html
<h1>Slim briefcase</h1>
<img src="/slim-briefcase.webp"
    alt="Extra slim briefcase made of a fine black leather with integrated combination lock and a sturdy handle made of steel and leather." />
<ESI:include src="/checkout/add-to-basket"/>
```

Learn more about server-side composition of micro front-ends with
{{< abbr "ESIs" "Edge Side Includes" >}} in Varnish in the corresponding user guide:
[Varnish cache ESI user guide](https://varnish-cache.org/docs/7.2/users-guide/esi.html)

###### Client-side composition

On the client side, just as with the back-end, I want to commit to two implementation paths,
because I don't expect iFrames and {{< abbr "AJAX" "Asynchronous JavaScript and XML" >}} to be
desirable ways for you to implement front-ends.

First, let's return to the custom elements/ web components from the technical overview and see how
we can include our own micro front-end component.

Custom elements consist of two parts:

```html
<h1>Lightweight Hiking Backpack - Quick feet, black</h1>
<img src="/img/lightweight-hiking-backpack_quick-feet-black.webp" 
    alt="With this lightweight & ergonomic hiking backpack, you won't notice what you've been carrying all day when you reach your hiking destination." />

<checkout-add-to-basket />

<script src="/components/checkout/add-to-basket.js" />
```

What happens inside the micro frontend web component defines an associated
class that extends the `HTMLElement`.

```javascript
class CheckoutAddToBasket extends HTMLElement {
  connectedCallback() {
      this.#render();
      this.firstChild.addEventListener('click', this.#addToBasket);
  }
  
  #addToBasket() {
    // Send post request
  }

  #render() {
    this.innerHTML = `<button type="button">add to basket</button>`;
  }
}
    
customElements.define(
    'checkout-add-to-basket',
    CheckoutAddToBasket
);
```

So custom elements are basically exactly what you would expect, custom
{{< abbr "HTML" "HyperText Markup Language" >}} elements whose functionality
can be defined by yourself. Not only is this a pretty cool and handy tool, custom elements as such
are also part of the {{< abbr "HTML" "HyperText Markup Language" >}} standard. We can make good use
of this feature with micro frontends. See
[HTML spec 4.13](https://html.spec.whatwg.org/multipage/custom-elements.html#custom-elements) for
more information.

Custom elements are used, for example, by Angular as the basis for the Angular elements.

{{< blockquote
quote="Angular elements are Angular components packaged as custom elements (also called Web Components), a web standard for defining new HTML elements in a framework-agnostic way." 
author="Igor Minar, Matias Niemelä" 
title="Angular elements overview (2023-01-27)"
link="https://angular.io/guide/elements" >}}

Based on the custom elements we can now also work with the shadow
{{< abbr "DOM" "Document Object Model" >}}, which brings more complexity but also more flexibility.

The procedure here is similar to that for custom elements. The main difference is that we define
our element as a so-called shadow root, which can be open or closed for JavaScript access from
outside. We can now attach any other elements to this shadow root.

But what is the advantage here compared to a custom element? Quite simply, encapsulation. The
shadow {{< abbr "DOM" "Document Object Model" >}} is its own decoupled
{{< abbr "DOM" "Document Object Model" >}} where markup, styling and code does not clash with other
code.

```html
<style>
  button {
    background: #000;
    color: #fff;
  }
</style>

<h1>Lightweight Hiking Backpack - Quick feet, black</h1>
<img src="/img/lightweight-hiking-backpack_quick-feet-black.webp" 
    alt="With this lightweight & ergonomic hiking backpack, you won't notice what you've been carrying all day when you reach your hiking destination." />

<button>add to favorites</button>
<checkout-add-to-basket />

<script src="/components/checkout/add-to-basket.js" />
```

```javascript
class CheckoutAddToBasket extends HTMLElement {
  constructor() {
    super();

    const shadowRoot = this.attachShadow({ mode: "open" });
    
    const btn = document.createElement("button");
    btn.innerHTML = "add to basket";
    btn.onclick = this.#addToBasket;

    const style = document.createElement("style");
    style.textContent = `
        button {
            background: red;
            color: #fff;
        }
    `;
    
    shadowRoot.appendChild(btn);
    shadowRoot.appendChild(style);
  }

  #addToBasket() {
    // Send post request
  }
}
    
customElements.define(
    'checkout-add-to-basket',
    CheckoutAddToBasket
);
```

Although the page defines styles for a button and the custom element also integrates a style node
with its own generic button styling, there is no conflict. The button of the page has a black
background with a white text color and the custom element has a red background and also a white
text color.

The disadvantage of the shadow {{< abbr "DOM" "Document Object Model" >}} is that, unlike custom
elements, it is not yet part of the {{< abbr "HTML" "HyperText Markup Language" >}} standard and is
still in the [standardization process](https://github.com/whatwg/html/pull/5465)
(as of 2023-01-27). However, information about the shadow tree can already be found in
[DOM Spec 4.2.2](https://dom.spec.whatwg.org/#shadow-trees).

##### Routing & page transitions

For routing between micro front-ends we can easily use established solutions like classic links
(hard links) to load other resources, which in turn can also play out micro front-ends.

Another way are soft links, which are processed within the client by an application shell. This
technique is often used in the implementation of {{< abbr "SPAs" "Single-page application" >}}.

A common advantage of using classic links is that too tight coupling of components can be almost
eliminated by design, at the cost of a request against a server, of course. It is important that
the teams agree among themselves on a link structure that is always maintained and that changes to
this structure are communicated to all teams at an early stage.

Using an application shell like [single-SPA](https://single-spa.js.org/), in turn, leads to a
better {{< abbr "UX" "User Experience" >}} by using a performant client-internal routing. An
application shell is able to start and stop connected {{< abbr "SPAs" "Single-page application" >}}
and usually even lazy load them from the server when they are needed.

### Tips and tricks for using micro front-ends

#### Communication patterns

There are primarily three communication channels among the micro front-ends:
{{< abbr "URLs" "Uniform Resource Locator" >}}, attributes and events.

As mentioned before, {{< abbr "URLs" "Uniform Resource Locator" >}} are just static links to call
other resources, in a very classical way.

```html
<p>
    Take a look at our <a href="/suitcases">wide range of suitcases</a> and find your perfect
    travel companion for every situation.
</p>
```

Attributes, on the other hand, are the interface between the embedding page and the micro
front-end. Attributes can be used to share values known on the page, such as the
{{< abbr "SKU" "Stock keeping unit" >}}, with a micro front-end. They can be defined either by the
team of the page or by the team of the micro front-end.

```html
<h2>Design your personal suitcase, according to your preferences</h2>

<inpire-suitcase-designer sku="XYZ42USER"/>
```

Last but not least, we have the events. We can make use of events in two ways, either by
defining our own custom events or by using the Broadcast Channel
{{< abbr "API" "Application Programming Interface" >}}.

The custom event interface is captured in
[DOM Spec 2.4](https://dom.spec.whatwg.org/#interface-customevent) and comes with a wide browser
support.

Although the Broadcast Channel {{< abbr "API" "Application Programming Interface" >}} is part of
the {{< abbr "HTML" "HyperText Markup Language" >}} Living Standard, found in
[HTML Spec 9.5](https://html.spec.whatwg.org/multipage/web-messaging.html#broadcasting-to-other-browsing-contexts),
it is not yet fully supported by all browsers, but by the most important ones.

A micro front-end within the basket is interested in all `addedToFavorites` events in order to
display them to the user later or on revisit.

```js
obj.addEventListener(
    'addedToFavorites',
    (e) => this.remindUserOfArticle(e.sku)
);
```

Elsewhere, on the page, a custom event is triggered when the user marks an article as a favorite.

```js
obj.dispatchEvent(
    new CustomEvent(
        'addedToFavorites',
        { sku: article.sku }
    )
);
```

The example again using the Broadcast Channel
{{< abbr "API" "Application Programming Interface" >}}. The micro front-end that is interested in
the `addedToFavorites` messages sets up a broadcast listener.

```js
const bc = new BroadcastChannel('addedToFavorites');
bc.onmessage = (sku) => {
  this.remindUserOfArticle(sku);
};
```

And elsewhere on the site, an {{< abbr "SKU" "Stock keeping unit" >}} message is broadcast on the
`addedToFavorites` channel when the user marks an item as a favorite.

```js
const bc = new BroadcastChannel('addedToFavorites');
bc.postMessage(article.sku);
```

#### Communication smells

On the side of the communication antipattern, or -smells, we find above all too complex
communication dependencies, shared resources, as well as too large data objects.

From the moment when triggering an event triggers a chain of interactions between more than two
micro front-ends, something stinks. Hard-to-maintain and error-prone front-ends are created when a
communication between sender and receiver spans further communications.

One reason for such communications can be incorrectly cut micro front-ends. In other words, the
underlying bounded context is probably also cut incorrectly.

The next big problem that exists not only in the back-end but also in the front-end are shared
resources, knowledge, states, data and their stores. If we start sharing all these things, then we
encourage coupling between our modules. This leads to a huge degradation in maintainability.

For example, just because a user has provided an address for a service availability check, another
context, e.g., identifying potential customer leads, is not authorized to store the address of the
visitor.

Sharing such data creates conflicts that are often not apparent at first glance. In the case
mentioned, the {{< abbr "CRM" "Customer Relationship Management" >}} context builds a dependency on
the service availability context. What happens now when the service availability context suddenly
relies on a different data model and sets the primary attribute to automatically determined
coordinates, for example? As a result, the {{< abbr "CRM" "Customer Relationship Management" >}}
context must be adjusted due to an adjustment in the service availability context.

Actually, the disadvantages of data sharing should no longer need to be explained today, since it
is obvious not to build up dependencies on data from other contexts that are not within one's own
scope of action. 

Another common problem is sharing data models in the payload of my messages. By sharing data models
between modules, we end up creating coupling again. Everything we share will eventually be consumed
by other teams. Therefore, it is best to share only what is necessary, and in case of doubt, that
is only the {{< abbr "ID" "Identification; In the field of computer science, usually a sequential number, or a unique string of characters. Used to identify and reference an entity." >}}
or {{< abbr "IRI" "Internationalized Resource Identifier" >}}.

Using the {{< abbr "ID" "Identification; In the field of computer science, usually a sequential number, or a unique string of characters. Used to identify and reference an entity." >}}
or {{< abbr "IRI" "Internationalized Resource Identifier" >}}, other modules can in turn load the
data from a versioned {{< abbr "API" "Application Programming Interface" >}}. The form of the data
it receives back is known, unlike the payload of an event message.

#### Uniformed & shared design system

Now let's move on to a trade-off tip, a uniformed & shared design system. Micro front-ends,
especially when used with the shadow {{< abbr "DOM" "Document Object Model" >}}, offer a maximum
degree of flexibility. Each team can theoretically bring its own styles and its own
{{< abbr "JS" "JavaScript" >}} framework.

To counteract a style proliferation, all teams could agree on the introduction of a uniformed &
shared design system. In such a system, for example, it is specified how certain components look
and how they behave.

The system should be versioned & fully open source within the organization. Furthermore, no further
actions from other teams should be required to introduce new code and styles, this is important so
that teams are not blocked from developing new features.

For the provision of internal packages, {{< abbr "NPM" "package manager for the JavaScript programming language" >}} naturally lends itself.

#### Redundancy minimization

The last tip is aimed at minimizing redundancies. Imagine that the micro front-end application is
run by about 10 teams with different micro front-ends. In the worst case, three times React 18.0.0,
five times React 16.14.0, two times Vue 2, seven times Vue 3, and some different Angular versions are now loaded.

Here it is also worthwhile to take a look at small frameworks/tools, so that not everything always depends on the big ones. Small ones are for example:

- svelte
- hyperapp
- React
- lit-html
- stencil

If you can't avoid excluding large frameworks, then you should at least agree on shared libraries
in the same version to greatly reduce the initial load. A non-browser-native solution is
[systemjs](https://github.com/systemjs/systemjs). This can be used to manage and import
{{< abbr "JS" "JavaScript" >}} dependencies in a uniform way.

Another way is decentralized [module-federation](https://module-federation.github.io). One module
loads dependencies and other modules with the same dependency just link to the already loaded ones.
The biggest advantage: it's decentralized. There is no need to simulate a
{{< abbr "CDN" "Content Delivery Network" >}} for local testing, it just works local.

### Micro front-ends and native apps

Besides micro front-ends in web applications, there are of course also micro front-ends in native
(smartphone) applications. There are three core approaches to how these can be implemented.

1) Build a native app based on {{< abbr "APIs" "Application Programming Interface" >}} (monolith)

In native app monolith, a specialized team develops the app for the target
{{< abbr "OS" "Operating System" >}}. The team is in close, regular contact with the micro
front-end teams in order to map their requirements as well as possible in the app.

The team only needs to focus on its {{< abbr "APIs" "Application Programming Interface" >}} and its
own micro front-ends on the web and does not need native app developers. The disadvantages
are definitely the loss of development speed and the lack of freedom.

2) Build and integrate native app components

A bit more flexibility and freedom can be bought with the post-loading of native app components,
whereby the price is clearly the competence around native app development and the post-loading of
code.

The micro front-end team's tech stack is no longer limited to web and
{{< abbr "API" "Application Programming Interface" >}}, but has expanded to include technologies
from multiple target platforms.

Importantly, there still needs to be a team with primary responsibility for the target platform.
This team provides a wrapper/ shell in which the post-loaded micro front-end components are loaded
and executed.

3) Build a hybrid app

The simplest solution is certainly a hybrid app that relies on a native wrapper/ shell just like
the "native, integrated app" that provides a web view to load the micro front-ends.

This brings the significant advantage that front-ends do not have to be developed multiple times
from scratch, which drastically reduces the need for additional native app developers.

Of course, native options, tweaks, and styling are now missing. Apps not only look like responsive
web applications, they are.

## Tackling cross-cutting concerns within your software architecture

Cross-cutting concerns are the implementation of requirements that affect multiple systems in an
overall system. Good examples for cross-cutting concerns are:

- Logging
- Tracing
- and error handling

All these are common requirements for all systems, whether microservice, monolith, or anything in
between.

### How should we face cross-cutting concerns?

Fortunately, we have many ways to address cross-cutting concerns.

The ways that first come to mind here are particularly close to the code. Namely, the ubiquitous
design patterns of the [Gang of Four](https://en.wikipedia.org/wiki/Design_Patterns).

Of course, not all patterns can help us here. In particular, we should focus on the
[singleton](https://en.wikipedia.org/wiki/Singleton_pattern) and
[facade](https://en.wikipedia.org/wiki/Facade_pattern) patterns. Both patterns, in their own way,
offer a good way to deal with cross-cutting concerns with the respective capabilities of the
language in which they are used.

A little further away from the code, there is another pattern that is not from the
[Gang of Four](https://en.wikipedia.org/wiki/Design_Patterns), but from Chris Richardson. He is the
father of the software architectural
[API Gateway pattern](https://microservices.io/patterns/apigateway.html), which fits better
especially in the context of distributed microservice software architectures.

This pattern is particularly exciting in the course of the cross-cutting concerns, as various,
involved microservice {{< abbr "APIs" "Application Programming Interface" >}} are united behind one
{{< abbr "API" "Application Programming Interface" >}}. The
{{< abbr "API" "Application Programming Interface" >}} Gateway can then be used as a proxy for
specific services, or to split requests across multiple services. In other words, it is a good
lever for addressing cross-cutting concerns.

### Infrastructure

Since this article is all about microservices, we'll also stay with the
[API Gateway pattern](https://microservices.io/patterns/apigateway.html) and now take a swing at
the infrastructure of microservice software architectures.

Microservices are usually operated in the form of containers that must be orchestrated for smooth
operation. By orchestration, I mean not just getting microservices up and running (provisioning
and deployment), but also:

- Resource management – e.g. {{< abbr "CPU" "Central Processing Unit" >}}, memory, storage...
- Health monitoring – can I forward requests to a healthy application?
- Scaling – e.g. 1, 2, or auto-scaling service replicas
- Provision of mappings for the interconnection of networks
- Load balancing – forwarding of requests to different services for load balancing and response
time optimization

The orchestration of microservices and the management of all these tasks is best handled by
software that has been specially developed and designed for this purpose. One software solution
that is particularly easy to stumble upon is certainly [Kubernetes](https://kubernetes.io/).

At this point I would also like to recommend the documentary about Kubernetes by **Honeypot**.

{{< _figureCupper
img="https://images.ctfassets.net/cjwb7umaxoxv/7ug7jhk9xgKYxUIA75lbUT/e4ae78fcf0d792dc824d2e35797c25cf/MOSHED-2022-1-21-17-48-22.jpg?w=600&fl=progressive&q=85"
imgLink="https://cult.honeypot.io/originals/kubernetes-the-documentary-part-1"
alt="Preview image of Honeypot's documentary \"Kubernetes: The Documentary [PART 1]\""
caption="Honeypot's documentary [Kubernetes: The Documentary [PART 1]](https://cult.honeypot.io/originals/kubernetes-the-documentary-part-1)." >}}

In addition to Kubernetes, there is of course a whole range of other solutions for orchestrating
microservices:

- [AWS Fargate](https://aws.amazon.com/fargate/)
- [AWS Elastic Container Service/ ECS](https://aws.amazon.com/ecs/)
- [Azure Container Instances](https://azure.microsoft.com/en-us/products/container-instances)
- [Google Cloud Run](https://cloud.google.com/run)
- [Red Hat OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift/container-platform)
- [Rancher](https://www.rancher.com/products/rancher) ({{< abbr "K8S" "Kubernetes" >}}-as-a-Service)
- [Docker Swarm](https://docs.docker.com/engine/swarm/)
- [Nomad by HashiCorp](https://www.nomadproject.io/)
- [Apache Mesos](https://mesos.apache.org/)

### Kubernetes API gateway via ingress controllers

I have already mentioned how an {{< abbr "API" "Application Programming Interface" >}} gateway
works in theory. However, to illustrate this, here is a flowchart:

{{<
    mermaid
    caption="mermaid flowchart diagram of how an API gateway works in theory."
    responsive="true"
>}}
flowchart LR
    subgraph clients
        direction TB
        c1[client 1]
        c2[client 2]
        c3[client 3]
    end

    subgraph some cluster
        ag[API gateway]

        subgraph microservices
            direction TB
            ms1[microservice 1]
            ms2[microservice 2]
            ms3[microservice 3]
        end
    end

    %% The clients send requests against the API gateway

    c1 --> ag
    c2 --> ag
    c3 --> ag

    %% The requests are forwarded to the microservices
    %% based on the set of routing rules

    ag --> ms1
    ag --> ms2
    ag --> ms3
{{< /mermaid >}}

Broken down, an {{< abbr "API" "Application Programming Interface" >}} gateway takes care of the
following three tasks:

1. Listen for client requests from outside a cluster
2. Evaluating a set of provided routing rules against incoming requests
3. Forwarding the requests to one or multiple microservices

Now let's look at this again with an ingress controller in a Kubernetes cluster.

{{<
    mermaid
    caption="mermaid flowchart diagram of how a Kubernetes ingress controller works in theory."
    responsive="true"
>}}
flowchart LR
    subgraph clients
        direction TB
        c1[client 1]
        c2[client 2]
        c3[client 3]
    end

    subgraph kubernetes cluster
        ag["ingress controller (API gateway)"]

        subgraph microservices
            direction TB
            ms1[microservice 1]
            ms2[microservice 2]
            ms3[microservice 3]

            subgraph microservice 1
                direction TB
                ms1p1[pod 1]
            end

            subgraph microservice 2
                direction TB
                ms2p1[pod 1]
                ms2p2[pod 2]
                ms2p3[pod 3]
            end

            subgraph microservice 3
                direction TB
                ms3p1[pod 1]
                ms3p2[pod 2]
            end
        end
    end

    %% The clients send requests against the API gateway

    c1 --> ag
    c2 --> ag
    c3 --> ag

    %% The requests are forwarded to the microservices
    %% based on the set of routing rules

    ag --> ms1
    ag --> ms2
    ag --> ms3

    %% The requests are forwarded to one or multiple pods of
    %% a microservice
    ms1 --> ms1p1
    ms2 --> ms2p1
    ms2 --> ms2p2
    ms2 --> ms2p3
    ms3 --> ms3p1
    ms3 --> ms3p2
{{< /mermaid >}}

Basically, the same happens here as with the previous
{{< abbr "API" "Application Programming Interface" >}} gateway, except that in Kubernetes the
request is passed on later to a pod of a microservice.

A pod is a group of containers that only together form a functioning unit. This makes a pod the
smallest possible unit that can be deployed in Kubernetes.

Examples of this could be the joint deployment of a web service (container 1) together with a
volume, which is regularly filled by a repository syncing service (container 2).

Without much effort, Kubernetes supports three ingress controllers out of the box:

- [nginx](https://git.k8s.io/ingress-nginx/README.md#readme)
- [GCE](https://git.k8s.io/ingress-gce/README.md#readme)
- [AWS](https://github.com/kubernetes-sigs/aws-load-balancer-controller#readme)

A good example of an {{< abbr "API" "Application Programming Interface" >}} gateway can be found in
nginx open source GitHub account. Here, a café application that offers tea (service 2) in addition
to coffee (service 1) is united behind an {{< abbr "API" "Application Programming Interface" >}}
gateway.

{{< _figureCupper
img="https://opengraph.githubassets.com/0a55e423571c2cc1f9bc1730764828ebf10bff9ed3d14814f228a8c86ed821e9/nginxinc/nginx-kubernetes-gateway"
imgLink="https://github.com/nginxinc/nginx-kubernetes-gateway/tree/main/examples/cafe-example"
alt="nginx-kubernetes-gateway/examples/cafe-example at main · nginxinc/nginx-kubernetes-gateway"
caption="nginx-kubernetes-gateway/examples/cafe-example at main · [nginxinc/nginx-kubernetes-gateway](https://github.com/nginxinc/nginx-kubernetes-gateway/tree/main/examples/cafe-example)." >}}

### ingress controllers are based on service proxies

In order for an ingress controller to perform its tasks in the cluster,
it is based on service proxies. Kubernetes
[service proxies](https://kubernetes.io/docs/reference/networking/virtual-ips/)
are network components that interact between clients and services.

Their responsibilities include, but are not limited to, the following
actions:

- Adding and removing {{< abbr "HTTP" "Hypertext Transfer Protocol" >}} headers
- Terminating and offloading {{< abbr "SSL" "Secure Sockets Layer" >}} requests
- {{< abbr "URL" "Uniform Resource Locator" >}} filtering and content switching
- Caching content
- Supporting blue-green deployments and canary testing

The most common service proxies are:

- [Envoy](https://www.envoyproxy.io/)
- [OpenResty](https://openresty.org/)
- [HAProxy](https://www.haproxy.org/)

### API gateway & cross-cutting concern contexts

If we look at the {{< abbr "API" "Application Programming Interface" >}} gateway again after the
last sections, we quickly see that it has a surprising number of levers to counter cross-cutting
concerns. The {{< abbr "API" "Application Programming Interface" >}} gateway provides a set of
contexts for requests that pass through it, which we can use to find and implement centralized
solutions for dealing with cross-cutting concerns.

The four primary contexts are:

1. The **consumer**, which is basically the client, sending the request to our backend.
2. The **route**, which is the requested information of our consumer.
3. The **service**, which is allocated to the requested route.
4. And **load balancing**, which some {{< abbr "API" "Application Programming Interface" >}}
gateways also provide.

Fortunately, {{< abbr "API" "Application Programming Interface" >}} gateways are usually well
extensible by plugins, policies and add-ons, which brings us even closer to the conclusion that
they are a good tool for addressing cross-cutting concerns in the contexts just identified.

Available extensions that address a cross-cutting concern are rare and sometimes vendors that
address them also offer {{< abbr "API" "Application Programming Interface" >}} gateway extensions,
but usually we will write our own extensions to counter these. The reason for this is that
{{< abbr "API" "Application Programming Interface" >}} gateways are kept very generic because they
are used in all kinds of applications. The applications in the cluster, on the other hand, are
specialized software solutions that address one domain per gateway, and there are rarely appropriate
extensions.

#### Writing your own API gateway plugins

The development of custom plugins is {{< abbr "API" "Application Programming Interface" >}} gateway
specific. The providers of the {{< abbr "API" "Application Programming Interface" >}} gateways
usually provide a guide or sample plugins that can be used as a starting point for your own
development.

You can either install your plugins as Helm charts via your Helm repository in your 
{{< abbr "K8S" "Kubernetes" >}} cluster, or store them in your kustomize configuration. 

Starting points for the most common {{< abbr "API" "Application Programming Interface" >}} gateways:

**nginx**

- [nginx wiki: extending](https://www.nginx.com/resources/wiki/extending/)
- [Evan Miller's guide to nginx module development](https://www.evanmiller.org/nginx-modules-guide.html)
- [agentzh's nginx tutorials](https://openresty.org/download/agentzh-nginx-tutorials-en.html)

**OpenResty**

- [Write your own Lua modules for OpenResty applications](https://blog.openresty.com/en/or-lua-module/)

**HAProxy**

- [5 ways to extend HAProxy with Lua](https://www.haproxy.com/blog/5-ways-to-extend-haproxy-with-lua/)

**Traefik**

- [Developing Traefik plugins](https://plugins.traefik.io/create)
- [Traefik plugin demo on GitHub](https://github.com/traefik/plugindemo)

**Envoy**

- [Extending Envoy for custom use cases](https://www.envoyproxy.io/docs/envoy/latest/extending/extending)

### Cross-cutting concerns in detail

Now let's assign some cross-cutting concerns to the tasks of the
{{< abbr "API" "Application Programming Interface" >}} Gateway. Thus, we see that the
{{< abbr "API" "Application Programming Interface" >}} Gateway is well-suited tool to address them.

**Traffic management**

From time to time it may happen that several services in the cluster, or specific resources of
these services, can only be accessed by a restricted user group. At this point
**{{< abbr "ACLs" "Access Control List" >}}** are useful, which we can statically store in the
ingress controller configuration.

Another good example of traffic management is limiting the rate at which users can access a
resource. There are many factors that can affect the rate, such as security, service or product
availability, as well as contractual access rates for tenants. These special requirements can be
well implemented in a custom plugin.

Below is a {{< abbr "K8S" "Kubernetes" >}} example for an
{{< abbr "ACL" "Access Control List" >}}, as well as a rate limiting for two different paths of a
coffee shop application.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: coffee-shop
  namespace: coffee-shop
spec:
  rules:
  - host: foobars-coffee-shop.com
    http:
      paths:
      - path: /special-offer-orders
        pathType: Prefix
        backend:
          service:
            name: order-service
            port:
              name: http
        tls:
          - hosts:
            - foobars-coffee-shop.com
        annotations:
          nginx.ingress.kubernetes.io/auth-type: basic
          nginx.ingress.kubernetes.io/auth-secret: foos-sealed-secret,bars-sealed-secret
          nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
      - path: /special-offer
        pathType: Prefix
        backend:
          service:
            name: offer-service
            port:
              name: http
        tls:
          - hosts:
            - foobars-coffee-shop.com
        annotations:
          nginx.ingress.kubernetes.io/limit-rps: "10"
          nginx.ingress.kubernetes.io/limit-rps-burst: "20"

```

**Security**

Another topic within cross-cutting concerns that can be addressed well with an
{{< abbr "API" "Application Programming Interface" >}} gateway is centralized authentication and
authorization.

In the following {{< abbr "K8S" "Kubernetes" >}} example, an oauth-2/ OpenID Connect authentication
and authorization is provided by [Keycloak](https://www.keycloak.org/), an open source identity and
access management under stewardship of [Red Hat](https://www.redhat.com/en), in front of the
{{< abbr "BI" "Business Intelligence" >}} and {{< abbr "ERP" "Enterprise resource planning" >}}
service.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: coffee-shop
  namespace: coffee-shop
  annotations:
    nginx.ingress.kubernetes.io/auth-url: "https://keycloak.foobars-coffee-shop.com/auth/realms/employee-realm/protocol/openid-connect/auth?response_type=code&client_id=nginx&redirect_uri=https://foobars-coffee-shop.com/oauth2/callback"
    nginx.ingress.kubernetes.io/auth-signin: "https://keycloak.foobars-coffee-shop.com/auth/realms/employee-realm/protocol/openid-connect/auth?response_type=code&client_id=nginx&redirect_uri=https://foobars-coffee-shop.com/oauth2/callback"
    nginx.ingress.kubernetes.io/auth-method: POST
    nginx.ingress.kubernetes.io/auth-response-headers: X-Userinfo
spec:
  rules:
  - host: foobars-coffee-shop.com
    http:
      paths:
      - path: /business-intelligence
        pathType: Prefix
        backend:
          service:
            name: business-intelligence
            port:
              name: http
        annotations:
          nginx.ingress.kubernetes.io/auth-url: "https://keycloak.foobars-coffee-shop.com/auth/realms/employee-realm/protocol/openid-connect/auth?response_type=code&client_id=nginx&redirect_uri=https://foobars-coffee-shop.com/oauth2/callback/bi"
          nginx.ingress.kubernetes.io/auth-signin: "https://keycloak.foobars-coffee-shop.com/auth/realms/employee-realm/protocol/openid-connect/auth?response_type=code&client_id=nginx&redirect_uri=https://foobars-coffee-shop.com/oauth2/callback/bi"
      - path: /some-erp
        pathType: Prefix
        backend:
          service:
            name: some-erp
            port:
              name: http
        annotations:
          nginx.ingress.kubernetes.io/auth-url: "https://keycloak.foobars-coffee-shop.com/auth/realms/employee-realm/protocol/openid-connect/auth?response_type=code&client_id=nginx&redirect_uri=https://foobars-coffee-shop.com/oauth2/callback/erp"
          nginx.ingress.kubernetes.io/auth-signin: "https://keycloak.foobars-coffee-shop.com/auth/realms/employee-realm/protocol/openid-connect/auth?response_type=code&client_id=nginx&redirect_uri=https://foobars-coffee-shop.com/oauth2/callback/erp"

```

**Resilience**

To harden and secure a service (mesh) architecture, we can integrate a circuit breaker into the
{{< abbr "API" "Application Programming Interface" >}} gateway. Circuit breakers provide more
resilient services by monitoring network traffic and marking individual services as unhealthy when
anomalies are detected. This redirects incoming requests to fallback services.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: coffee-shop
  namespace: coffee-shop
  annotations:
    nginx.ingress.kubernetes.io/enable-circuit-breaker: "true"
spec:
  rules:
  - host: foobars-coffee-shop.com
    http:
      paths:
      - path: /orders
        pathType: Prefix
        backend:
          service:
            name: order-service
            port:
              name: http
      - path: /special-offer
        pathType: Prefix
        backend:
          service:
            name: offer-service
            port:
              name: http
```

Another example is setting a central timeout for multiple services. However, keep in mind that
centralized timeout management is not the best solution because services may have different
response times.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: coffee-shop
  namespace: coffee-shop
  annotations:
    nginx.ingress.kubernetes.io/proxy-timeout: "60s"
spec:
  rules:
  - host: foobars-coffee-shop.com
    http:
      paths:
      - path: /most-popular-roasts
        pathType: Prefix
        backend:
          service:
            name: analysis-service
            port:
              name: http
      - path: /most-recent-orders
        pathType: Prefix
        backend:
          service:
            name: order-service
            port:
              name: http
```

### How to govern cross-cutting concerns?

Now that we have gone through how to address cross-cutting concerns with
{{< abbr "API" "Application Programming Interface" >}} gateways and their plugins and policies, we
need to make sure that no installation & configuration wild west breaks out among developers.

We need governance as a tool to manage the use of cross-cutting concern plugins and policies in a
healthy way.

One possible way to provide governance are so called OpenAPI extensions, or more precisely
X-Objects. This allows teams to satisfy their own needs as well as those of vendors in a governed
environment.

OpenAPI extensions now allow developers to tap cross-cutting information or trigger actions at
relevant points within the {{< abbr "API" "Application Programming Interface" >}} gateway, or
ingress controller.

Let's have a look at the setup of Amazon's Lambda OpenAPI extension within our coffee shop's
OpenAPI specification and its use in the Ingress controller.

```yaml
openapi: "3.0.0"
info:
  title: "Foobar's Coffee Shop API"
  version: "1.0.0"
paths:
  /newsletter:
    post:
      summary: "Subscribe to Foobar's coffee shop newsletter"
      operationId: "subscribeToNewsletter"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                  format: email
              required:
                - email
      responses:
        '200':
          description: "Successfully subscribed to newsletter"
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
                    example: "Successfully subscribed to newsletter"
        '400':
          description: "Bad Request"
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
                    example: "Invalid email address"
      x-amazon-apigateway-integration:
        type: "aws_proxy"
        uri: "arn:aws:lambda:eu-central-1:123456789012:function:subscribeToNewsletter"
        httpMethod: "POST"
        requestTemplates:
          application/json: |
            {
              "email": "$input.json('$.email')"
            }
        responses:
          default:
            statusCode: "200"
            responseTemplates:
              application/json: |
                {
                  "message": "Successfully subscribed to newsletter"
                }
            selectionPattern: ".*\"statusCode\":200.*"
```

Each major vendor provides their own OpenAPI extensions, here are a few examples for AWS, Azure and
Google:

**AWS**

- `x-amazon-apigateway-auth` configure authorization and authentication
- `x-amazon-apigateway-cors` configure
{{< abbr "CORS" "Cross-Origin Resource Sharing" >}} headers
- `x-amazon-apigateway-integration` configure an integration

**Azure**

- `x-ms-rest` adds some metadata to the requests
- `x-ms-client-model` adds a client model to the
{{< abbr "API" "Application Programming Interface" >}}
- `x-ms-long-running-operation` configure long running operations for the
{{< abbr "API" "Application Programming Interface" >}}

**Google**

- `x-google-api-client` adds some metadata to the
{{< abbr "API" "Application Programming Interface" >}}
- `x-google-api-client-header` adds headers to the Google
{{< abbr "API" "Application Programming Interface" >}}
- `x-google-api-client-method` adds a method Google's 
{{< abbr "API" "Application Programming Interface" >}}

Using these extensions is a first step towards an
{{< abbr "API" "Application Programming Interface" >}} Definition.

### Service mesh

Now that we have dealt with the {{< abbr "API" "Application Programming Interface" >}} Gateway and
the Ingress controller with their incoming and outgoing
packets, we will next take a look at the so-called service meshes.

A service mesh is responsible for the cluster internal network traffic between our services.
Each service within our mesh has its own sidecar proxy. These are necessary for the service mesh
to provide e.g.

- **Load balancing** due to routing tables to other sidecars 
- **Health information** to other sidecars
- **Connection polling and keep alive** to ensure faster connections to other services

### The difference to an API Gateway/ Ingress Controller

An {{< abbr "API" "Application Programming Interface" >}} Gateway is in contrast to a service mesh,
always a product, with or without monetization.

Both are communicating on the level 7 of the {{< abbr "OSI" "Open Systems Interconnection" >}}
model[^osi_model] but the sidecar proxy is also working a lot on the layer 4.

With the {{< abbr "API" "Application Programming Interface" >}} Gateway developers can manage the
complete life cycle of the containing {{< abbr "APIs" "Application Programming Interface" >}}. On
the other hand, the sidecar is used to handle all the cluster internal service-to-service
communication. So it never leaves the cluster.

### Combining an API Gateway/ Ingress with a Service mesh

If we now bring both concepts together, we have a solid, well-configurable
{{< abbr "API" "Application Programming Interface" >}} boundary of our clusters to the outside
world, as well as a fine-grained configuration for inter-service communication.

{{< 
    mermaid 
    caption="mermaid flowchart/ architecture diagram of a API Gateway <> Service mesh architecture"
    responsive="true"
>}}
graph TB
    %% Layer one
    subgraph ag[API Gateway]
        direction TB

        as1[API service]
        as2[API service]
        as3[API service]
    end
    
    %% Layer two
    subgraph cim[Composite/ Integration Microservices]
        direction TB
        
        subgraph cim1[ ]
            direction LR

            bl1[Business logic]:::red
            nf1[Network functions]:::green
            sm1[Service mesh]
        end

        subgraph cim2[ ]
            direction LR

            bl2[Business logic]:::red
            nf2[Network functions]:::green
            sm2[Service mesh]
        end

        subgraph cim3[ ]
            direction LR

            bl3[Business logic]:::red
            nf3[Network functions]:::green
            sm3[Service mesh]
        end
    end

    %% Layer three
    subgraph cam[Core/ Atomic Microservices]
        direction TB
        
        subgraph cam1[ ]
            direction LR

            bl4[Business logic]:::red
            nf4[Network functions]:::green
            sm4[Service mesh]
        end

        subgraph cam2[ ]
            direction LR

            bl5[Business logic]:::red
            nf5[Network functions]:::green
            sm5[Service mesh]
        end

        subgraph cam3[ ]
            direction LR

            bl6[Business logic]:::red
            nf6[Network functions]:::green
            sm6[Service mesh]
        end

        subgraph cam4[ ]
            direction LR

            bl7[Business logic]:::red
            nf7[Network functions]:::green
            sm7[Service mesh]
        end

        subgraph cam5[ ]
            direction LR

            bl8[Business logic]:::red
            nf8[Network functions]:::green
            sm8[Service mesh]
        end
    end

    ag-.->cim1
    ag-.->cim2
    ag-.->cim3

    cim1-.->cam1
    cim1-.->cam3
    cim2-.->cam2
    cim2-.->cam4
    cim3-.->cam3
    cim3-.->cam5

    classDef red stroke-width:2px,fill:red,color:#fff;
    classDef green stroke-width:2px,fill:green,color:#fff;
{{< /mermaid >}}

## Transactions within and across microservices - Sounds like fun!

Handling a transaction from the frontend, over its request against an
{{< abbr "API" "Application Programming Interface" >}} that may effect several bounded contexts
and some database interactions is easy... within a monolith. Everything is in its designated
flow. We are in control over every peace of code, just as we are of all that follows.

A little more uncomfortable is the thought of applying this transaction to a ramified network of
microservices and their databases. All these systems may have different owners and could even be
implemented in another technology then the previous service. It is really not trivial to ensure a
seamless transaction within this setting.

At this point, we should always ask ourself if we really need a single transaction. Do we want to
provide a multi-service commit & rollback mechanism? Or isn't there a domain-specific way to handle
it without a single transaction? 

Take a moment to look around you. Think about the way things work in the real life. Are theses
things build upon a single transaction? No, the real world isn't transactional.

### Real world examples for a non transactional world

Let's look at two examples for non transactional processes of the real world.

**Opening a shared bank account**:

Have you ever tried opening a shared bank account on the website of your bank of choice? You start
by filling in all required information step by step. In the last step you have to fill in the
date of birth of your absent partner. Every one knows that's impossible. The process has failed
because it is not aligned with the real world.

If, on the other hand, you had gone directly to the bank branch of your choice, then the opening
process would most likely have been different. You would have filled in all the fields until you
came across your partner's date of birth, but that would not have been a problem. The nice bank
consultant would have opened your account with a limited functionality until you hand the date in
later.

**Transferring money from a bank account to another**

Even the process of transferring money from one bank account to another one is not handled within
a single transaction. There is not a single chain of events that reduce your account balance and
increases the other one.

This process is handled within multiple small transactions. It doesn't matter that the money is
transferred instantaneously, but it will be eventually. It is so-called **eventually consistent**.

Examples for the small transactions are:
- The creation of transfer order
- The creation of the transfer message to the other bank
- The reduction of the account balance

By simply getting used to these transactional processes over time, it is often already a matter of
course that we continue to implement them transactionally. With a little effort there is always
another, more realistic way to implement these processes. And the non transactional way if often
closer to the real worlds domain then the strict, transactional one.

### Transaction strategies within an e-commerce application build upon microservices

Next, lets look at three basic strategies to handle transactions within our e-commerce application.
The examples will be rough and incomplete, but they'll show the idea behind each strategy.

The examples {{< abbr "APIs" "Application Programming Interface" >}} are based on the
{{< abbr "CQRS" "Command-Query-Responsibility-Segregation" >}}[^cqrs] pattern.

#### The optimist: or "who needs transactions?"

The most optimistic strategy ignores transactions and just uses a chain of small command and query
operations.

1. Our customer sends a checkout command to our order service
2. The order service returns an ID (e.g. transaction or request ID) to the customer
3. The order service sends a decrease stock command for a given article number to the
stock service

#### The fortune-teller: it will work out somehow 

Within this example, the order service hold at least a last known stock value for each item
available. The example is not fully transactional, but its close to.

1. Our customer sends a checkout command to our order service
2. The order service checks its last known stock value for the order and...
    1. Rejects the order, if the given stock is to low, or..
    2. Accepts the order, if there are enough articles in the known stock
3. In case of an accepted order, the order service sends a decrease stock command for a given
article number to the stock service
4. The inventory service send a stock decremented event for the given article number, so that all
event subscribers can update their known stock

#### The safeguard: I better ask first

Even this last strategy is not fully transactional, but its closer then the other strategies.

1. The user sends a checkout command to the order service
2. The order service queries the inventory service for the current stock by the given article number
    1. Whether or not this query is sent may depend on a number of factors, or may simply be
    performed each time
    2. One factor may be that the last known value is so large, e.g., over 100, that it is unlikely
    that anything will go wrong
3. The order service checks its updated last known stock value for the order and...
    1. Rejects the order, if the given stock is to low, or..
    2. Accepts the order, if there are enough articles in the known stock
4. In case of an accepted order, the order service sends a decrease stock command for a given
article number to the stock service
5. The inventory service send a stock decremented event for the given article number, so that all
event subscribers can update their known stock

#### The risk of a failing order

Each strategy decreases the chance of a failed order, with the first strategy having the highest
chance of failure and the last strategy having the lowest. However, all strategies are subject to
failure. There is no cross-database transaction that allows us to simply roll back.

On the other hand, the time taken to achieve eventual consistency within each sub-transaction is
reduced. Each individual service reaches a consistent state in the shortest possible time.

#### Dealing realistically with failed orders

And if the order cannot be completed successfully in the end, for example due to an over-order,
there are still other ways of getting out of the situation well or even better than if the order had
been successful.

This "realistic" way of dealing with mistakes is simply called compensation. Compensation takes us
out of the transactional world and into the real world. At the end of the day, customers will
remember well (or hardly at all) the online shop from which they ordered and simply received their
goods; the majority of online shops can deliver this. The customer will remember the online shop
(bank, optician, craftsman... or whatever) that acted in an exemplary manner when problems arose and
helped me as a customer with my problem in a professional manner.

#### Compensation or "the plan B": there is always an alternative

We can see the value of compensation in the over-order example. Our online store had 50 items left
in stock, and the ordering service was aware of this. However, the service did not know that these
50 items had already been booked due to a repeat telephone order. So it accepted the next order for
one item without checking the stock again, because it had not yet reached a risky stock level for
the service. Now, with 51 items ordered and a stock level of 50, we have the supposed problem.

To find compensation, we need to consider whether the current inventory is actually relevant to a 
solution. A way of more or less automation is much more based on whether I can deliver on time, not
whether I have enough inventory.

Another, more human and probably more professional compensation is honesty in the face of a
mistake. Just admit to your customer that not everything went smoothly with their order. That can
happen - online, just as well as on-site in the store!

Honest communication and offering a variety of compensation options, such as an alternative item, a
gift certificate, or (and) a refund of the purchase price, will most likely result in an even
happier customer who is also likely to become a repeat buyer. Customers notice when they are treated
with honesty, and these (unfortunately) rare experiences are remembered positively.

#### There is no "plan B", we need a transaction

It happens that compensation is excluded for a variety of reasons. This may be due to the nature of
the domain, e.g. if it is a matter of life and death, or simply because management does not want to
compensate for tactical reasons, up to a wrongly cut microservices architecture where a rewrite is
not done for cost reasons.

##### The most common scenario

Now let's look at one of the most common scenarios, an entity-driven microservices architecture that
is "perfectly" cut at service boundaries.

Typically, the problems with implementing a microservice architecture stem from our entity-driven
nature. We obsessively try to declare every component of a domain down to the smallest detail. Our
dusty toolbox of classes, inheritance, and {{< abbr "UML" "Unified Modeling Language" >}} becomes
the anchor that keeps us ironclad in the mindset of monolithic structures. 

The nature of entity-based services is that they are at the center of inter-service transactions.
Many requests involve multiple entities, leading to chaotic situations where non-domain-related
commands and events must be fired to compensate multiple services and eventually bring all systems
back to a consistent state.

In software engineering, this is called cohesion and coupling. What we want to achieve with a
bounded context-centric approach is high cohesion, i.e. the complete encapsulation of domain
processes. High cohesion results in (almost) transaction-free software architectures between 
services. Exactly the opposite is achieved with entity-centric software architectures, i.e. high
coupling.

The problems of high coupling are well known in the area of monolithic architectures, not for
nothing the
{{< abbr "S.O.L.I.D." "Single responsibility principle, open-closed principle, Liskov substitution principle, interface segregation principle, dependency inversion principle" >}}[^solid]
principles have evolved here over the past decades of
{{< abbr "OOP" "Object-oriented programming" >}}. Each principle has a positive effect by either
increasing cohesion, (and) or decreasing coupling so that classes are no longer strongly coupled to
other classes.

##### Example for a microservice transaction and its compensation

The following widely used example of handling transactions across multiple microservices is taken
from the book Microservices Patterns[^microservices-patterns] by Chris Richardson.

The example includes an ordering service that has sovereignty over all ordering processes, as well
as a customer service that manages customer data. For all orders there is a rule that must be
realized as a transaction. The sum of all open amounts of all orders of a customer must be less
than or equal to the customer's credit limit.

In the following example, the transaction is implemented using a SAGA pattern[^saga-pattern]. For
more information on sagas, see the paper[^sagas-paper] by Hector Garcia-Molina and Kenneth Salem.

###### The happy path

1. The order is created within a transaction with the status "pending"
2. The order service sends a message to the customer service to trigger the reservation
3. The customer service reserves a credit
4. The customer service sends a message to the order service to trigger the change of status
5. The order service changes the status from "pending" to "open"
(Eventual Consistency[^eventual-consistency])

###### Failed to approve the order in the last step

1. The order is created within a transaction with the status "pending"
2. The order service sends a message to the customer service to trigger the reservation
3. The customer service reserves a credit
4. The customer service sends a message to the order service to trigger the approve of the order
5. The approve order command failed within the order service

Now compensation must be made:

6. The order service sends a compensation message to the customer service to trigger the release of
the credit
7. The customer service releases the credit (Eventual Consistency[^eventual-consistency])
8. The customer service sends a compensation message to the order service to trigger the rejection
of the order
9. The order service changes the status from "pending" to "rejected"
(Eventual Consistency[^eventual-consistency])

##### Ways to control sagas 

The implementation and control of sagas can be done in two ways: choreography and orchestration.

###### Saga choreography

In choreography, the flow of the saga is implicitly sequential within a distributed event flow. Each
service involved encapsulates the knowledge of the next steps.

This has two clear advantages: loose coupling and ease of implementation. The services do not know
each other, but each service knows which events it is interested in and which events it must send in
response. In effect, this is pseudo-loose coupling. But a pseudo-loose coupling that is easy to
implement.

Of course, as is often the case, there are clear disadvantages to a choreographed saga. The
pseudo-loose coupling often leads to circular dependencies between services. Especially the
interaction between events and compensation can cause problems if there is no clear responsibility
for the saga. In addition, the increasing complexity that arises when we distribute the business
logic over the course of a saga to a number of services should not be ignored. The latter leads to
the most annoying drawback, a change in the business logic. If there is a change in the saga flow
despite the domain, then each service involved must be adjusted to ensure a correct saga flow.

###### Saga orchestration

In contrast to the choreographed saga, in the orchestrated saga we find an explicitly sequential
flow of events. Explicit because each service that initiates a saga flow acts as its orchestrator.

The services involved by the orchestrator have no knowledge of the event flow. They act as "dumb"
segments in a chain of actions driven by a single service that also has full domain responsibility
for the saga flow.

The advantage of orchestration is that it makes the saga easier to understand and provides a
unidimensional direction in which the steps of the saga are executed. A simple look at the
orchestrator is enough to understand which actors and events are involved and when they are involved
in the flow. The unidimensional direction also prevents circular dependencies between our actors.

What we should also not overlook is the separation of concerns that we get from orchestration. Each
component, each link in our chain, has its role - one performs an action, the other orchestrates,
the next compensates.

The disadvantage is that you quickly run into the "smart orchestrator & dump service" anti-pattern.
At this point, too much business logic is tied to an orchestrator, which quickly creates a god class
that also breaks the separation of concerns if you are not careful with refactoring.

Finally, note that an orchestrator should not be implemented from scratch. There are reliable,
well-tested solutions available that can be quickly integrated as frameworks, bundles, or plugins,
and can usually be relied upon.

## Sources 
### My conference notes

This article is based on as detailed notes and thoughts as possible that I took during the
conference. If it helps you, you can find them in my smart notes on Github:

- [mastering_microservices_2022.md](https://github.com/lrotermund/zettelkasten/blob/master/notes/%7Dc_mastering_microservices_2022.md)

Please consider the article under this criterion as well. I am grateful for any pointers to errors
or incompleteness. Feel free to contact me on
[LinkedIn](https://www.linkedin.com/in/lukas-rotermund),
[Mastodon](https://social.dev-wiki.de/@lukasrotermund), or simply by
[email](mailto:lukas.rotermund@live.de).

### Heise's "Mastering Microservices" – About the conference 

[Heise's Mastering Microservices](https://konferenzen.heise.de/mastering-microservices/) is a great
German-speaking conference for aspiring architects and anyone who wants to look beyond the horizon
of monolithic software architecture. Speakers include several well-known software architects and
companies who share their knowledge over the course of a full day. Highly recommended.

## My conclusions

1. Trying to summarize a conference in a blog article was my worst idea in 2022 (2023...).
2. Heise's "Mastering Microservices" is worth a (virtual) visit, I had the chance to listen to very
talented software architects and developers and take away a lot for me personally as well as for my
company.
3. Not everything you learn at the conference can be applied directly to existing projects, but most
of the topics were explained so well and hands-on that they can be implemented quickly or taken into
account when planning future systems or updates.
4. A few topics that may not seem relevant at first glance can quickly turn out to be quite relevant
after all. It is worth going through the conference documents and recordings again afterwards and
consuming them one more time.

## Disclaimer

{{< disclaimer >}}

[^osi_model]: OSI model: The Open Systems Interconnection (OSI) model is a
    layered model that seperates seven layers of network communication.

    | Layer | Name               |
    | ----- | ------------------ |
    | 7     | Application layer  |
    | 6     | Presentation Layer |
    | 5     | Session layer      |
    | 4     | Transport layer    |
    | 3     | Network layer      |
    | 2     | Data link layer    |
    | 1     | Physical layer     |
[^cqrs]: CQRS: The Command-Query-Responsibility-Segregation is a pattern in software development for
    describing the separation of a program's interface into a query and a command interface. Both
    handling the internal code separately and writing (command) and reading (query) also from
    different databases, each specialised in writing or reading.
[^solid]: SOLID principles: The SOLID principles are a set of five design guidelines in
    object-oriented programming that, when followed properly, can lead to more understandable,
    flexible, and maintainable code by promoting high cohesion within classes and low coupling
    between classes.
[^bluebook]: Domain Driven Design: Eric Evans (2003) Domain-Driven Design - Tackling Complexity in
    the Heart of Software. Pearson International
[^microservices-patterns]: Microservices Patterns: Chris Richardson (2018) Microservices Patterns -
    With examples in Java (English Edition). Manning
[^saga-pattern]: Saga pattern: The saga pattern is a design pattern in microservices architecture
    used to manage long-running business transactions by handling distributed transactions and
    compensating for actions that have been committed, ensuring data consistency across services.
[^sagas-paper]: Sagas paper: [Hector Garcia-Molina and Kenneth Salem (1987) SAGAS. Department of
    Computer Science, Princeton University](https://www.cs.cornell.edu/andru/cs711/2002fa/reading/sagas.pdf)
[^eventual-consistency]: Eventual Consistency: Eventual consistency is a model used in distributed
    computing, where systems eventually achieve a state of consistency among all nodes or replicas,
    allowing for temporary inconsistencies and delays in propagating updates.

