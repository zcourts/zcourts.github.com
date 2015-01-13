---
author: zcourts
comments: true
date: 2011-01-29 11:50:06+00:00
layout: post
slug: restish-wrapper-for-hectorcassandra-data-manipulation
title: RESTish Wrapper for Hector/Cassandra data manipulation
wordpress_id: 42
categories:
- Cassandra
- RESTish
---

## [![](http://crlog.files.wordpress.com/2011/01/restish-logo.jpg)](http://crlog.files.wordpress.com/2011/01/restish-logo.jpg)Introduction to RESTish


I've been using [](http://cassandra.apache.org/)[Cassandra ](http://cassandra.apache.org/) for a while now and few days ago I settled on using it for my final year Uni project.
My project consists of quite a few components written in Java,C++ and PHP this means I needed to be able to interact
with the data  from all the languages. As it turns out clients for C++ and PHP for the 0.7+ version of Cassandra are either
incomplete or none existent.

I decided to write a client for it, but why write two separate clients in different languages? I'm only in my second year but who has that kind of time? The big thing at the moment is using [](http://en.wikipedia.org/wiki/Representational_State_Transfer)[REST](http://en.wikipedia.org/wiki/Representational_State_Transfer) APIs for language independence. I've never implemented a full scale REST architecture (played with a few frameworks that did the work :p), but it seems like a good idea.

