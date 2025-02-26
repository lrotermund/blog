---
type: post
title: "Event sourcing - the naive approach"
tags: ["eventsourcing", "domain-driven-design"]
date: 2025-02-27T00:04:00+02:00
images: ["/assets/pexels-wolfgang-weiser-467045605-20884700.webp"]
image_alt: |
    Greyscale photography of several clocks on posts in front of a forest.
description: |
    Event sourcing always sounds mystical, and many developers don't dare
    approach it. Let's take a look at an attempt at a native implementation.
summary: |
    Event sourcing always sounds mystical, and many developers don't dare
    approach it. Let's take a look at an attempt at a native implementation.
toc: false
draft: false
---

How do we store our application's data? Often the answer is obvious and leads us
developers to the Swiss army knife of data storage - relational databases and
some ER model. But is this the only way to store information?

For me it was, until I learned about event sourcing. Today I want to share with
you my naive view of event sourcing. I think this is important because event
sourcing is a building block of "software architecture" and it is often mixed
with a little domain-driven design and a micro-service here and there - leading
to the software architecture ivory tower. A place we all hate because it feels
like gatekeeping.

Event sourcing is really simple in my eyes. We don't need big event sourcing
frameworks or expensive workshops or big books to understand it. In my opinion,
that is all gatekeeping. And if you think all this is important, then maybe you
are part of the problem.

Let's make software development fun.

{{< toc >}}

## How we usually store data

It doesn't matter what field you're in as a software developer, when it comes to
databases we all share a common way of storing information - optimised ER models
and create, read, update and delete operations to manage them. And it doesn't
matter whether we use relational or document databases.

### CRUD - create, read, update, delete

The purchasing department pre-orders some new sample products from a
manufacturer? This must be a Create Product operation! The pre-ordered product
looked good and was of good quality? Well, our content department looks at the
product and adds it to the product information system to enrich it with data.
This must be a Create Product operation! The content department adds a new
description to the product? That must be an Update Product operation! The
shipping container has just arrived - more stock! That must be an update
operation!

As developers, we are sometimes pretty good at generalising things - in fact, we
are trained to do so. From day one, we learn to reuse code and generalise it
down to generic functions with generic names. We don't build a nice, new,
state-of-the-art way of handling HTTP requests, we just use a generalised
framework or (standard) library.

No wonder we came up with create, read, update and delete XYZ. It is
generalised, it is efficient and everyone knows what we are talking about when
it comes to "building a product" - or do we?

When it comes to domain-specific language, we have already lost information. Try
talking to your colleagues or customers from the purchasing department and they
may give you a confused look when you talk about creating, reading, updating or
deleting products. They often have different ways of creating, updating and
deleting products, depending on the status of the product, and sometimes it is
not allowed to 'delete' a product. Ultimately, you and your colleagues or
customers speak different languages and this will cause problems. Sometimes it
just slows down communication, sometimes it leads to bugs.

And when you look at your tables, it will be hard to see how your product has
changed over time if you don't log everything in a domain-specific way and in a
domain-specific language in an extra log table.

### Normalization

We don't stop at generalisation when it comes to storing our structured bits and
bytes. In a naive world, we store everything in one big table, similar to a big
Excel spreadsheet. We see the product and its variants and its inventory and so
on. Data that is related is grouped in a single column, so we can easily see the
manufacturer's address, for example. One query, one look in our database and we
have the current status of our product.

This is quite nice for reading the data, but when it comes to writing, we are
faced with other problems. Updating a product's manufacturer address may be fine
for one product, but not for 30,000 products. There are many more problems with
unnormalised data, you will quickly find examples.

So we end up normalising the data. We move the manufacturers to their own table,
and also the different stocks for our warehouses. We clean everything up until
we have clean, separate data. And now we have tricked ourselves into a bad
queriable data structure. We have to write joins and subqueries and our
object-relational mappers sweat under the load of thousands of unoptimised,
naive queries because SQL is too hard for us developers today and we abstract
everything away and construct unnecessarily complex queries. ~Shit~ magic
happens.

