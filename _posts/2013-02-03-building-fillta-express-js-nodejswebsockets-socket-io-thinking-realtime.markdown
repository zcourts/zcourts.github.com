---
author: zcourts
comments: true
date: 2013-02-03 21:28:27+00:00
layout: post
slug: building-fillta-express-js-nodejswebsockets-socket-io-thinking-realtime
title: Building Fillta - Express JS, NodeJS,WebSockets & Socket.IO - Thinking Realtime
wordpress_id: 478
categories:
- Fillta
tags:
- angularjs
- apache cassandra
- async
- asynchronous
- blogging
- cassandra
- events
- expressjs
- facebook
- fillta
- java
- nltk
- nodejs
- pinterest
- realtime
- scala
- technology
- twitter
- wordpress
---

One of the things we've aimed for when Fillta was being designed is having everything as "real time" as possible. And before I go any further, let me define what is meant by "real time" in this context. I often see people use the term lightly for things that I'd never consider to be real time.


## Realtime


My definition and for the purposes of this post, "real time" refers to the ability of the system to discover, process and distribute an item "as soon as possible". As soon as possible could be within a second or two seconds, it could be within 30 seconds, any more than that and I'm inclined to think that it isn't real time. The definition is further constrained to something people often don't mention, relativity. When I say within 1 or 2 seconds I mean, if I publish this blog post now at 20:34:00, for my definition, a real time system is one that would detect and react to that  by 20:34:02 or 20:34:30 at worse...<!-- more -->

The first major issue with real time is, the HTTP protocol is simply not designed for it. It is far more efficient to have a custom binary protocol where, once the initial handshake is done, no more headers etc needs to be sent. This narrowed the choice of technology down to WebSockets, Flash, Long polling or something along those lines.


## Express JS, NodeJS & Socket.IO


The first thing that popped to mind was [socket.io](http://socket.io/), it uses WebSockets and provides legacy browser fallback all the way to IE 5 (People still use that?). NodeJS is then a dependency of that and comes into the picture. Socket.IO worked great. It was in place and provided real time communication from browsers to our backend services. Eventually it got to be too much for NodeJS, what I found was that the work a single Java/Scala service was handling and emitting was causing the NodeJS service to fall over. Couple that with the NodeJS process just terminating with exit code 0 as if all is well and it means no sleep.... Attempts to optimize the Node code only went so far. I don't want to point a finger at NodeJS (it is a decent piece of tech) but at the same time I'd like to think my JavaScript isn't so bad I can't make a NodeJS program perform as well as a Java/Scala program. The long and short of it is that it was taking two NodeJS processes to do the work of what I feel should be a single Node.

In the time we'd developed the NodeJS service, we'd also started making use of Express JS, had no problems with Express JS itself but a few sleepless nights with NodeJS and the decision was made to avoid NodeJS all togehter and stick to the JVM.


## Asynchronous


Efficient real time processing meant an async. system. This means we have no idea what will happen when or in what order. It took a while to sink in but realizing we had to complete change the way we think about development made programming asynchronous code easier. One of the things that became important was context. Within an asynchronous context we want to be sending as many things as possible but we want them to be as small as possible because there is potential for more small events than there would be were it synchronous.

This also has an added thing to consider. Wanting to keep event/messages small one might be tempted to maintain state on the server. That also proved to not be very scalable. There's the age old problem you get when for example people use server side sessions. The session is local to the node within your cluster. You may then be tempted to solve that the same way the session issue was "resolved", stick a proxy in front of the client to ensure all requests from one client goes to the same Node. There are a few reasons this doesn't work in our case. A client is not just a user,  a client could be a mobile, browser or other services. All these "clients" being routed to the same node because one user is overly active ([Twitting](http://twitter.com), [Blogging](http://wordpress.com), [Pinning ](http://pinterest.com/)or on [Facebook](http://facebook.com)) will lead to hotspots and wasted resources.

We, when required found optimal data structures for compressing/summarizing data for e.g. our services communicate using [Merkle Trees](http://en.wikipedia.org/wiki/Hash_tree) to summarize data we need to send over the network. This provided a way of ensuring context is available when processing arbitrary events from only god knows where it originated.

The async nature of everything has meant even the client/UI is all built and optimized to handle random events as and when they occur. It is a tight blend of both reactive and proactive design. I posted a simplified version of [Async communication using AngularJS](http://crlog.info/2013/01/09/angularjs-communicate-between-controllers-services-and-directives/), imagine that with features such as "republish" where, when a new subscriber is added a publish republishes an event the subscriber missed...if they want. This design actually worked out great because every component in the UI can be tested separately, they are completely de-coupled, features/components can be added and removed without affecting anything else because everything is just working based on events the receive, or not...


## Conclusion


I know this post wasn't as specific or technical as my usual posts but obviously [Fillta](http://fillta.com) is still in development and we want to save some of the fanfare for Alpha (2 or so months away), Beta and launch.

In conclusion though, we've learnt a great deal in the last 7 months, tried so many different things, most worked, others didn't and its been great. We're hoping to get releases going so so people can see what we've been building, test and give us some feedback! And as the time draws nearer we'll be open sourcing some stuff (Follow [zcourts Github](https://github.com/zcourts), for e.g. we're developing and have already open sourced [Higgs](https://github.com/zcourts/higgs)) and doing more detailed blog posts on what technologies we're using, for what and our experience with them thus far.

For now however, some of the things we're using include [AngularJS](http://angularjs.org/), [Java](http://www.oracle.com/us/technologies/java/overview/index.html), [Scala](http://www.scala-lang.org/), [NLTK](http://nltk.org/), [Apache Cassandra](http://cassandra.apache.org) and more. Plus the features, some design aspects etc are based on research obtained via the [IEEE](http://ieeexplore.ieee.org) and [ACM](http://www.acm.org/).
