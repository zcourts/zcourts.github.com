---
author: zcourts
comments: true
date: 2011-01-10 22:11:00+00:00
excerpt: 'Today I embarked on a wonderful misadventure.

  I decided to write an SQL parser/Interpreter for Apache Cassandra.


  While some may argue that this goes against the NoSQL movement, I strongly disagree
  with that.'
layout: post
slug: nosql-cassandra-sql-parser
title: NoSQL/Cassandra SQL parser
wordpress_id: 8
categories:
- Cassandra
- NoSQL
---

Today I embarked on a wonderful misadventure.
I decided to write an SQL parser/Interpreter for [Apache Cassandra](http://cassandra.apache.org).

While some may argue that this goes against the NoSQL movement, I strongly disagree with that.

NoSQL systems mainly aim to be distributed, highly response and available. While parsing an SQL query adds a bit of time to the time from query to result set, all the other benefits of a NoSQL system such as Cassandra still remain.

If you're in an environment where you need the 0.333 milisecond query response time of Cassandra then fair enough, by all means use the raw thrift interface or whatever native interface your chosen NoSQL system offers. An argument/debate into this could go on forever but everyone has different requirements. If I get my result set in 1 second I don't think my users will be disappointed at all :-).

So far I've looked into a few options for parsing SQL, I found [JSQL Parser](http://jsqlparser.sourceforge.net/) which looked interesting but from what I've seen after downloading it may not be quite what I'm looking for.

I've briefly brainstormed implementing my own, that would be vendor specific to [MySQL](http://www.mysql.com). My reasoning being purley that if I'm going to find this usable for any of my needs it may as well be tailored to the SQL server I already use. I looked into the [reserved keywords for MySQL](http://dev.mysql.com/doc/mysqld-version-reference/en/mysqld-version-reference-reservedwords-5-5.html), and realised that it was a very long list. Not to fear, I've decided to start small and implement the keywords I'm likely to use then add more as I go along.

Given how briefly I brainstormed, it sounds like a recipe for disaster, but I am going to have a hard hack at it for the next two hours. If I make any promising progress I will certainly sit down and put more thought into it.

For now though, lets experiment :-)
