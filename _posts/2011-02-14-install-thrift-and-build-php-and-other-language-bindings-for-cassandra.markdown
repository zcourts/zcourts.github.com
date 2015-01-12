---
author: zcourts
comments: true
date: 2011-02-14 09:00:14+00:00
layout: post
slug: install-thrift-and-build-php-and-other-language-bindings-for-cassandra
title: Install thrift and build PHP (and other language) bindings for Cassandra
wordpress_id: 59
categories:
- Cassandra
- NoSQL
- PHP
---

# Install thrift and build PHP bindings for Cassandra


This guide should work for 0.7+ versions of Cassandra. Other versions may need tweaking here and there but the general path should be similar. Lets begin...

Install thrift dependencies

[code lang="“sh”"]
 yum install automake libtool flex bison pkgconfig gcc-c++ boost-devel libevent-devel zlib-devel python-devel ruby-devel
 [/code]

Download thrift

[code lang="sh"]
 wget http://mirrors.enquira.co.uk/apache/incubator/thrift/0.5.0-incubating/thrift-0.5.0.tar.gz
extract

tar –xvf  thrift-0.5.0.tar.gz

cd  thrift-0.5.0

./configure

make && make install
 [/code]

Once its all completed you should now be able to run thrift, test it by typing:

thrift

and you should get an output telling you a bunch of options are available. If not something went wrong when you were installing and you need to try and find where the error occurred and fix it.

Now lets download Cassandra’s source so that we can get the thrift file from it:

[code lang="sh"]
 wget  http://mirror.fubra.com/ftp.apache.org/cassandra/0.7.0/apache-cassandra-0.7.0-src.tar.gz

tar -xvf apache-cassandra-0.7.0-src.tar.gz
 cd apache-cassandra-0.7.0-src/interface
 [/code]

You should see some files listed, the one we’re interested in is cassandra.thrift ...

Now we can generate the thrift bindings for any of the supported languages:

[code lang="sh"]
 #thrift --gen XYZ cassandra.thrift
 [/code]

Where xyz is the language you need, so for PHP it would be:

[code lang="sh"]
 thrift --gen php cassandra.thrift
 [/code]

You will now have a gen-php folder in the directory, it contains the subdirectory for Cassandra and finally the php files. The files cassandra_constants.php, Cassandra.php  and cassandra_types.php should have been generated.

Lets copy the generate files to our website include path for use later.

[code lang="sh"]
 cd gen-php
 tar –cvf cassandra.php.tar
 #now copy or move (mv) the archive to your website’s include path
 #cp cassandra.php.tar /home/username/websiteRoot/includes/thrift

[/code]

You can now include these files in your PHP program. There are additional files that you need to find and include. One such file is Thrift.php, depending on the system you’re running the location may be different.

On my Centos distro, it is located in /usr/lib/php/ - along with the folders “protocol” and “transport” and a second file, “autoload.php”

If you open the Cassandra.php file from earlier, you’ll notice it is including files from “thrift_root” or similar. These files are the ones you need to copy to wherever you want you thrift root location to be. Since I only have the thrift files in /usr/lib/php I’m going to tar this folder and copy it to a location where I want to include files from. If that directory contains files not belonging to thrift then only copy Thrift.php, protocol and transport.

[code lang="sh"]
 #create an archive of the required files
 cd /usr/lib/php/
 tar  -cvf  thrift.php.tar *
 #now copy or move (mv) the archive to your website’s include path
 #cp thrift.php.tar /home/username/websiteRoot/includes/thrift
 [/code]

We now have the Cassandra PHP bindings as well as the required PHP thrift files.
extract the files from the tar archives and put them all in the folder thrift (or whichever you want).

Cassandra.php,Cassandra_constants.php and Cassandra_types.php includes the thrift php files in the following manner:

[code lang="php"]
 include_once $GLOBALS['THRIFT_ROOT'].'/Thrift.php';
 [/code]

You need to therefore set THRIFT_ROOT in your PHP file like this:

[code lang="php"]
 $GLOBALS['THRIFT_ROOT'] = '/home/username/websiteRoot/includes/thrift';

//where /home/username/websiteRoot/includes/thrift is the location of Thrift.php
 [/code]

You’re now ready to test it all out. The example at  [http://wiki.apache.org/cassandra/ThriftExamples#PHP](http://wiki.apache.org/cassandra/ThriftExamples#PHP)

Should work nicely. In a future tutorial, I’ll write some PHP examples using thrift.

You may also download the files I generated for 0.7 while doing this tutorial:
PHP bindings
[http://www.crlog.info/wp-content/uploads/2011/02/phpBindings.tar](http://www.crlog.info/wp-content/uploads/2011/02/phpBindings.tar)

[](http://www.crlog.info/wp-content/uploads/2011/02/phpBindings.tar)Thirft files

[http://www.crlog.info/wp-content/uploads/2011/02/thrift.php_.tar](http://www.crlog.info/wp-content/uploads/2011/02/thrift.php_.tar)