Please don't get me wrong, normalisation is not bad per se. What I want to say
is that it is not the only tool we have. There are alternatives and it should
not be a swizz army knife.

## How we could store data

Another way of storing data is event sourcing. This may be the reason why you
are reading this article.

For the next few paragraphs, please forget everything you know about classical
data storage, normalisation and CRUD. Just keep an open mind and imagine
yourself back in the time before you learned about databases.

### Thinking inside the domain

Let us try to think naively. When you talk to colleagues or customers, what
usually comes up when you talk about their domain(s) are specific events. What
we have done so far is to generalise them, but not this time. We don't go back
to our developer language and we stick to the domain-specific language.

Together with the domain experts, we go through all the possible events that
occur in their daily life and try to identify all the events that are worth
storing that affect the state of "the thing" - e.g. a product or an order.

This "thing" is usually called an aggregate in event sourcing. Aggregate because
it is the product of all the aggregated, domain-specific events.

These events are what we store. We track when...

- a product sample is pre-ordered by the purchasing department
- a product is listed and receives a SKU number
- a product is enriched with content by the content department
- a product stock is increased by X due to a new delivery
- a product stock is increased by X due to a return
- etc.

We simply add events to a global collection of domain events that have occurred.
A big plus, we just add new events. We don't look up events and update or delete
them. They are in the past, we don't change what has happened - of course, this
doesn't apply to GDPR relevant data. There we delete aggregates.

### A shared language

One small but important thing that comes to mind when looking at the stored
events is that we now share a domain-specific language with our colleague or
customer.

If they call you and ask what happened to the product, you can give them a
detailed, translation-free answer just by looking at the store. You no longer
have to query and join a few tables together, perhaps to find an answer that
doesn't share the language your colleagues or customers are speaking with you.

This is a brilliant way to simplify your support life and it reduces the
overhead of training new staff in both 'languages'. We just "drop" ;-) the
technical nonsense.

### A natural history - not a log

Because of this natural way of storing data, we have a true timeline of all the
relevant domain events that have happened to our aggregates. By looking at our
event store, we can easily answer questions about the current state of the
aggregates, which is just a "filtered" way of looking at the events.

We can extract different kinds of information from the past by creating a
snapshot, or rather a projection, using a selective subset of our events. If we
want to answer the question about the status of our products, we project the
following events

- product pre-ordered -> `status = pre-ordered`
- product listed -> `status = listed`
- product published -> `status = published`
- product discontinued -> `status = discontinued`

Do you see what we are doing here? We define the projection "product status" by
loading a subset of events, from start to finish, and change the projection
status depending on the event.

OK, but do we now have to "project" these events every time we want to know the
status of a product? No. There is nothing stopping us from saving these projects
separately. And there are more advantages.

### Freedom of database technologies

The events are stored in a structured but not normalised way and this is fine.
The write, read and sometimes delete operations on our events are quite fast and
we don't need to update them.

These events could be stored in a really dynamic way, like JSON documents,
because each event has a different content. A classic relational database might
not be the best choice here, and that's OK.

But just because we store our events in a (JSON) document database, we are also
free to store our projections in a perfectly read and join free way, or if we
want and need relations, we can spread the data into a relational database.

And if we realise that the choice of database was wrong, we can throw away our
database, set up a new one and replay the events in a fresh projection for our
new database - the path leading to the final projection is reproducible.

In the end, we may also realise that we don't need a classical database to store
our projection, that a cache is sufficient. After all, the projection doesn't
matter and is replaceable.

## Its not complicated nor is it complex

As you can see, event sourcing is a great, non-technical way of dealing with
data storage. It is focused on the domain of the colleagues or customers, and
you work more closely with them in the same language.

Technically, you benefit from a flexible choice of databases because you are not
tied to relations. Your core repository is just an event store, a simple
collection of domain-specific events.

Specific projections are stored where you need them, in the way you need them.
Relational, document or just a cache - it doesn't matter.

Let's talk about it on mastodon, I'd love to hear your thoughts on event
sourcing:

[@lukasrotermund@social.tchncs.de](https://social.tchncs.de/@lukasrotermund)
