---
author: zcourts
comments: true
date: 2013-05-23 12:21:04+00:00
layout: post
slug: installconfigure-nvideo-with-optimus-on-ubuntu
title: Install/Configure NVideo (with optimus) on Ubuntu
wordpress_id: 568
categories:
- Ubuntu
tags:
- bbswitch
- bumblee
- driver
- graphics card
- mesa
- mesa-utilx
- nvidia
- optirun
- power
- power management
- ubuntu
---

So you got your shiny new laptop with a decent card and wouldn't you know it...it's not working properly or it's performance is shoddy at best. After having to re-install Ubuntu 3 times I've decided to write a quick post with the commands I used to get my battery to go from 20 mins to 3hrs...yes, that's how much difference it makes!<!-- more -->

First thing you need is [BumbleBee](https://wiki.ubuntu.com/Bumblebee). Install it with



	
  1.  sudo add-apt-repository ppa:bumblebee/stable

	
  2. sudo apt-get update

	
  3. Install Bumblebee using the default proprietary nvidia driver:sudo apt-get install bumblebee bumblebee-nvidia virtualgl linux-headers-generic


There is a little [power management tool](https://github.com/Bumblebee-Project/Bumblebee/wiki/Power-Management) under the bumblebee project, install it with



	
  1. 

    
    <code>sudo apt-get install acpidump iasl dmidecode</code>





Once installed the graphics card still shows up as "unknown" in settings so to get it identified you need to install [messa-utils](http://apt.ubuntu.com/p/mesa-utils) with.



	
  1. sudo apt-get install messa-utils


Now reboot, enjoy your battery life and glorious HD screen (if you have one :D)

Quick and painless when you know...pain in the rear when you don't...
