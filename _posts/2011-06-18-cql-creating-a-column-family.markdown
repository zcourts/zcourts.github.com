---
author: zcourts
comments: true
date: 2011-06-18 16:28:24+00:00
layout: post
slug: cql-creating-a-column-family
title: 'CQL : Creating a column family'
wordpress_id: 254
categories:
- Cassandra
- CQL
tags:
- column
- cql
- create
- create column family example
- family
---

Following on from my last post about how to [create a keyspace with CQL](http://crlog.info/2011/06/13/cql-creating-a-simple-keyspace/),  in this tutorial/post I'll create a Coloumn family. Unless this has changed recently CQL does not support creating supoer column families. As far as I know there are no plans to do so either...<!-- more -->

Here goes:

```Java
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import org.apache.cassandra.thrift.Cassandra;
import org.apache.cassandra.thrift.Cassandra.Client;
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
        String cql = "USE test;";
        query(client, cql);
        cql = "CREATE COLUMNFAMILY sample (KEY bytea PRIMARY KEY);";
        query(client, cql);
        tr.close();
    }

    private static void query(Client client, String cql) throws SchemaDisagreementException, InvalidRequestException, UnavailableException, TException, TimedOutException {
        client.execute_cql_query(ByteBuffer.wrap(cql.getBytes()), Compression.NONE);
    }
}
```

In the above code demonstrates the minimum you need, the Column family name and the key type. The available column types are available at [http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/#CREATE+COLUMNFAMILY
I](http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/#CREATE+COLUMNFAMILY)f you now use the Cassandra-cli you can see the details of the keyspace/column family using the "show keyspaces;" command:

    
    Keyspace: test:
      Replication Strategy: org.apache.cassandra.locator.NetworkTopologyStrategy
        Options: [DC1:1]
      Column Families:
        ColumnFamily: sample
          Key Validation Class: org.apache.cassandra.db.marshal.BytesType
          Default column value validator: org.apache.cassandra.db.marshal.UTF8Type
          Columns sorted by: org.apache.cassandra.db.marshal.UTF8Type
          Row cache size / save period in seconds: 0.0/0
          Key cache size / save period in seconds: 200000.0/14400
          Memtable thresholds: 0.2953125/63/1440 (millions of ops/MB/minutes)
          GC grace seconds: 864000
          Compaction min/max thresholds: 4/32
          Read repair chance: 1.0
          Replicate on write: true
          Built indexes: []


It creates the column family with the default values shown above. Some of these may not
be desirable for your use case so CQL allows you to customize your column family to your heart's content.
For example, you could easily change the CQL statement above to look something like this:
CQL:
CREATE COLUMNFAMILY sample1 ( KEY uuid PRIMARY KEY, 'username' text,  'age' varint, 'birthdate' bigint, 'id' uuid ) WITH comment = 'shiny, new, cf' AND default_validation = ascii;
Now using the CLI again you'll see something similar to:

    
        ColumnFamily: sample1
        "shiny, new, cf"
          Key Validation Class: org.apache.cassandra.db.marshal.UUIDType
          Default column value validator: org.apache.cassandra.db.marshal.AsciiType
          Columns sorted by: org.apache.cassandra.db.marshal.UTF8Type
          Row cache size / save period in seconds: 0.0/0
          Key cache size / save period in seconds: 200000.0/14400
          Memtable thresholds: 0.2953125/63/1440 (millions of ops/MB/minutes)
          GC grace seconds: 864000
          Compaction min/max thresholds: 4/32
          Read repair chance: 1.0
          Replicate on write: true
          Built indexes: []
          Column Metadata:
            Column Name: birthdate
              Validation Class: org.apache.cassandra.db.marshal.LongType
            Column Name: id
              Validation Class: org.apache.cassandra.db.marshal.UUIDType
            Column Name: username
              Validation Class: org.apache.cassandra.db.marshal.UTF8Type
            Column Name: age
              Validation Class: org.apache.cassandra.db.marshal.IntegerType


The options that can be specified are all available [http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/#CREATE+COLUMNFAMILY](http://crlog.info/2011/06/13/cassandra-query-language-cql-v1-0-0-updated/#CREATE+COLUMNFAMILY)
I'd copied some for creating a keyspace into my last post but there are too many for creating CFs so have a look at the link
above it'll show you the options available.
