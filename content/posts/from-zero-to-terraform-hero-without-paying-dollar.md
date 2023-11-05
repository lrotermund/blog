---
type: post
title: "From zero to terraform hero – without paying a dollar"
tags: ["terraform", "opentofu", "devops", "aws", "iac"]
date: 2023-10-29T12:40:09+02:00
images: ["/assets/kassel-1092037_1280.webp"]
description: "I hate paying for learning resources. For that reason, I will
learn together with you, how to setup and run terraform – without paying a
dollar"
summary: "I hate paying for learning resources. For that reason, I will
learn together with you, how to setup and run terraform – without paying a
dollar"
toc: false
draft: false
---

IT systems are constantly changing. Just like our knowledge as computer
scientists. While 10 years ago we had to think about the right hardware
infrastructure to deploy software to hundreds or thousands of customers, today
the cloud computing providers Amazon Web Services, Microsoft Azure or Google
Cloud Platform are the first choice.

They all offer incredible power and flexibility when it comes to deploying a
wide variety of hardware infrastructures. Whether it's a website, an online
store, a game server, or a neural network, everyone can find the right,
easy-to-configure products without having to set up, install, and maintain
hardware systems themselves. Everything is just a click away.

When I worked at an advertising agency until early 2020, all the websites and
software solutions we developed and delivered to our clients were hosted on
self-managed shared and dedicated servers at a trusted server provider. In my
last two jobs, however, I came into more contact with cloud computing providers,
which is also the core and motivation for this article. If I were in my position
at the advertising agency again, I would use cloud computing services more
often, simply because it would have saved me a lot of work.

I would like to take you with me on my learning journey. We'll start with the
classic {{< abbr "VPS" "Virtueller privater Server" >}} and then look at cloud
computing and infrastructure as code. After a look at the
{{< abbr "IaC" "Infrastructure as Code" >}} providers Terraform and OpenTofu, we
will build a hands-on Terraform project together and continuously apply it to
the local AWS abstraction layer LocalStack to emulate as much real Terraform
behavior as possible.

{{< toc >}}

## What makes a terraform hero?



## The non-cloud way of managing your system
### It's totally legitimate
### The classic VPS

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

