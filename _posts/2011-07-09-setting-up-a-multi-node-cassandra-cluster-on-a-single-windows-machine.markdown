---
author: zcourts
comments: true
date: 2011-07-09 00:01:53+00:00
layout: post
slug: setting-up-a-multi-node-cassandra-cluster-on-a-single-windows-machine
title: Setting up a multi-node Cassandra cluster on a single Windows machine
wordpress_id: 319
categories:
- Apache
- Cassandra
- Distributed Systems
- NoSQL
tags:
- 127.0.0.1
- alias
- cassandra
- cluser
- hosts
- local cluster
- localhost
- node
- setup
- windows
---

In Windows explorer, go to "C:\Windows\System32\drivers\etc"
Copy the file called "hosts" to your desktop ( or any editable location)
Open the hosts file from the desktop and add the following to the end of the file:

    
    #cassandra nodes
    127.0.0.1               127.0.0.2
    127.0.0.1               127.0.0.3
    127.0.0.1               127.0.0.4
    127.0.0.1               127.0.0.5
    127.0.0.1               127.0.0.6


<!-- more -->Each line represents a node in your cluster to be.You can replace 127.0.0.1...6
with any host name you desire such as node1,node2, etc... it should* still work
Next, re-name the hosts file in "C:\Windows\System32\drivers\etc" to hosts.bak i.e
"C:\Windows\System32\drivers\etc\hosts.bak". You may need admin permission to do this.
Now copy the modified hosts file from your desktop (or wherever you copied it to) to
"C:\Windows\System32\drivers\etc". If you have a web server running you can access it by typing,
any of the nodes you entered i.e 127.0.0.2 for e.g.
Download the latest version of [Cassandra](http://cassandra.apache.org) from the [Cassandra download page](http://cassandra.apache.org/download/).
Now, there are several ways you could do this part but the method I use presents far fewer problems later on.
Create a folder at the root of your drive called cassandra, i.e "C:\cassandra", and in the cassandra folder, create
6 folders named 1 to 6(or however many nodes you want).
You should now have a folder structure looking like this:

    
    C:\cassandra
                \1
                \2
                \3
                \4
                \5
                \6


Extract the files from the cassandra download once into each sub-directory.
i.e put the cassandra files/folders (bin,conf,interface,lib,javadoc, etc) in each folder (1...6)
Starting with the folder named "1", open cassandra.yaml file for editing. i.e. Open

    
    "C:\cassandra\1\conf\cassandra.yaml"


.
Give the cluster name a meaningful value :

    
    cluster_name: 'Awesomeness'


We want to make the first and second node seed nodes so ensure that auto_bootstrap is
false for these two but true for the others

    
    auto_bootstrap: false


Provide the seed nodes for each cassandra.yaml file as 127.0.0.1 and 127.0.0.2

    
    seed_provider:
        # Addresses of hosts that are deemed contact points.
        # Cassandra nodes use this list of hosts to find each other and learn
        # the topology of the ring.  You must change this if you are running
        # multiple nodes!
        - class_name: org.apache.cassandra.locator.SimpleSeedProvider
          parameters:
              # seeds is actually a comma-delimited list of addresses.
              # Ex: "<ip1>,<ip2>,<ip3>"
              - seeds: "127.0.0.1,127.0.0.2"


**IMPORTANT**: You need to ensure that the following values are changed for each node:
# directories where Cassandra should store data on disk.

    
    data_file_directories:
        - /cassandra/1/var/lib/cassandra/data
    
    # commit log
    commitlog_directory: /cassandra/1/var/lib/cassandra/commitlog
    
    # saved caches
    saved_caches_directory: /cassandra/1/var/lib/cassandra/saved_caches


Notice the "/cassandra/**1**/var/lib/", this path changes to "/cassandra/**2**/var/lib/". Its important each tell each node to
use a different location to store its data.
Finally make the following changes to the first file:

    
    listen_address: 127.0.0.1
    rpc_address: 127.0.0.1


Once that's done, save the cassandra.yaml file. Copy the edited file into the conf folder of the other nodes
(make any other tweaks you like to the configuration) .
Edit each cassandra.yaml file as described above making sure you change the path and the host as well as the boot strap
option.
So in the end yor configuration will be similar to:

    
    Node 1 = 127.0.0.1 
    Node 2 = 127.0.0.2
    Node 3 = 127.0.0.3
    Node 4 = 127.0.0.4
    Node 5 = 127.0.0.5
    Node 6 = 127.0.0.6


**IMPORTANT:** Go into each node's bin directory and edit cassandra.bat file, for each node change the line that says "-Dcom.sun.management.jmxremote.port=7199^" changing the 7199 to a unique number. This is the JMX port that allows you to connect to your cluster using nodetool or JConsole each node needs to have their own port so each bat file must be edited and have a unique port set.
Once you have edited cassandra.bat go to each of your bin folders and double click cassandra.bat to start each node.
It will show the standard output and as your nodes join the cluster the existing node should have an output similar to: 

    
    Starting Cassandra Server
     INFO 00:31:45,810 Logging initialized
     INFO 00:31:45,829 JVM vendor/version: Java HotSpot(TM) Client VM/1.6.0_26
     INFO 00:31:45,830 Heap size: 1070399488/1070399488
     INFO 00:31:45,832 JNA not found. Native methods will be disabled.
     INFO 00:31:45,847 Loading settings from file:/C:/cassandra/6/conf/cassandra.yaml
     INFO 00:31:46,001 DiskAccessMode 'auto' determined to be standard, indexAccessMode is standard
     INFO 00:31:46,194 Global memtable threshold is enabled at 340MB
     INFO 00:31:46,196 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,205 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,207 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,209 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,212 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,235 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,342 Opening \cassandra\6\var\lib\cassandra\data\system\LocationInfo-g-5
     INFO 00:31:46,417 Couldn't detect any schema definitions in local storage.
     INFO 00:31:46,419 Found table data in data directories. Consider using the CLI to define your schema.
     INFO 00:31:46,422 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,423 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,424 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,425 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,426 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,427 Removing compacted SSTable files (see http://wiki.apache.org/cassandra/MemtableSSTable)
     INFO 00:31:46,441 Creating new commitlog segment /cassandra/6/var/lib/cassandra/commitlog\CommitLog-1310167906441.log
     INFO 00:31:46,456 Replaying \cassandra\6\var\lib\cassandra\commitlog\CommitLog-1310166938103.log
     INFO 00:31:46,506 Finished reading \cassandra\6\var\lib\cassandra\commitlog\CommitLog-1310166938103.log
     INFO 00:31:46,507 Log replay complete, 0 replayed mutations
     INFO 00:31:46,513 Cassandra version: 2011-06-24_17-00-57
     INFO 00:31:46,514 Thrift API version: 19.10.0
     INFO 00:31:46,514 Loading persisted ring state
     INFO 00:31:46,519 Starting up server gossip
     INFO 00:31:46,534 Enqueuing flush of Memtable-LocationInfo@24118161(29/36 serialized/live bytes, 1 ops)
     INFO 00:31:46,536 Writing Memtable-LocationInfo@24118161(29/36 serialized/live bytes, 1 ops)
     INFO 00:31:46,752 Completed flushing \cassandra\6\var\lib\cassandra\data\system\LocationInfo-g-6-Data.db (80 bytes)
     INFO 00:31:46,786 Starting Messaging Service on port 7000
     INFO 00:31:46,803 Using saved token 102593982436182981303623068613937633300
     INFO 00:31:46,805 Enqueuing flush of Memtable-LocationInfo@6530849(53/66 serialized/live bytes, 2 ops)
     INFO 00:31:46,805 Writing Memtable-LocationInfo@6530849(53/66 serialized/live bytes, 2 ops)
     INFO 00:31:47,016 Completed flushing \cassandra\6\var\lib\cassandra\data\system\LocationInfo-g-7-Data.db (163 bytes)
     INFO 00:31:47,028 Will not load MX4J, mx4j-tools.jar is not in the classpath
     INFO 00:31:47,088 Binding thrift service to /127.0.0.6:9160
     INFO 00:31:47,093 Using TFastFramedTransport with a max frame size of 15728640 bytes.
     INFO 00:31:47,097 Listening for thrift clients...
    <span style="color:#ff0000;"> INFO 00:38:04,061 Node /127.0.0.1 is now part of the cluster INFO 00:38:04,062 InetAddress /127.0.0.1 is now UP INFO 00:38:04,066 Node /127.0.0.3 is now part of the cluster INFO 00:38:04,067 InetAddress /127.0.0.3 is now UP INFO 00:38:04,068 Node /127.0.0.4 is now part of the cluster INFO 00:38:04,069 InetAddress /127.0.0.4 is now UP INFO 00:38:04,071 Node /127.0.0.5 is now part of the cluster INFO 00:38:04,073 InetAddress /127.0.0.5 is now UP</span>


Notice the sections highlighted in red above. To further verify it all open the windows command line and type:

    
    cd C:\cassandra\1\bin
    C:\cassandra\1\bin>nodetool -h 127.0.0.1 -p 7199 ring
    Starting NodeTool
    Address         DC          Rack        Status State   Load            Owns    Token
                                                                                   168491748725623446302120781415458496600
    127.0.0.4       datacenter1 rack1       Up     Normal  15.21 KB        7.68%   11425225278660601160740228674692519427
    127.0.0.1       datacenter1 rack1       Up     Normal  6.54 KB         7.84%   24758542403423023699811268504211696378
    127.0.0.6       datacenter1 rack1       Up     Normal  15.21 KB        45.75%  102593982436182981303623068613937633300
    127.0.0.3       datacenter1 rack1       Up     Normal  15.21 KB        14.36%  127025561568971490267469092579669239579
    127.0.0.5       datacenter1 rack1       Up     Normal  15.21 KB        24.37%  168491748725623446302120781415458496600


That actually shows 5 of my nodes instead of 6...I think I forgot to start one somehow. Anyway, you get the point.

Hope this has been helpful, it can be tricky if you don't get it all right but just ask in the comments and I'll do what I can to help.
PS: Just to be clear, you'd only do this for lowly testing purposes. In fact its not a very good idea to be testing anything aside from some examples with a setup like this...IT IS NOT FOR PRODUCTION, you've been warned!
