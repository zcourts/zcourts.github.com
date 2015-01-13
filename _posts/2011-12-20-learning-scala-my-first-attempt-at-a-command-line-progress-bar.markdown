---
author: zcourts
comments: true
date: 2011-12-20 22:59:36+00:00
layout: post
slug: learning-scala-my-first-attempt-at-a-command-line-progress-bar
title: 'Learning Scala : My first attempt at a command line progress bar'
wordpress_id: 396
categories:
- Programming
- Scala
tags:
- bar
- code less
- command line
- command line progress bar
- learn
- progress
- progress bar
- scala
- verbose
---

While on my path to learning Scala, or rather improving my very lacking Scala knowledge I've written a progress bar for the command line...
I'm pretty sure it is far more verbose than it needs to be, but until I know how to code less and do more, this is it:
<!-- more -->

```scala
object Main {

  def main(args: Array[String]): Unit = {
    println("Starting...")
    var i = 0
    val n = 100
    while (i < n) {
      print(pad(i))
      Thread.sleep(150)
      i += 1
    }
    println("Done...")
  }

  def pad(i: Int) = {
    var n = 0
    val str = new StringBuilder
    while (n < i) {
      if (n == 50)
        str.append(i + 1)
      else
        str.append(".")
      n += 1
    }
    if (i < 50) {
      while (n < 50) {
        str.append(" ")
        n += 1
      }
      str.append(i + 1)
    }
    if (i==99)
      str.append("\n")
    else
      str.append("\r")
    str.toString
  }

}
```
