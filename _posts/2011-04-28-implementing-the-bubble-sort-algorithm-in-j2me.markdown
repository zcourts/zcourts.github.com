---
author: zcourts
comments: true
date: 2011-04-28 20:58:04+00:00
layout: post
slug: implementing-the-bubble-sort-algorithm-in-j2me
title: Implementing the Bubble sort algorithm in J2ME
wordpress_id: 226
categories:
- Algorithm
tags:
- bubble sort
- j2me
---

A friend asked me two days ago how to implement a sort algorithm on J2ME...
Never used the J2ME API but I thought, hey, can't be that bad right. I must say, after seeing the primitive nature of J2ME I don't think I would or even could do mobile dev. with that API. It'd drive me insane. In any case, I figured out a quick way of sorting an array of names in alphabetical order...<!-- more -->

J2ME has a RecordComparator interface defined as:

```Java
public interface RecordComparator {

    public static final int PRECEDES = -1;
    public static final int EQUIVALENT = 0;
    public static final int FOLLOWS = 1;

    public int compare(byte[] rec1, byte[] rec2);
}
```

Implement that interface in a class called RecordSorter

```Java
    static class RecordSorter implements RecordComparator {

        public int compare(byte[] rec1, byte[] rec2) {
            String strRec1 = new String(rec1);
            String strRec2 = new String(rec2);
            return strRec1.compareTo(strRec2) == 0 ? EQUIVALENT
                    : (strRec1.compareTo(strRec2) > 0 ? FOLLOWS : PRECEDES);
        }
    }
```

Then you can use your class like this:

```Java
String data={"Melon","Grapes","Orange","Bananna"};
private void sortResults() {
RecordSorter sorter = new RecordSorter();
boolean changed = true;
while (changed) {
changed = false;
for (int j = 0; j < (data.length - 1); j++) {
String a = data[j], b = data[j + 1];
if (a != null && b != null) {
int order = sorter.compare(a.getBytes(), b.getBytes());
if (order == sorter.FOLLOWS) {
changed = true;
data[j] = b;
data[j + 1] = a;
}
}
}
}
}
```

In theory this will work in a normal Java app too...not tested though

**UPDATE**: As expected, it works in a normal Java app.

```Java

package sorting;

/**
 *
 * @author Courtney
 */
public class Sorting {

    public interface RecordComparator {

        public static final int PRECEDES = -1;
        public static final int EQUIVALENT = 0;
        public static final int FOLLOWS = 1;

        public int compare(byte[] rec1, byte[] rec2);
    }

    static class RecordSorter implements RecordComparator {

        public int compare(byte[] rec1, byte[] rec2) {
            String strRec1 = new String(rec1);
            String strRec2 = new String(rec2);
            return strRec1.compareTo(strRec2) == 0 ? EQUIVALENT
                    : (strRec1.compareTo(strRec2) > 0 ? FOLLOWS : PRECEDES);
        }
    }
    static String[] data = {"Melon", "Grapes", "Orange", "Bananna"};

    private void sortResults() {
        RecordSorter sorter = new RecordSorter();
        boolean changed = true;
        while (changed) {
            changed = false;
            for (int j = 0; j < (data.length - 1); j++) {
                String a = data[j], b = data[j + 1];
                if (a != null && b != null) {
                    int order = sorter.compare(a.getBytes(), b.getBytes());
                    if (order == sorter.FOLLOWS) {
                        changed = true;
                        data[j] = b;
                        data[j + 1] = a;
                    }
                }
            }
        }
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Sorting s = new Sorting();
        print(data);
        s.sortResults();
        System.out.println("\n");
        print(data);
    }

    static void print(String[] arg) {
        for (String item : arg) {
            System.out.println(item);
        }
    }
}
```
