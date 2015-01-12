---
author: zcourts
comments: true
date: 2013-06-28 22:40:04+00:00
layout: post
slug: my-phds-a-go-graph-database-with-the-distributed-nature-of-cassandra-and-the-graph-properties-of-neo4j
title: My PhD's a go! - Graph database with the distributed nature of Cassandra and
  the Graph properties of Neo4J
wordpress_id: 651
categories:
- General
tags:
- cassandra
- chris walshaw
- distributed database
- distributed graph database
- flockdb
- graph
- graph database
- graph partitioning
- graph processing
- hadoop
- haskell
- hbase
- jvm
- neo4j
- PhD
- titan
---

I've been thinking about this for a while now and I've made a solid decision finally. At some point later this year I'll be starting a PhD (Probably October).

I've been using [Apache Cassandra](http://cassandra.apache.org/) for years now, since 2008 not long after Facebook open sourced it. Since then I've played with most of the major NoSQL databases and frameworks (Neo4J, HBase, CouchDB, Hadoop, etc) and in virtually all the projects I've found the need to repeatedly be modelling graph or graph-like data. In some cases it's worked out great, in others it was a terrible idea but luckily I've always recognised very early on when the data model is just terrible for that DB so haven't wasted time on it.<!-- more -->

More to the point though, Graph databases are extremely useful. And there have been numerous attempts at implementing a graph interface on top of existing DBs, [Titan](http://thinkaurelius.github.io/titan/) for example runs on top of [Cassandra](http://cassandra.apache.org/), [HBase](http://hbase.apache.org/) or [BerkleyDB](http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html). Or even native Graph DBs such as Twitter's [FlockDB](https://github.com/twitter/flockdb) or [Neo4J](http://www.neo4j.org/).

But I think this area is still under-developed and there's a lot of room for research and improvement.

My first order of business is keeping Java away from the implementation! Don't get me wrong, I love Java as much as the next guy but from my experience with Cassandra, HBase and Hadoop, Java adds unnecessary problems to an already complicated situation. I am especially disappointed that until this day Sun/Oracle has not sorted out the JVM memory size limit. Seriously, with all the cloud computing malarkey, memory is cheaper than ever, there are massive advantages to storing as much information in memory as possible but the JVM craps out at about 8GB on 64 bit machines. You can try to push it further, people have been known to use bigger heap sizes but you're asking for trouble doing that.

What I am considering and have pretty much decided is that I'll be implementing whatever results from my PhD in [Haskell](http://www.haskell.org/). For a few reasons



	
  1. I get memory management

	
  2. It's a beautiful language

	
  3. No crappy 8GB memory limit

	
  4. I want to learn it (this should probably have been  number 1)

	
  5. I still get cross-platform support

	
  6. Better interface with native C/C++ libraries because some things are just better left in C


I'm familiar with Haskell so a part of this will just be getting to know it as well as I do Java, PHP, Scala etc. My other reasoning is simply that I am combining things I'm enthusiastic about. "Big Data" and the promise of learning a language that intrigues me. It'll be fun!

Ultimately the more serious side of my research will focus on developing a completely distributed graph database. The real challenge, or the big problem I'm going after is automatic partitioning of graph data across a cluster. Imagine a database with the horizontal scalability (add machines as opposed to CPU/RAM) of Cassandra but with the graph processing capabilities of Neo4J.

I'm fortunate enough to know [Chris Walshaw](http://staffweb.cms.gre.ac.uk/~wc06/) who is well established in the graph partitioning/processing space and has agreed to be my project supervisor.

For once I'll be in education and enjoying it because it'll be under my terms and doing things I like, pretty exciting times ahead!
