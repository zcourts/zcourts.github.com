---
author: zcourts
comments: true
date: 2011-04-07 12:59:41+00:00
layout: post
slug: apache-cassandra-phpcassa-code-igniter-large-scale-php-app-in-5-minutes
title: Apache Cassandra + PHPcassa + Code Igniter = large scale PHP app in 5 minutes
wordpress_id: 205
categories:
- Cassandra
- NoSQL
- PHP
tags:
- apache
- apache cassandra
- cassandra
- ci
- code
- codeigniter
- custom code igniter database
- igniter
- integration
- library
- nosql
---

I'm working on a new project, migrating an existing site using custom code with a very monolithic design on top of [MySQL](http://www.mysql.com/).

Design goals : Implement all the same functionality using a manageable framework with a small footprint on a distributed NoSQL database.
Small footprint? I'm thinking [Code Igniter](http://codeigniter.com/) (CI)... Distributed NoSQL (my favorite part)? I'm thinking [Apache Cassandra](http://cassandra.apache.org)!!!
First problem...issue, whatever you want to call it. CI is built with SQL DB tied in fairly tightly. How do I separate the two without hacking the CI core and allow me to have the flexibility of upgrading CI in the future? And at the same time being able to integrate Cassandra tightly enough to not make it stand out like <del>a penguin in Africa </del> sore thumb?

Enough with the questions, I'm very new to CI so this took me about an hour to make it happen. The idea is, CI provides a $this->db object when "database" is one of the auto loaded options. I want to still have this db instance available but providing  methods to access Cassandra. I also want this to be auto loaded and available in all controllers... So how?<!-- more -->

PHPCassa is probably one of the best PHP client libraries available for Cassandra so the choice on library was about 20 seconds. Since I wasn't going to use raw thrift calls, this choice was even easier.

Get started then:
Create a file, in your application/config folder, name it cassandra.php i.e. application/config/cassandra.php
In that file add the following:

```php
<?php
$servers[0] = array('host' => '192.168.2.6', 'port' => 9160);
$servers[1] = array('host' => '192.168.2.7', 'port' => 9160);
$servers[3] = array('host' => '192.168.2.8', 'port' => 9160);
$config['cassandra_servers'] = $servers;
$config['keyspace'] = "Keyspace1";
$config['default_cf'] = "Standard1";
```

The servers array should be obvious, its a list of servers you want to have available for your connection
pooling stuff. It'll later be accessible using:

```php
$this->CI->config->item('cassandra_servers')
```

The next config option is the Keyspace your application will use, this allows you to specify only a single Keyspace
since, ideally an application would only use one of these. This is later accessible through:

```php
$this->CI->config->item('keyspace')
```

The final option is a default column family. This column family is the one that will be available when CI initialises
the database object, db.Later available using:

```php
$this->CI->config->item('default_cf')
```

That's it for the configuration file... Next up, our Cassandra library or libraries should I say...
At this point its important to say that if you have database being auto loaded then the following may
not be what you want to do.
In application/libraries create a file called db.php i.e. application/libraries/db.php

```php
<?php

require_once('phpcassa/connection.php');
require_once('phpcassa/columnfamily.php');

/**
 * @author Courtney
 */
class Db {

    private $CI;
//    public $db;
    private $conn;
    /**
     * @var ColumnFamily
     */
    private $cf;

    /**
     * Init connection for the database using the settings in the cassandra.php
     * config file...
     */
    public function __construct() {
        $this->CI = & get_instance();
        try {
            $this->conn = new Connection($this->CI->config->item('keyspace'),
                            $this->CI->config->item('cassandra_servers'));
        } catch (Exception $e) {
            show_error( $e->getMessage());
        }
        $this->cf = $this->CI->config->item('default_cf');
//        $this->db = $this;
    }

    /**
     * Creates a new instance of the given CF which will be returned
     * for interaction by <code>cf()</code>
     * @param string $cf The column family to interact with
     */
    public function setCF($cf) {
        $this->cf = new ColumnFamily($this->conn, $cf);
    }

    /**
     * Returns the instance of the last column family created by
     * calling <code>setCF()</code>... If setCF hasn't been called
     * then the default_cf set in cassandra.php config file is returned,
     * once setCF is called then the last one to be set is always returned.
     * @return ColumnFamily
     */
    public function cf() {
        return $this->cf;
    }

}
```

This approach is the most simplistic I could think of for this blog post, ideally you'd want to cache
the Column family objects you create so that a new instance isn't created every time you use a different CF.
There will is a basic caching version implemented on the github page hosting this project's files... available here
[https://github.com/zcourts/cassandraci](https://github.com/zcourts/cassandraci)
Its important to name the file db.php if you want to be able to access the database instance using $this->db as you
would if it was the native CI MySQL object. That purely because CI automatically creates an instance of your library
using the name of the file or class (Not sure but file =db.php class =Db.php so...)
The next important step, download phpcassa... Its available here [https://github.com/thobbs/phpcassa](https://github.com/thobbs/phpcassa)
Extract its contents and put its files into application/libraries/phpcassa, the structure needs to be in the form
to allow db.php to include "phpcassa/ColumnFamily.php"; etc... You only need the .php files from php cassa and
everything in the Thrift folder, docs and test folder aren't used so they can be left out.

Next you need to change your autoload.php file
the settings need to look like:

```php
$autoload['libraries'] = array('db','otherlib');
```

Unless I've forgotten something, that should be it...
Now in any of your controllers or files where autoloaded libraries are available, you can use
$this->db-cf()->phpCassaMethod();  to access Cassandra.
Feel free to ask any questions...comment suggestions are all welcome.
