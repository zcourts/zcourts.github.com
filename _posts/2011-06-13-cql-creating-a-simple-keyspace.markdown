---
author: zcourts
comments: true
date: 2011-06-13 23:59:35+00:00
layout: post
slug: cql-creating-a-simple-keyspace
title: 'CQL : Creating a simple keyspace '
wordpress_id: 238
categories:
- Cassandra
- NoSQL
tags:
- apache
- cassandra
- create
- create keysapce
- create keysapce example
- example
- keyspace
---

I promised a few tutorials covering [CQL](http://crlog.info/2011/03/29/cassandra-query-language-aka-cql-syntax/) examples so I'm going to kick off a series to demonstrate all/most of the features of [Cassandra](http://cassandra.apache.org)'s new query language, CQL.

In this example we'll create a keyspace and look at the proerties available when doing so, this will demonstrate one of the key words in CQL, [CREATE KEYSPACE](http://crlog.info/2011/03/29/cassandra-query-language-aka-cql-syntax/#CREATEKEYSPACE). This example has been done in Java since it is one of the easiest languages to get up and running with, however the CQL statements are portable i.e. not dependent on the language you use. There is a [PHP CQL driver](https://github.com/nicktelford/php-cql) being developed by [Nick](https://github.com/nicktelford), [Dave](https://github.com/davegardnerisme), my self and others but I've been out for about a month pre-occupied with a few things, the guys have been making some progress so check out the driver if you're using PHP and want to use or contribute to the development.<!-- more -->

There is a Java driver that can be downloaded from [http://www.apache.org/dist/cassandra/drivers/java](http://www.apache.org/dist/cassandra/drivers/java) but it is not required for this tutorial. In a later tutorial I'll provide examples of using the new "Cassandra Drivers", but for now I'm just going to use the new execute_cql_query method provided with thrift. This way, if you're using a language that does not yet have a driver you can still get started with CQL.

```java
package cql.tests;

import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import org.apache.cassandra.thrift.Cassandra;
import org.apache.cassandra.thrift.Compression;
import org.apache.cassandra.thrift.InvalidRequestException;
import org.apache.cassandra.thrift.NotFoundException;
import org.apache.cassandra.thrift.SchemaDisagreementException;
import org.apache.cassandra.thrift.TimedOutException;
import org.apache.cassandra.thrift.UnavailableException;

import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TFramedTransport;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.TException;

public class CqlTests {

    public static void main(String[] args)
            throws TException, InvalidRequestException, UnavailableException, UnsupportedEncodingException, NotFoundException, TimedOutException, SchemaDisagreementException {
        TTransport tr = new TFramedTransport(new TSocket("localhost", 9160));
        TProtocol proto = new TBinaryProtocol(tr);
        Cassandra.Client client = new Cassandra.Client(proto);
        tr.open();
        String cql="CREATE keyspace test1 WITH strategy_options:DC1 = '1' AND replication_factor = '1' AND strategy_class = 'NetworkTopologyStrategy'";
        //create our test keyspace to use
             client.execute_cql_query(ByteBuffer.wrap(cql.getBytes()), Compression.NONE);
        tr.close();
    }
}```

CQL: CREATE keyspace test1 WITH strategy_options:DC1 = '1' AND replication_factor = '1' AND strategy_class = 'NetworkTopologyStrategy'


## CREATE KEYSPACE


_Synopsis:_

    
    <code> CREATE KEYSPACE <NAME> WITH AND strategy_class = <STRATEGY> AND strategy_options.<OPTION> = <VALUE> [AND strategy_options.<OPTION> = <VALUE>];</code>


The `CREATE KEYSPACE` statement creates a new top-level namespace (aka “keyspace”). Valid names are any string constructed of alphanumeric characters and underscores, but must begin with a letter. Properties such as replication strategy and count are specified during creation using the following accepted keyword arguments:
<table >
<tbody >
<tr >
keyword
required
description
</tr>
<tr >

<td >strategy_options
</td>

<td >no
</td>

<td >Most strategies require additional arguments which can be supplied by appending the option name to the `strategy_options` keyword, separated by a colon (`:`). For example, a strategy option of “DC1” with a value of “1” would be specified as `strategy_options:DC1 = 1`; replication_factor for SimpleStrategy could be`strategy_options:replication_factor=3`.
</td>
</tr>
</tbody>
</table>
The above is the doc from the [CQL v1.0 specification](http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/), specifically [http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/#CREATE+KEYSPACE](http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/#CREATE+KEYSPACE).
The specs says strategy_options is not required, however in the 0.8.0 version being shipped at the time of writing a keyspace cannot be created without specifying the properties that were required in the old specification, namely strategy_class and the replication_factor properties [http://crlog.info/2011/03/29/cassandra-query-language-aka-cql-syntax/#CREATEKEYSPACE](http://crlog.info/2011/03/29/cassandra-query-language-aka-cql-syntax/#CREATEKEYSPACE). This issue is addressed in Cassandra versions greater than 0.8.0 - Currently not available for download on the main download page but can be checked out from trunk and built. The easiest option is to simply specify the required properties, otherwise you'll get an exception which looks similar to:

```java
Exception in thread "main" InvalidRequestException(why:missing required argument "strategy_class")
	at org.apache.cassandra.thrift.Cassandra$execute_cql_query_result.read(Cassandra.java:30983)
	at org.apache.cassandra.thrift.Cassandra$Client.recv_execute_cql_query(Cassandra.java:1708)
	at org.apache.cassandra.thrift.Cassandra$Client.execute_cql_query(Cassandra.java:1682)
```
