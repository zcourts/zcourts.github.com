---
author: zcourts
comments: true
date: 2012-05-05 18:55:57+00:00
layout: post
slug: a-leave-of-absence-not-really
title: A leave of absence.... not really.
wordpress_id: 421
categories:
- General
tags:
- absent
- blogging
- enterprise-it
- http
- java
- libraries
- library
- messaging
- netty
- os
- private repositories
- scala
- software-development
- zmq
---

Hello all,

So as many of you know already I've been working at [DataSift](http://datasift.com/) for a while now. Its been totally awesome, for the record.

I've gotten at least 30 mails from readers of my blog asking why I've stopped blogging. I haven't stopped :-).
I can certainly understand why it would seem that way though since I started working I posted once a month or so and the last entry was in December.<!-- more -->

The truth is I have so little time (like seriously) I like to keep myself active so I've been involved with quite a few projects. Some on my own and others with friends.  A lot of my code is up on my github page under [zcourts](https://github.com/zcourts/) username. Admittedly most of the more interesting stuff is still in my private repositories but all that will change over the next few weeks.

I've got a few libraries that I've written and have been using, I'll make those open source under the Apache v2 license as soon as I get round to cleaning them up. Some are in Scala, some are in Java. Although I currently have a little thing against Scala, one of my libs is in the process of being ported to Java (Extended and improved too).

To top it all off I've been writing an operating system. I know right, what do I know about OSs. I've been working on it for about 2 years, and I only just recently bought [**Andrew  Tanenbaum**'s OS book](http://www.amazon.co.uk/dp/0135053765) ...Its nowhere near ready but I have some ideas (that I think are pretty awesome) that I've been trying to experiment with. I expect it'll be another year+ before I release the code for it though :)

What I can say at the moment though is that I've most certainly not thrown in the towel on blogging. I've also had quite a few request about [Cassandra](http://cassandra.apache.org). I'll release some code over the next couple of months that would address all your requests (I'll do some quick tutorials too).

My first little library I'll release is for messaging. And before anyone thinks, "[ZMQ](http://www.zeromq.org/)" let me just say, I tried. But frankly I got pissed off with how much hassle I had to go through to get ZMQ working in Java/Scala. Its nice and simple to use but quickly becomes a pain when the JNI bindings start acting up. Its even 10 times more of a pain when you're on Windows and I don't even know how much harder its made my experience because I'm using 64 bit Windows. Anyway, enough of my ranting. I wrote the messaging library to make it easier to do some networking on the JVM. Its got some similar concepts as ZMQ, after all it was "inspired" by it. When it comes to performance, I only want about 100K messages per second send/receive capacity. My library's been able to send/receive 1 million per second between my laptop and one of my VPS servers located in Canada. If it can be improved, after I make it public I'd welcome any contribution but it performs above and beyond what I need. It's been written on top of [Netty](http://netty.io/) so it is asynchronous and its performance is no surprise because of that fact.

My second library is used for Clustering (Yes I also know about [Akka Clusters](http://doc.akka.io/docs/akka/2.0.1/cluster/cluster.html) but I've had enough to read and I don't yet get the Actor model). Inspired by the Apache Cassandra architecture to some extent. It allows you to quickly and easily distribute and load balance any software (on the JVM). It uses the messaging library I spoke of above. This one is in its very early stages but should be useful. As I said its inspired by the way Cassandra allows nodes to just be added, removed etc as well as some stuff I read in the [Amazon Dynamo white paper](http://s3.amazonaws.com/AllThingsDistributed/sosp/amazon-dynamo-sosp2007.pdf). It'll be a few months before I release this.

I've also been experimenting with a "distributed http server"...as you'd expect it uses the clustering stuff above. The idea is pretty simple. I use Apache HTTP server, as do so many others but imagine if you wanted to add 2,3 or 10 servers. You need load balancers, expensive this that and what not. Imagine you had a web server that just did all of it. You scale out  the same way you would a Cassandra cluster. If you think me mad then I probably am. Its a load of work for no apparent reason ;)

These are a few of the side projects I've been working on (the ones I'll make open source soon).  I've created my lab where I'll show case all my work when they're released. Keep an eye on [lab.crlog.info](http://lab.crlog.info/). I just this week finished helping a friend implementing something, see [http://lab.crlog.info/bookof/](http://lab.crlog.info/bookof/) its rough around the edges and far from the working state he'd like it to be but with the limited time we had this is all I could come up with, you can't even begin to fathom how cool his entire project is. Not to mention how much stuff I've learnt while implementing it for him. I'll re-build it to be much better, knowing all the things I've learnt on the first try.

On the other side of things it almost seems I've forgotten my full time job but the truth is my work is even better. I think I'll add a few posts about using our API etc from Java,PHP,Ruby and C#. DataSift has some awesome things going on and the products make it easy for anyone with a little know how to gain some incredible insights at pretty cheap prices.

All in all, in between work and my side projects I spend about 4-5 hrs sleeping, hardly any time left to blog but with a few of these projects closing off I'll get more time over the next few months.
