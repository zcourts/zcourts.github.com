---
author: zcourts
comments: true
date: 2011-12-25 00:39:12+00:00
layout: post
slug: cassandra-terminology-cheat-sheet
title: 'Cassandra Terminology : Cheat Sheet'
wordpress_id: 394
categories:
- Cassandra
- NoSQL
tags:
- apache
- cassandra
- cheat
- cheat sheet
- columns
- keyspace
- super
- super columns
- terminology
---

*This document will be updated continuously until it is as complete as can be, please let me know what I can add to make it more useful for everyone, especially new Cassandra  users*


## Columns


At the bottom end of the hierarchy there is a column, a column has three parts to it; A name, value and a timestamp. The name and value is stored as a raw byte array (byte[]) and can be of any size.


## Super Columns


A super column is similar in terms of having a name,value pair however, it does not have a timestamp.

The major difference between a column and a super column is that :

A column maps to the binary representation of a string value and a super column maps to a number of columns.<!-- more -->


## Column Family (CF)


To group columns and super columns, Cassandra has, what is known as a Column Family (CF) . A column family can be of type STANDARD or SUPER. Standard column families store the smaller column types which have a name,value and timestamp.


## Super Column Family (CF)


Similar to a standard column family, however, it groups the super columns


## Rows


Within a CF columns are grouped within a row (Similar relationship between rows and columns in an RDBMS. A row contains a key, this key map to the columns you have in that row. The row key again uses the column names as the internal key (internal i.e. within the row) to which the row key maps. The columns that are contained within a row can be of types, SUPER or STANDARD. Depending on which one your columns are the Column family’s type also matches. In other words, if you have a set of columns that are all of the type SUPER then your column family will also be of type SUPER, the opposite is also true.


## Keyspace


Cassandra’s data model has another layer within its encapsulation hierarchy, the Keyspace. A Keyspace is the outer most layer of Cassandra’s data model, it encapsulates all the column families you create…


## Node


A Cassandra Node is a single server instance within a group of Nodes. In most cases, this is a single physical computer or a single virtual machine instance.


## Cluster


A Cassandra cluster is a group of Nodes that distributes your work amongst them.


## Hinted handoff


[Hinted](http://wiki.apache.org/cassandra/HintedHandoff)[handoff](http://wiki.apache.org/cassandra/HintedHandoff) is the process by which the Cassandra cluster temporarily writes your data to a Node in place of another. This happens when the Node the data was to be written to is offline or cannot be reached for some reason. The data is written to a temporary Node which “hands” off the data to the correct Node once it is back online.


## Partitioner


The partitioner is responsible for distributing rows (by key) across nodes in the cluster.
It is always recommended that you choose the “RandomPartitioner” since it ensures that your cluster’s load is balanced.


## Replication Factor


[Replication](http://wiki.apache.org/cassandra/Operations#Replication)factor is simply how many Nodes in the cluster you want a copy of the data to be on. For e.g within a 5 Node cluster and a replication factor of 2, then all data is stored on two different Nodes.


## Gossip Failure detection


Cassandra uses gossip protocols to detect machine failure and recover when a machine is brought back into the cluster.


### CAP theorem


The **CAP** theorem ([Brewer](http://www.cs.berkeley.edu/~brewer/cs262b-2004/PODC-keynote.pdf)) states that you have to pick two of **Consistency**, **Availability**, **Partition tolerance**: You can't have the three at the same time and get an acceptable latency.

Cassandra values Availability and Partitioning tolerance (**AP**). Tradeoffs between consistency and latency are tunable in Cassandra. You can get strong consistency with Cassandra (with an increased latency).


## Eventual Consistency


Casandra has (configurable) weak [consistency](http://wiki.apache.org/cassandra/ArchitectureOverview#Consistency). As the data is replicated, the latest version of something is sitting on some node in the cluster, but older versions are still out there on other nodes, but eventually all nodes will see the latest version.
More specifically: R=read replica count W=write replica count N=replication factor Q=**QUORUM** (Q = N / 2 + 1)



	
  * If W + R > N, you will have consistency

	
  * W=1, R=N

	
  * W=N, R=1

	
  * W=Q, R=Q where Q = N / 2 + 1


Cassandra provides consistency when R + W > N (read replica count + write replica count > replication factor).

You get consistency if R + W > N, where R is the number of records to read, W is the number of records to write, and N is the replication factor. A ConsistencyLevel of ONE means R or W is 1. A ConsistencyLevel of QUORUM means R or W is ceiling((N+1)/2). A ConsistencyLevel of ALL means R or W is N. So if you want to write with a ConsistencyLevel of ONE and then get the same data when you read, you need to read with ConsistencyLevel ALL.


