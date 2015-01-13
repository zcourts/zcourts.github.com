---
author: zcourts
comments: true
date: 2011-01-12 02:29:00+00:00
layout: post
slug: java-multimap-or-multivalue-map
title: Java MultiMap or MultiValue Map
wordpress_id: 11
categories:
- Java
- Programming
---

In my recent course work I found the need for wanting to have a key value type object which maps one key to multiple values.

This could be easily accomplished in Java using a HashMap and a list or set. Doing HashMap would be very nice if you knew all the values you wanted to have mapped to the same key. Unfortunately, my use case wasn't that simple. And it wouldn't be very practical to manually maintain a reference to a list for each key.

I had to build a plugin framework in Java which allowed plugins to "register" for events. Multiple plugins could register for the same event and once that event had been queued for processing, all the handlers registered to listen for that event had to be notified.

A plugin could register and unregister which means the list of items to map an event to had to be dynamic, i.e must be able to add and remove items that a key points to. I came up with a solution as shown below, which worked out very nicely.
```java
package utils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;

/**
*
* @author Courtney
*/
public class MultiValue implements Cloneable, Serializable {


/**
* Keys stored as key:valueID
*/
private HashMap keys = new HashMap();
private HashMap> values = new HashMap>();


/**
* Adds a new value for the specified key
* @param key the key for the current value
* @param value the value to associate with this key
*/
public void put(K key, V value) {
ArrayList vals = new ArrayList();

//if the key already exist get the current list and add to it
if (this.containsKey(key)) {
int id = keys.get(key);
//get the existing items
vals = values.get(id);
//add the new item
vals.add(value);
//put the list back
values.put(id, vals);
} else {
//add the new item
vals.add(value);
int id = keys.size();
//if there is more than one item then add this item as size+1
// if(id==0)
id++;
values.put(id, vals);
keys.put(key, id);
}
}

/**
* @param key they key to get the values of
* @return a list of all values associated with the key
*/
public ArrayList get(K key) {
if (this.containsKey(key)) {
int id = keys.get(key);
return values.get(id);
}
return null;
}

/**
*
* @return the set of keys available
*/
public Set getKeySet() {
return keys.keySet();
}

/**
*
* @param key the key to check for
* @return true if the key exists and false otherwise
*/
public boolean containsKey(K key) {
return keys.containsKey(key);
}

public int size() {
return keys.size();
}

public Set keySet() {
return keys.keySet();
}
}

```



Using MultiValue is pretty simple,
```java
//using the magic of generics can be any combination of valid types
MultiValue registeredEvents = new MultiValue();
//this can be called multiple times, if the same key is used then all the items with the same key can
//be retrieved later
registeredEvents.put(key, value);
//if multiple values are stored then you simply iterate as normal
ArrayList handlers = registeredEvents.get(cmd);

```
