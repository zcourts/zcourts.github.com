---
author: zcourts
comments: true
date: 2012-09-29 18:07:59+00:00
layout: post
slug: install-haproxy-on-windows-cygwin-good-for-testing
title: Install HAProxy on Windows (Cygwin) - Good for testing
wordpress_id: 449
categories:
- General
tags:
- config
- cygwin
- haproxy
- install
- node
- socket.io
- Websocket
---

I've been developing an App for most of the summer. It's using a few backend services so in production I use HAProxy in front of them.

The latest service uses [socket.io](http://socket.io) and [Node.JS](http://nodejs.org/), I couldn't get it going because the local web server runs on a different port than the Node JS server (naturally). Due to the "[Same origin policy](http://en.wikipedia.org/wiki/Same_origin_policy)" socket.io JS needs to run on the same port (and host). So I installed HAProxy to mimic how everything would run in Prod.

<!-- more -->First thing first - Using the Cygwin setup.exe install GCC and G++

Download HaProxy [http://haproxy.1wt.eu/](http://haproxy.1wt.eu/)

Next extract the HaProxy archive you downloaded, I was in my home directory (/home/courtney).

Go into the extracted folder

```javascriptcd haproxy.x.y.z```

Where  .x.y.z was the version number. Now compile:

```javascript
make TARGET=linux28
```

If no error occurred  then install

```javascript
make install
```

Once installed you need a HaProxy Config file. I'm using 1.4 so docs are here: [http://cbonte.github.com/haproxy-dconv/configuration-1.4.html](http://cbonte.github.com/haproxy-dconv/configuration-1.4.html) . You should have a look here [http://haproxy.1wt.eu/#docs](http://haproxy.1wt.eu/#docs) to find your specific version of the docs.

Once you have a HaProxy config file fire up the process using:

```javascript/usr/local/sbin/haproxy.exe -f haproxy.cfg```

If like me you're using Node or whatever else (WebSockety) with HaProxy then a good place to start is [http://stackoverflow.com/questions/4360221/haproxy-websocket-disconnection/4737648#4737648](http://stackoverflow.com/questions/4360221/haproxy-websocket-disconnection/4737648#4737648)

This post is short and shody but its more of a reference for me in the future I'll probably have to do it again.
