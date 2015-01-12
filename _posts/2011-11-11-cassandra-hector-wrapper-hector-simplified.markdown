---
author: zcourts
comments: true
date: 2011-11-11 22:31:44+00:00
layout: post
slug: cassandra-hector-wrapper-hector-simplified
title: Cassandra Hector Wrapper - Hector Simplified
wordpress_id: 381
categories:
- Cassandra
- Cassandra Hector Wrapper
- High Performance
- Java
- NoSQL
tags:
- API
- beginner
- cassandra
- cassandra client
- hector
- simple
- wrapper
---








This a simple wrapper I wrote for Hector.
-----------------------------------------
Available at : [https://github.com/zcourts/cassandra-hector-wrapper](https://github.com/zcourts/cassandra-hector-wrapper)

It doesn't support all the features of Hector...that's sort of the point but not. The main point was to get something quick and simple.
I did this on the train over 3/4 mornings while heading to work. I wanted it to not have anything too complex or low level.
In effect I hope that even a new Cassandra user could just download a copy and start using it without the need to
fully understand all of Cassandra's concepts. 
I'll review it and make some needed changes however it does currently work fine. I noticed after pushing to github that
I'm not check if Hector returns null, which generally means whatever was requested couldn't be found or an error occured
or something or the other.

Usage is similar to Hector's see [https://github.com/rantav/hector](https://github.com/rantav/hector) if you want to use Hector directly.
See the file [https://github.com/zcourts/cassandra-hector-wrapper/blob/master/src/main/java/com/scriptandscroll/adt/UsageExamples.java](https://github.com/zcourts/cassandra-hector-wrapper/blob/master/src/main/java/com/scriptandscroll/adt/UsageExamples.java)
for a decent set of usage examples.

You start by creating a Keyspace object.

    
    
    Keyspace ks=new Keyspace("clusterName", "keyspaceName", "localhost:9160") ;
    
    //then a column or super column family object
    ColumnFamily cf= new ColumnFamily(ks,"columnFamilyName);
    
    //now the magic happens, you simple do cf.get[column|columns|row,rows]
    Row row= cf.Row getRow("rowKey", "startColumn", "endColumn");
    
    //you can now do
    Column col = row.getColumn("columnName");
    //then
    String val= col.getValue();
    //  OR .....
    String val2=row.getColumnValue("columnName");
    //OR
    Iterator<Column> it=row.iterator();
    while(it.hasNext()){
      Column c = it.next();
      //do whatever
    }
    


Thats it!

Its important to note that I didn't write this because the Hector client was lacking in anyway at all.
Quite the opposite in fact. The guys working on hector have done an awesome job and myself and I'm sure others
appreciate it. However when I was working on updating a project recently it was taking me far too much time to sift
through the hector docs and get familiar with all the changes etc. I started with a single file but that quickly got too nasty
and I just stopped, drew out some ideas and it turned out into all the classes currently in the project.









[https://github.com/zcourts/cassandra-hector-wrapper/blob/master/src/main/java/com/scriptandscroll/adt/UsageExamples.java](https://github.com/zcourts/cassandra-hector-wrapper/blob/master/src/main/java/com/scriptandscroll/adt/UsageExamples.java)

[code lang="Java"]
package com.scriptandscroll.adt;

import java.util.ArrayList;
import java.util.List;

/**
 *Shows basic usage of the classes.
 * It firstly makes no provision to allow you to create keyspaces or column families, YET!
 * But once those are created from the CLI or some other way it provides a way to deal with
 * just about everything
 * @author Courtney Robinson <courtney@crlog.info>
 */
public class UsageExamples {

	public static void main(String[] args) {
		Keyspace ks = new Keyspace("clusterName", "keyspaceName", "localhost:9160");
		//Standard column family examples
		//create a column family object - THIS DOES NOT CREATE A COLUMN FAMILY IN CASSANDRA but assumes one with the given name already exists!
		ColumnFamily cf = new ColumnFamily(ks, "cfName");
		//now we can perform actions on this column family.
		//
		//first lets get a single column
		Column col = cf.getColumn("rowkey1", "columnName");
		//now we can use its value or name using
		col.getName();//returns a string
		//or
		col.getValue();//returns a string
		//
		//
		//we can get a set of columns from a row in three ways, by giving a startand end column name
		List<Column> cols = cf.getColumns("rowkey2", "startCol", "endCol");
		//by giving start and end col names and specifying a max amount of cols to get
		List<Column> cols2 = cf.getColumns("rowke2", "startCol", "endCol", false, 5);
		//or by giving an array of all columns to get
		//in this case it will only return the given columns
		List<Column> cols3 = cf.getColumns("rowkey2", new String[]{"col1", "col2", "col3", "col4"});
		//
		//We can also get rows within a CF
		//by setting start and end column names to an empty string and not setting a max value
		//we can get all the columns within the given row
		//the same options as getColumns apply, you specify columns by start and end key with an optional max amount or an array of columns
		Row row = cf.getRow("rowkey", "", "");
		//you can now do cool stuff with this row object like add and remove columns.
		//if you later pass this object to a column family it will apply those changes in Cassandra e.g.
		row.putColumn("newColName", "newColValue");
		//or
		row.putColumn(new Column("newerColName", "newerColValue"));
		//while we're at it we can remove columns from this row
		row.removeColumn(col);
		//or
		row.removeColumn("colName");
		//if we now write this row back to the column family all those changes are applied
		cf.putRow(row);//that's it! two new columns will be added, and two removed
		//we coould do
		//setting false stops it removing columns from cassandra that were removed from the object
		//columns that were added are still added obviously...
		cf.putRow(row, false);
		//we can also get multiple rows like this
		//setting start and end row keys and column names to empty gets everything
		//but we set the max rows to return as 20 and the max columns per row to 5
		//so up to 20 rows are returned which will contain up to 5 columns
		//there are multiple variations on these methods that allows various operations
		List<Row> rows = cf.getRows("", "", "", "", false, 20, 5);
		//Simple? Good! That is the aim!

		//Lukily Super column family operations work in a similar manner
		SuperColumnFamily scf = new SuperColumnFamily(ks, "superCFName");
		//now go through the same thing again...
		SuperColumn scol = scf.getSuperColumn("rowkey", "supercolName");
		//get sub columns of this super column
		List<Column> subCols = scol.getAllColumns();
		//or get multiple super columns
		List<SuperColumn> scol2 = scf.getSuperColumns("rowkey", new String[]{"superCol1", "superCol2", "superCol3"});

		//get a single sub column
		Column subCol = scf.getSubColumn("rowket", "superColname", "subcolname");
		List<Column> subCols2 = scf.getSubColumns("rowkey", "superCol", "startSubcol", "endSubCol");

		//we can get sub columns from multiple rows
		List<String> keys = new ArrayList<String>();
		keys.add("key1");
		keys.add("key2");
		keys.add("key3");
		keys.add("key4");
		keys.add("key5");
		//gets a list of rows with the sub columns requested
		List<Row> rowSubCols = scf.getSubColumnsFromMultipleRows(keys, "superColumn", "startSubCol", "endSubCol", false, 20);
		//get an entire super row
		SuperRow srow = scf.getSuperRow("rowkey", "startColumn", "endCol");
		SuperColumn sc = srow.getSuperColumn("superCol");//now do what we want
		List<SuperRow> lsuperRows = scf.getSuperRows(keys, "startCol", "endCol");
		//get up to 20 rows
		List<SuperRow> srows2 = scf.getSuperRows("startKey", "endKey", new String[]{}, 20);

		//we can also add and remove from a super row just as we did with a normal row
		ArrayList<Column> cols5 = new ArrayList();
		cols5.add(new Column("subname", "subval"));

		srow.putSuperColumn(new SuperColumn("colname", cols5));
		//and now
		scf.putSuperRow(srow);
		//all done...
		//still simple?
	}
}
[/code]

On its own this would all mean nothing so again, a big thank you to the [Hector guys](http://hector-client.org).

If you can think of a better name then by all means, please say. Any comments, suggestions or general thoughts on it are most welcomed.
