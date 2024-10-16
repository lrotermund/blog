---
type: post
title: "From zero to terraform hero – without paying a dollar"
tags: ["terraform", "opentofu", "devops", "aws", "iac"]
date: 2023-10-29T12:40:09+02:00
images: ["/assets/kassel-1092037_1280.webp"]
image_alt: ""
description: "I hate paying for learning resources. For that reason, I will
learn together with you, how to setup and run terraform – without paying a
dollar"
summary: "I hate paying for learning resources. For that reason, I will
learn together with you, how to setup and run terraform – without paying a
dollar"
toc: false
draft: true
---

IT systems are constantly changing. Just like our knowledge as computer
specialists and software developers. While 10 years ago we had to think about
the right hardware infrastructure to share software to hundreds or thousands of
customers, today the cloud computing providers Amazon Web Services, Microsoft
Azure or Google Cloud Platform are the first choice.

They all offer incredible power and flexibility when it comes to deploying a
wide variety of hardware infrastructures. Whether it's a website, an online
store, a game server, or a neural network, everyone can find the right,
easy-to-configure products without having to set up, install, and maintain
hardware systems themselves. Everything is just a click away.

When I worked at an advertising agency until early 2020, all the websites and
software solutions we developed and delivered to our clients were hosted on
self-managed shared and dedicated servers at a trusted server provider. In the
following two jobs, however, I came into more contact with cloud computing
providers, which is also the core and motivation for this article. If I were in
my position at the advertising agency again, I would use cloud computing
services more often, simply because it would have saved me a lot of work.

I would like to take you with me on my learning journey. We'll start with the
classic {{< abbr "VPS" "Virtual private server" >}} and then look at cloud
computing and infrastructure as code. After a look at the
{{< abbr "IaC" "Infrastructure as Code" >}} providers Terraform and OpenTofu, we
will build a hands-on Terraform project together and continuously apply it to
the local AWS abstraction layer [LocalStack](https://www.localstack.cloud/) to
emulate as much real Terraform behavior as possible.

{{< toc >}}

## What makes a terraform hero?

Over the past few years, I've met a few colleagues who worked with me or the
companies I worked for who were all proficient in dealing with different cloud
providers and could easily make dynamic adjustments to the infrastructures they
managed. At the time, I only had a good basic understanding of Docker and
Kubernetes. Anything beyond Kubernetes and Docker, as well as classic
{{< abbr "VPS" "Virtual private server" >}}, was a black box to me.

To me, these colleagues are Terraform heroes. Terraform heroes are able to
transform system infrastructure requirements into an efficient, easy to
understand, and replicable Terraform project.

A basic understanding and cost-effective use of cloud resources is part of the
Terraform hero's toolbox. They can weigh which resources are needed for a
requirement and advise which will deliver the most performant, cost-effective,
and resilient result.

## The non-cloud way of managing your system

I don't want to start from scratch with this blog post. I assume you know what
a server is and what it does. I want to start where my journey began, working
on a {{< abbr "VPS" "Virtual private server" >}}.

{{< abbr "VPSs" "Virtual private server" >}} are part of, or a precursor to,
cloud computing.  Some time before AWS, Google and others started offering their
services, there were some data centers and hosting providers offering
{{< abbr "VPS" "Virtual private server" >}}.

### The classic VPS

A {{< abbr "VPS" "Virtual private server" >}} is basically a classic server that
you can put under your desk at home, except it is mounted in a rack in a data
center. There is a {{< abbr "VPS" "Virtual private server" >}} for every budget.
There are very low performance {{< abbr "VPSs" "Virtual private server" >}}
whose resources are shared by multiple customers, and there are dedicated,
highly equipped, high performance {{< abbr "VPSs" "Virtual private server" >}}
that are leased directly and exclusively to one customer. Depending on the
configuration, data centers can provision
{{< abbr "VPSs" "Virtual private server" >}} in minutes to hours.

This flexibility, coupled with the speed with which a
{{< abbr "VPS" "Virtual private server" >}} can be ordered, makes it an
extremely popular product to this day. This brings us to the non-cloud way of
ordering hardware resources.

The process is basically the same no matter which provider I order from. The
first step is to determine what the basic hardware requirements of your
application are. This can be easily determined by running the application
locally, and multiplied if you have a rough idea of how many users the future
application will have.

With the requirements for your {{< abbr "VPS" "Virtual private server" >}} in
mind, you can then go to any VPS provider and choose a suitable offering,
select an operating system image and complete the order. If necessary,
additional features such as a domain can be booked, but this should all be
optional. Some providers also offer an
{{< abbr "API" "Application Programming Interface" >}} for this process, which
allows for some optimization when creating
{{< abbr "VPSs" "Virtual private server" >}}, especially on a larger scale.

### It's totally legitimate

## The cloud motivation
### Gaining infrastructural flexibility
### The price conflict

## The AWS basics
### But why AWS?
### AWS alternatives
### EC2 – The VPS of the 21st century
### AWS networking – The backbone for your EC2 instances

## The IaC basics
### The motivation of using IaC
### The 2023 Terraform licensing conflict
### OpenTofu as an alternative to Terraform

## Learning AWS and Terrafrom without spending a dollar
### My problem of spending money for learning resources
### The cloud pricing dilemma
### The training dilemma
### The certification dilemma
### LocalStack as my solution for being an AWS and Terrafrom newbie
### Just ask your team to gain operational DevOps experience

## Terraform hands-on
### The goal
### The project structure
### The VPC module
#### Defining the inputs
#### Defining the outputs
### The EC2 module
#### Defining the inputs
#### Defining the outputs
### The Autoscaling module
#### Defining the inputs
#### Defining the outputs
### The IAM module
#### Defining the inputs
#### Defining the outputs
### The Security Groups module
#### Defining the inputs
#### Defining the outputs
### The Route53 module
#### Defining the inputs
#### Defining the outputs
### The RDS module
#### Defining the inputs
#### Defining the outputs
### The S3 module
#### Defining the inputs
#### Defining the outputs
### Composing the infrastructure

## Do's and Don'ts
### Do's
### Don'ts

## My conclusions

## Disclaimer