After more thought I decided the first thing it would have to do is act as a server which just ran in the background otherwise the start up time of the JVM on each request would take away a tonne of the speed expected. A second design decision was to use [](http://www.json.org/)[JSON](http://www.json.org/) as the initial method of passing data in and out. Support for XML will be put in place in the future...after the API is in a reasonable state.

My previous post on [](http://crlog.files.wordpress.com/2011/01/restish-logo.jpgtutorials/building-a-simple-java-none-blocking-server.html)[how to build a none-blocking java server](http://crlog.files.wordpress.com/2011/01/restish-logo.jpgtutorials/building-a-simple-java-none-blocking-server.html) mentioned the client and explained the initial issues with that approach. In the end I decided to use [Netty](http://www.jboss.org/netty/) for the server side of things.  Netty is well established and highly capable of handling many simultaneous requests. After getting familiar enough with Netty I put a quick server implementation in place, which allows me to accept requests/data and push results back to the client...simples!

The API

The API will be very simplistic and self documenting. The aim is to eventually support everything you can do with Hector. I say self documenting because it will have a means to describe
all the supported methods/actions/commands. For example, at the moment, the API allows you to create a Keyspace and all* of the parameters that you can set via hector's API. Below is a PHP example of generating the JSON request to be passed to the server



```php
 <?php

 $fp = connect();
 if (!$fp) {
 echo "$errstr ($errno)<br />\n";
 } else {
 echo "<pre>";
 $data = array("apiVersion" => "V1", "cmd" => "help");
 fwrite($fp, json_encode($data));
 while (!feof($fp)) {
 echo fgets($fp, 128);
 }
 fclose($fp);
 echo "<pre/>";
 $fp = connect();

 $userscf = array("setColumnType" => "STANDARD",
 "setComparatorType" => "UTF8TYPE", "setSubComparatorType" => "ASCIITYPE",
 "setGcGraceSeconds" => 300, "setKeyCacheSize" => 456, "setRowCacheSize" => 900,
 "setMaxCompactionThreshold" => 3432, "setMinCompactionThreshold" => 100,
 "setReadRepairChance" => 0.7);
 $cfdef = array("Users" => $userscf);
 $data = array("apiVersion" => "V1", "cmd" => "createKeySpace",
 "replica_placement_strategy" => "org.apache.cassandra.locator.SimpleStrategy",
 "replication_factor" => 3,
 "name" => "Testing", "columnFamilyDef" => $cfdef);
 //var_dump($data);
 echo "<pre>";
 fwrite($fp, json_encode($data));
 while (!feof($fp)) {
 echo fgets($fp, 128);
 }
 echo "</pre>";
 fclose($fp);
 }

 function connect() {
 return fsockopen("127.0.0.1", 9989, $errno, $errstr, 30);
 }
 ?>
 ```

The JSON generated looks like this:

{



"apiVersion": "V1",




"cmd": "help"



}

{



"apiVersion": "V1",




"cmd": "createKeySpace",





"name": "Testing",





"replication_factor": 3,





"replica_placement_strategy": "org.apache.cassandra.locator.SimpleStrategy",





"columnFamilyDef": {





"Users": {





"setReadRepairChance": 0.7,





"setComparatorType": "UTF8TYPE",





"setMinCompactionThreshold": 100,





"setMaxCompactionThreshold": 3432,





"setRowCacheSize": 900,





"setColumnType": "STANDARD",





"setGcGraceSeconds": 300,





"setSubComparatorType": "ASCIITYPE",





"setKeyCacheSize": 456





}





}



}

The above JSON of course sends two distinct commands to the server, the first command is help, which sends a description and other info back about supported method calls, their parameters and which parameters
are required.
The second command, createKeySpace attempts to create a  keyspace and specifies its replication factor,replicat strategy and a list of column families to create as well as the parameters to define each column family.
The example only demonstrate creating a single column family but multiple column family definitions can be passed in the same request and all with different or the same parameters.

The response generated by the help request above looks like this:


{



"V1": {




"createKeySpace": {





"desc": "Allows you to create a keyspace on the server, only name is required. replication default=1,placement strategy = simplestrategy",





"params": {





"required.replica_placement_strategy": "false",





"name": "Name of the keyspace you want to create",





"required.name": "true",





"replica_placement_strategy": "The replication strategy to be used",





"replication_factor": "The replication factor for this keyspace",





"required.columnFamilyDef": "true",





"required.replication_factor": "false",





"columnFamilyDef": {





"required.setKeyCacheSize": "false",





"desc": "Allows you to specify a list of column families and the properties of each column family. List of CFs must have the CF name as the key e.g to create the CFs Users and Songs you would set columnFamilyDef property as : {"Users":{"setComparatorType":"UTF8TYPE","setColumnType":"STANDARD"},"Songs":{"setColumnType":"STANDARD"}} ... This creates the two CFs with different properties",





"setComparatorType": " All built in types supported, not yet support custome comparators supported list : BYTESTYPE, ASCIITYPE, UTF8TYPE, LEXICALUUIDTYPE, TIMEUUIDTYPE, LONGTYPE, INTEGERTYPE",





"setRowCacheSize": " Should be a double e.g 0.7",





"setMinCompactionThreshold": " Must be an integer",





"required.setComparatorType": "false",





"required.setGcGraceSeconds": "false",





"required.setMinCompactionThreshold": "false",





"required.setReadRepairChance": "false",





"setGcGraceSeconds": "Must be a number otherwise it will be ignored",





"setKeyCacheSize": " Should be a double e.g 0.7",





"setReadRepairChance": "Should be a double e.g 0.7",





"required.setColumnType": "false",





"setMaxCompactionThreshold": " Must be an integer",





"setColumnType": "The column type, STANDARD or SUPER are the only options",





"required.setMaxCompactionThreshold": "false",





"required.setRowCacheSize": "false",





"required.setSubComparatorType": "false",





"setSubComparatorType": " Same options available as setComparatorType"





}





}





}





}



} 

The response of for the createKeySpace command can return the status as success or as fail. If the command failed the reponse would be similar to:

{



"apiVersion": "V1",




"reason": "Unable to create keyspace message: org.apache.thrift.transport.TTransportException: java.net.SocketException: Connection reset by peer: socket write error cause : org.apache.thrift.transport.TTransportException: java.net.SocketException: Connection reset by peer: socket write error",





"status": "fail"



}

In general the API will try to return a useful message as to why the request failed, if an unexpected exception occurs then the java stack trace is returned as the reason for the failure.
If the createKeySpace command had bee successful, the returned results would be similar to:

{



"apiVersion": "V1",




"reason": "755e0430-2b92-11e0-a3f5-2beda0c55c24",





"status": "success"



} 

The idea here is that any command passed in will always have a status of fail or success. If a command such as createKeySpace which does not have any data/info to return was successful then if a return is available from the relevant hector method then that return value will be the "reason" returned. As above the hector method addKeyspace, returns a String, this is what is returned as the reason in the example above.
Our keyspace Testing is now created with the properties specified. If you open the cassandra CLI and execute describe keyspace Testing the output will be :
Keyspace: Testing:

Replication Strategy: org.apache.cassandra.locator.SimpleStrategy

Replication Factor: 3

Column Families:

ColumnFamily: Users

Columns sorted by: org.apache.cassandra.db.marshal.UTF8Type

Row cache size / save period: 456.0/0

Key cache size / save period: 456.0/3600

Memtable thresholds: 0.140625/30/60

GC grace seconds: 300

Compaction min/max thresholds: 100/3432

Read repair chance: 0.7

createKeySpace and help are the only two commands in place at the moment, I've always used the raw thrift interface so development with hector is slightly slower than I would be using thrift while I get used to the hector API. The benefits out weigh the reduced dev. speed however so it'll be worth it.

Configuration

I wanted to be able to configure quite a few things without opening any Java files so a properties file is used to configure a few options. Example:

#increase verbosity i.e print more into to console
verbose=true
#log exceptions to file?
logExceptions=true
#how many files to log to
logFileLimit=1
#max size of each log file
logFileSize=50000
#append to existing log file or empty file ans restart
appendLogs=true
#whether to send stack trace back to client if an excpetion is thrown
connectionDebug=true
#log file
logFile=restish.log
#host to bind to
restAddress=127.0.0.1
#server port
restPort=9989
#cluster name
cluster=MyClusterName
#cassandra port
port=9160
#cassandra IP
hosts[total]=3
hosts[0]=168.344.82.85
hosts[1]=148.344.82.85
hosts[2]=188.344.82.85 


## Benefits





	
  * The first and most obvious benefit is language independence.

	
  * Hector is by far the most mature Cassandra client I know of, it is stable and up to date. Development is continuous and it has a great community, with respected devs.

	
  * Alleviates the need to learn multiple APIs for different clients.

	
  * Reduces the low level interaction that may be needed to use Thrift, if a client isn't available in your preferred language.




## Limitations and drawbacks





	
  * As with anything else, there are limits. There may be performance hits but since its so early no performance tests can be done yet.

	
  * It introduces a single point of failure depending on your setup.

	
  * Data size/speed is limited to how much can be pushed through the socket which in the end comes down to the through put of your network and distance from the server.

	
  * As with any client, you're limited to the operations it supports.


I'm sure there are other benefits and drawbacks but for now...


## Why Hector


Why build on top of hector, why not write a client from scratch using thrift? Thrift is great for low level stuff and doing things that a client may not support, but there's a tonne of reasons why using hector is more sensible. Connection pooling, stability, reliability and the list goes on. Hector provides all these and more. It also means that when bugs start to emerge the knowledgeable community backing hector is available.
Quite frankly it also accelerates development time since most of the low level stuff is abstracted by Hector. So I think it'd be right to say RESTish is a "3rd generation client" for Cassandra, since it builds on top of hector, which builds on top of thrift/avro...


## Download


The source code with current progress is available here [RESTish source](http://crlog.files.wordpress.com/2011/01/restish-logo.jpgwp-content/uploads/2011/01/RESTish-src.rar)...the built version, ready to run can be downloaded from [RESTish binary](http://crlog.files.wordpress.com/2011/01/restish-logo.jpgwp-content/uploads/2011/01/RESTish-bin.rar)...I'll setup a public SVN repo in a few days

Resources used:
Thanks to the [DataStax ( formerly Riptano)](http://www.datastax.com/) guys for the examples at [](https://github.com/zznate/hector-examples)[https://github.com/zznate/hector-examples
](https://github.com/zznate/hector-examples)Without [](https://github.com/rantav/hector)[Hector](https://github.com/rantav/hector), this wouldn't be possible of course @ [](https://github.com/rantav/hector)[https://github.com/rantav/hector ](https://github.com/rantav/hector)
