---
author: zcourts
comments: true
date: 2011-09-07 08:45:23+00:00
layout: post
slug: wordpress-varnish-cache-a-match-made-in-heaven
title: Wordpress + Varnish Cache, A match made in heaven
wordpress_id: 357
categories:
- General
- Wordpress
tags:
- page load
- page speed
- varnish
- varnish cache
- vps
- wordpress
---

Recently my other blog, [Script and Scroll](http://www.scriptandscroll.com), started to get a decent amount of traffic. One blog in particular linked back to a post someone published and it gained a lot of attention. Within a few hours of the link being created I started to get alerts from my monitoring system...Wordpress was slowing down, crapping out and running out of memory when serving pages. The load on my VPS hit the roof and Apache more or less came to a halt. After a quick round of investigating, scanning logs etc, I realized what was happening after seeing the referrer and looking at the page that had linked to us. Right, it was time to do something now that I knew what the problem was. Mind you, I had a caching plugin installed but it wasn't doing much good. After thinking of what my options were I decided to go with [Varnish Cache](https://www.varnish-cache.org/).

<!-- more -->After installing Varnish (painlessly and in seconds), I switched it to port 80 and switched apache to listen to a different port. It was amazing! My page load speeds before the increase in traffic were about 4-5 seconds, after getting the increase in traffic it was 8+ seconds on average,12+ at one point...After switching over to varnish and tweaking a few things to make wordpress play nice everything just went lightening fast, the home page loaded in less than a second after the first page load (which took about 2-3 secs), other pages consistently loaded in 1-2 seconds. It got even better after I wired up [W3 Total Cache](http://wordpress.org/extend/plugins/w3-total-cache/) to use [Rackspace Cloud files](http://www.rackspace.com/cloud/cloud_hosting_products/files/) to serve static content and make use of browser Caching. The server load dropped right down. I've now in fact scaled back my VPS from 4GB ram to 1.5GB, traffic levels have remained high and peaked above what the site was experiencing when it grind to a halt.

So far so good...I'll tweak a few things to try and squeeze as much as I can out of it. I'll document my installation and setup process in another post, possibly later today.
