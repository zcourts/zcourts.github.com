---
author: zcourts
comments: true
date: 2011-06-13 19:44:20+00:00
layout: post
slug: cassandra-query-language-cql-v1-0-0-updated
title: Cassandra Query Language (CQL) v1.0.0 (UPDATED)
wordpress_id: 239
categories:
- Cassandra
- CQL
- NoSQL
tags:
- cassandra
- cassandra cql
- cql
- cql docs
- cql documentation
- cql specification
- specification
---

NOTE: CQL V2 reference is available here [http://crlog.info/2011/09/17/cassandra-query-language-cql-v2-0-reference/](http://crlog.info/2011/09/17/cassandra-query-language-cql-v2-0-reference/)


# Cassandra Query Language (CQL) v1.0.0


This is an update to my previous post documenting the [Cassandra query language CQL](http://crlog.info/2011/03/29/cassandra-query-language-aka-cql-syntax/). A few changes have been made in CQL, the biggest change being the addition of the INSERT keyword. Previously the UPDATE statement would perform an insert if a value did not already exists, the INSERT statement now explicitly does this inserting. BATCH and ALTER TABLE are also now included in the mix, see the official doc here : [https://github.com/apache/cassandra/blob/trunk/doc/cql/CQL.textile](https://github.com/apache/cassandra/blob/trunk/doc/cql/CQL.textile).

If you're new to NoSQL and Cassandra you can read this gentle [Introduction to NoSQL and Apache Cassandra](http://www.scriptandscroll.com/3508/technology/nosql-not-only-sql-introduction-to-apache-cassandra/)
<!-- more -->



	
  1. Cassandra Query Language (CQL) v1.0.0

	
    1. Table of Contents

	
    2. USE

	
    3. SELECT

	
      1. Specifying Columns

	
      2. Column Family

	
      3. Consistency Level

	
      4. Filtering rows

	
      5. Limits




	
    4. ALTER TABLE

	
    5. INSERT

	
    6. UPDATE

	
      1. Column Family

	
      2. Consistency Level

	
      3. Timestamp

	
      4. TTL

	
      5. Specifying Columns and Row




	
    7. DELETE

	
      1. Specifying Columns

	
      2. Column Family

	
      3. Consistency Level




	
    8. BATCH

	
    9. TRUNCATE

	
    10. CREATE KEYSPACE

	
    11. CREATE COLUMNFAMILY

	
      1. Column Family Options




	
    12. CREATE INDEX

	
    13. DROP INDEX

	
    14. DROP

	
    15. Common Idioms




	
  2. Versioning

	
  3. Changes




# Cassandra Query Language (CQL) v1.0.0




## Table of Contents




## USE


_Synopsis:_

    
    <code> USE <KEYSPACE>;</code>


A `USE` statement consists of the `USE` keyword, followed by a valid keyspace name. Its purpose is to assign the per-connection, current working keyspace. All subsequent keyspace-specific actions will be performed in the context of the supplied value.


## SELECT


_Synopsis:_

    
    <code> SELECT [FIRST N] [REVERSED] <SELECT EXPR> FROM <COLUMN FAMILY> [USING <CONSISTENCY>] [WHERE <CLAUSE>] [LIMIT N];</code>


A `SELECT` is used to read one or more records from a Cassandra column family. It returns a result-set of rows, where each row consists of a key and a collection of columns corresponding to the query.


### Specifying Columns



    
    <code> SELECT [FIRST N] [REVERSED] name1, name2, name3 FROM ... SELECT [FIRST N] [REVERSED] name1..nameN FROM ...</code>


The SELECT expression determines which columns will appear in the results and takes the form of either a comma separated list of names, or a range. The range notation consists of a start and end column name separated by two periods (`..`). The set of columns returned for a range is start and end inclusive.

The `FIRST` option accepts an integer argument and can be used to apply a limit to the number of columns returned per row. When this limit is left unset it defaults to 10,000 columns.

The `REVERSED` option causes the sort order of the results to be reversed.

It is worth noting that unlike the projection in a SQL SELECT, there is no guarantee that the results will contain all of the columns specified. This is because Cassandra is schema-less and there are no guarantees that a given column exists.


### Column Family



    
    <code> SELECT ... FROM <COLUMN FAMILY> ...</code>


The `FROM` clause is used to specify the Cassandra column family applicable to a `SELECT` query.


### Consistency Level



    
    <code> SELECT ... [USING <CONSISTENCY>] ...</code>


Following the column family clause is an optional consistency level specification.


### Filtering rows



    
    <code> SELECT ... WHERE KEY = keyname AND name1 = value1 SELECT ... WHERE KEY >= startkey and KEY =< endkey AND name1 = value1 SELECT ... WHERE KEY IN ('<key>', '<key>', '<key>', ...)</code>


The WHERE clause provides for filtering the rows that appear in results. The clause can filter on a key name, or range of keys, and in the case of indexed columns, on column values. Key filters are specified using the `KEY` keyword, a relational operator, (one of `=`, `>`, `>=`, `<`, and `<=`), and a term value. When terms appear on both sides of a relational operator it is assumed the filter applies to an indexed column. With column index filters, the term on the left of the operator is the name, the term on the right is the value to filter _on_.

_Note: The greater-than and less-than operators (`>` and `<`) result in key ranges that are inclusive of the terms. There is no supported notion of “strictly” greater-than or less-than; these operators are merely supported as aliases to `>=` and `<=`._


### Limits



    
    <code> SELECT ... WHERE <CLAUSE> [LIMIT N] ...</code>


Limiting the number of rows returned can be achieved by adding the `LIMIT` option to a `SELECT` expression. `LIMIT` defaults to 10,000 when left unset.


## ALTER TABLE


_Synopsis:_

bc.

ALTER TABLE ADD ;

ALTER TABLE ALTER TYPE;

ALTER TABLE DROP;

An `ALTER` is used to manipulate with ColumnFamily columns. It allows you to add new columns, alter and drop existing columns. No results are returned.


## INSERT


_Synopsis:_

bc.

INSERT INTO (KEY,
,
, …) VALUES (, , , …) [USING CONSISTENCY [AND TIMESTAMP ] [AND TTL]];

An `INSERT` is used to write one or more columns to a record in a Cassandra column family. No results are returned.

`INSERT` works exactly like `UPDATE` so for information about Column Family and Consistency Level arguments please take at the `UPDATE` section.


## UPDATE


_Synopsis:_

    
    <code> UPDATE <COLUMN FAMILY> [USING <CONSISTENCY> [AND TIMESTAMP <timestamp>] [AND TTL <timeToLive>]] SET name1 = value1, name2 = value2 WHERE KEY = keyname;</code>


An `UPDATE` is used to write one or more columns to a record in a Cassandra column family. No results are returned.


### Column Family



    
    <code> UPDATE <COLUMN FAMILY> ...</code>


Statements begin with the `UPDATE` keyword followed by a Cassandra column family name.


### Consistency Level



    
    <code> UPDATE ... [USING <CONSISTENCY>] ...</code>


Following the column family identifier is an optional consistency level specification.


### Timestamp


bc.

UPDATE … [USING TIMESTAMP] …

`UPDATE` supports setting client-supplied optional timestamp for modification.


### TTL


bc.

UPDATE … [USING TTL] …

`UPDATE` supports setting time to live (TTL) for each of the columns in `UPDATE` statement.


### Specifying Columns and Row



    
    <code> UPDATE ... SET name1 = value1, name2 = value2 WHERE KEY = keyname; UPDATE ... SET name1 = value1, name2 = value2 WHERE KEY IN ('<key>', '<key>', ...)</code>


Rows are created or updated by supplying column names and values in term assignment format. Multiple columns can be set by separating the name/value pairs using commas. Each update statement requires exactly one key to be specified using a WHERE clause and the `KEY` keyword.


## DELETE


_Synopsis:_

    
    <code> DELETE [COLUMNS] FROM <COLUMN FAMILY> [USING <CONSISTENCY>] WHERE KEY = keyname1 DELETE [COLUMNS] FROM <COLUMN FAMILY> [USING <CONSISTENCY>] WHERE KEY IN (keyname1, keyname2);</code>


A `DELETE` is used to perform the removal of one or more columns from one or more rows.


### Specifying Columns



    
    <code> DELETE [COLUMNS] ...</code>


Following the `DELETE` keyword is an optional comma-delimited list of column name terms. When no column names are specified, the remove applies to the entire row(s) matched by the WHERE clause


### Column Family



    
    <code> DELETE ... FROM <COLUMN FAMILY> ...</code>


The column family name follows the list of column names.


### Consistency Level



    
    <code> DELETE ... [USING <CONSISTENCY>] ...</code>


Following the column family identifier is an optional consistency level specification.


### Specifying Rows



    
    <code> DELETE ... WHERE KEY = keyname1 DELETE ... WHERE KEY IN (keyname1, keyname2)</code>


The `WHERE` clause is used to determine which row(s) a `DELETE` applies to. The first form allows the specification of a single keyname using the `KEY` keyword and the `=` operator. The second form allows a list of keyname terms to be specified using the `IN` notation and a parenthesized list of comma-delimited keyname terms.


## BATCH


_Synopsis:_

bc.

BATCH BEGIN BATCH [USING CONSISTENCY [AND TIMESTAMP]]

INSERT or UPDATE or DELETE statements separated by semicolon or “end of line”

APPLY BATCH

`BATCH` supports setting client-supplied optional global timestamp which will be used for each of the operations included in batch.

A single consistency level is used for the entire batch, it appears after the `BEGIN BATCH` statement, and uses the standard consistency level specification. Batch default to `CONSISTENCY.ONE` when left unspecified.

_NOTE: While there are no isolation guarantees, `UPDATE` queries are atomic within a give record._

_Example:_

bc.

BEGIN BATCH USING CONSISTENCY QUORUM

INSERT INTO users (KEY, password, name) VALUES (‘user2’, ‘ch@ngem3b’, ‘second user’)

UPDATE users SET password = ‘ps22dhds’ WHERE KEY = ‘user2’

INSERT INTO users (KEY, password) VALUES (‘user3’, ‘ch@ngem3c’)

DELETE name FROM users WHERE key = ‘user2’

INSERT INTO users (KEY, password, name) VALUES (‘user4’, ‘ch@ngem3c’, ‘Andrew’)

APPLY BATCH


## TRUNCATE


_Synopsis:_

    
    <code> TRUNCATE <COLUMN FAMILY></code>


Accepts a single argument for the column family name, and permanently removes all data from said column family.


## CREATE KEYSPACE


_Synopsis:_

    
    <code> CREATE KEYSPACE <NAME> WITH AND strategy_class = <STRATEGY> AND strategy_options.<OPTION> = <VALUE> [AND strategy_options.<OPTION> = <VALUE>];</code>


The `CREATE KEYSPACE` statement creates a new top-level namespace (aka “keyspace”). Valid names are any string constructed of alphanumeric characters and underscores, but must begin with a letter. Properties such as replication strategy and count are specified during creation using the following accepted keyword arguments:
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

<td >Most strategies require additional arguments which can be supplied by appending the option name to the `strategy_options` keyword, separated by a colon (`:`). For example, a strategy option of “DC1” with a value of “1” would be specified as `strategy_options:DC1 = 1`; replication_factor for SimpleStrategy could be `strategy_options:replication_factor=3`.
</td>
</tr>
</tbody>
</table>


## CREATE COLUMNFAMILY


_Synopsis:_

    
    <code> CREATE COLUMNFAMILY <COLUMN FAMILY> (KEY <type> PRIMARY KEY [, name1 type, name2 type, ...]); CREATE COLUMNFAMILY <COLUMN FAMILY> (KEY <type> PRIMARY KEY [, name1 type, name2 type, ...]) [WITH keyword1 = arg1 [AND keyword2 = arg2 [AND ...]]];</code>


`CREATE COLUMNFAMILY` statements create new column family namespaces under the current keyspace. Valid column family names are strings of alphanumeric characters and underscores, which begin with a letter.


### Specifying Key Type



    
    <code> CREATE ... (KEY <type> PRIMARY KEY) ...</code>


When creating a new column family, you must specify key type. The list of possible key types is identical to column comparators/validators, (see [Specifying Column Type](columntypes)). It’s important to note that the key type must be compatible with the partitioner in use, for example `OrderPreservingPartitioner` and `CollatingOrderPreservingPartitioner` both require UTF-8 keys.


### Specifying Column Type (optional)



    
    <code> CREATE ... (KEY <type> PRIMARY KEY, name1 type, name2 type) ...</code>


It is possible to assign columns a type during column family creation. Columns configured with a type are validated accordingly when a write occurs. Column types are specified as a parenthesized, comma-separated list of column term and type pairs. The list of recognized types are:
<table >
<tbody >
<tr >
type
description
</tr>
<tr >

<td >bytea
</td>

<td >Arbitrary bytes (no validation)
</td>
</tr>
<tr >

<td >ascii
</td>

<td >ASCII character string
</td>
</tr>
<tr >

<td >text
</td>

<td >UTF8 encoded string
</td>
</tr>
<tr >

<td >varchar
</td>

<td >UTF8 encoded string
</td>
</tr>
<tr >

<td >uuid
</td>

<td >Type 1, or type 4 UUID
</td>
</tr>
<tr >

<td >varint
</td>

<td >Arbitrary-precision integer
</td>
</tr>
<tr >

<td >int
</td>

<td >8-byte long (same as bigint)
</td>
</tr>
<tr >

<td >bigint
</td>

<td >8-byte long
</td>
</tr>
</tbody>
</table>
_Note: In addition to the recognized types listed above, it is also possible to supply a string containing the name of a class (a sub-class of `AbstractType`), either fully qualified, or relative to the `org.apache.cassandra.db.marshal` package._


### Column Family Options (optional)



    
    <code> CREATE COLUMNFAMILY ... WITH keyword1 = arg1 AND keyword2 = arg2;</code>


A number of optional keyword arguments can be supplied to control the configuration of a new column family.
<table >
<tbody >
<tr >
keyword
default
description
</tr>
<tr >

<td >comparator
</td>

<td >text
</td>

<td >Determines sorting and validation of column names. Valid values are identical to the types listed in Specifying Column Type above.
</td>
</tr>
<tr >

<td >comment
</td>

<td >none
</td>

<td >A free-form, human-readable comment.
</td>
</tr>
<tr >

<td >row_cache_size
</td>

<td >0
</td>

<td >Number of rows whose entire contents to cache in memory.
</td>
</tr>
<tr >

<td >key_cache_size
</td>

<td >200000
</td>

<td >Number of keys per SSTable whose locations are kept in memory in “mostly LRU” order.
</td>
</tr>
<tr >

<td >read_repair_chance
</td>

<td >1.0
</td>

<td >The probability with which read repairs should be invoked on non-quorum reads.
</td>
</tr>
<tr >

<td >gc_grace_seconds
</td>

<td >864000
</td>

<td >Time to wait before garbage collecting tombstones (deletion markers).
</td>
</tr>
<tr >

<td >default_validation
</td>

<td >text
</td>

<td >Determines validation of column values. Valid values are identical to the types listed in Specifying Column Type above.
</td>
</tr>
<tr >

<td >min_compaction_threshold
</td>

<td >4
</td>

<td >Minimum number of SSTables needed to start a minor compaction.
</td>
</tr>
<tr >

<td >max_compaction_threshold
</td>

<td >32
</td>

<td >Maximum number of SSTables allowed before a minor compaction is forced.
</td>
</tr>
<tr >

<td >row_cache_save_period_in_seconds
</td>

<td >0
</td>

<td >Number of seconds between saving row caches.
</td>
</tr>
<tr >

<td >key_cache_save_period_in_seconds
</td>

<td >14400
</td>

<td >Number of seconds between saving key caches.
</td>
</tr>
<tr >

<td >memtable_flush_after_mins
</td>

<td >60
</td>

<td >Maximum time to leave a dirty table unflushed.
</td>
</tr>
<tr >

<td >memtable_throughput_in_mb
</td>

<td >dynamic
</td>

<td >Maximum size of the memtable before it is flushed.
</td>
</tr>
<tr >

<td >memtable_operations_in_millions
</td>

<td >dynamic
</td>

<td >Number of operations in millions before the memtable is flushed.
</td>
</tr>
<tr >

<td >replicate_on_write
</td>

<td >false
</td>

<td >
</td>
</tr>
</tbody>
</table>


## CREATE INDEX


_Synopsis:_

    
    <code>CREATE INDEX [index_name] ON <column_family> (column_name);</code>


A `CREATE INDEX` statement is used to create a new, automatic secondary index for the named column.


## DROP INDEX


_Synopsis:_

    
    <code>DROP INDEX <INDEX_NAME></code>


A `DROP INDEX` statement is used to drop an existing secondary index.

DROP INDEX statement will search all ColumnFamilies in the current Keyspace for specified index and delete it if found.


## DROP


_Synopsis:_

    
    <code>DROP <KEYSPACE|COLUMNFAMILY> namespace;</code>


`DROP` statements result in the immediate, irreversible removal of keyspace and column family namespaces.


## Common Idioms




### Specifying Consistency



    
    <code> ... USING <CONSISTENCY> ...</code>


Consistency level specifications are made up the keyword `USING`, followed by a consistency level identifier. Valid consistency levels are as follows:



	
  * `CONSISTENCY ANY`

	
  * `CONSISTENCY ONE` (default)

	
  * `CONSISTENCY QUORUM`

	
  * `CONSISTENCY ALL`

	
  * `CONSISTENCY LOCAL_QUORUM`

	
  * `CONSISTENCY EACH_QUORUM`




### Term specification


Terms are used in statements to specify things such as keyspaces, column families, indexes, column names and values, and keyword arguments. The rules governing term specification are as follows:



	
  * Any single quoted string literal (example: `'apple'`).

	
  * Unquoted alpha-numeric strings that begin with a letter (example: `carrot`).

	
  * Unquoted numeric literals (example: `100`).

	
  * UUID strings in hyphen-delimited hex notation (example: `1438fc5c-4ff6-11e0-b97f-0026c650d722`).


Terms which do not conform to these rules result in an exception.

How column name/value terms are interpreted is determined by the configured type.
<table >
<tbody >
<tr >
type
term
</tr>
<tr >

<td >ascii
</td>

<td >Any string which can be decoded using ASCII charset
</td>
</tr>
<tr >

<td >text / varchar
</td>

<td >Any string which can be decoded using UTF8 charset
</td>
</tr>
<tr >

<td >uuid
</td>

<td >Standard UUID string format (hyphen-delimited hex notation)
</td>
</tr>
<tr >

<td >uuid
</td>

<td >Standard UUID string format (hyphen-delimited hex notation)
</td>
</tr>
<tr >

<td >uuid
</td>

<td >The string `now`, to represent a type-1 (time-based) UUID with a date-time component based on the current time
</td>
</tr>
<tr >

<td >uuid
</td>

<td >Numeric value representing milliseconds since epoch
</td>
</tr>
<tr >

<td >uuid
</td>

<td >An [iso8601 timestamp](http://en.wikipedia.org/wiki/8601)
</td>
</tr>
<tr >

<td >int
</td>

<td >Integer value capable of fitting in 8 bytes (same as bigint)
</td>
</tr>
<tr >

<td >bigint
</td>

<td >Integer value capable of fitting in 8 bytes
</td>
</tr>
<tr >

<td >varint
</td>

<td >Integer value of arbitrary size
</td>
</tr>
<tr >

<td >bytea
</td>

<td >Hex-encoded strings (converted directly to the corresponding bytes)
</td>
</tr>
</tbody>
</table>


# Versioning


Versioning of the CQL language adheres to the [Semantic Versioning](http://semver.org) guidelines. Versions take the form X.Y.Z where X, Y, and Z are integer values representing major, minor, and patch level respectively. There is no correlation between Cassandra release versions and the CQL language version.
<table >
<tbody >
<tr >
version
description
</tr>
<tr >

<td >Patch
</td>

<td >The patch version is incremented when bugs are fixed.
</td>
</tr>
<tr >

<td >Minor
</td>

<td >Minor version increments occur when new, but backward compatible, functionality is introduced.
</td>
</tr>
<tr >

<td >Major
</td>

<td >The major version _must_ be bumped when backward incompatible changes are introduced. This should rarely (if ever) occur.
</td>
</tr>
</tbody>
</table>


# Changes



    
    Tue, 22 Mar 2011 18:10:28 -0700 - Eric Evans <eevans@rackspace.com>
     * Initial version, 1.0.0
