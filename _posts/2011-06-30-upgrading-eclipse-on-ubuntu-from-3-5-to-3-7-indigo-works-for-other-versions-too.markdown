---
author: zcourts
comments: true
date: 2011-06-30 00:54:42+00:00
layout: post
slug: upgrading-eclipse-on-ubuntu-from-3-5-to-3-7-indigo-works-for-other-versions-too
title: Upgrading Eclipse on Ubuntu (from 3.5 to 3.7 indigo -  works for other versions
  too)
wordpress_id: 287
categories:
- General
- Ubuntu
tags:
- '3.5'
- '3.7'
- centre
- eclipse
- helios
- indigo
- software
- software centre
- ubuntu
- upgrade
---

After upgrading my Ubuntu version to 11.04 I installed eclipse using the software centre.
It turns out that only v3.5 of Eclipse is available (as the latest) from the software Centre.  I wanted to update to 3.7 but I wanted to keep all the links set up by the software centre e.g On the new Ubuntu "Start Page" or the new toolbar, in addition I want to be able to use the software centre to uninstall eclipse if the need arises.<!-- more -->


# Method 1


The first thing I recommend you try is going to "Help => Install Software"
Type in "http://download.eclipse.org/releases/indigo" then click "Add site"
Click okay on the dialog that shows and it'll take some time to update the list
Go through and  try to upgrade...if it fails continually about dependencies then
you should stop because this method probably won't work... try the next one below.


# Method 2


Install Eclipse through package manager /software centre (whatever version is available)

Download the latest version of eclipse from [http://www.eclipse.org/downloads/](http://www.eclipse.org/downloads/)

Extract to a folder.

open terminal and do the following

#remove the  folder created by the software centre
rm -Rf /usr/lib/eclipse
#move your newly downloaded and extracted eclipse folder to replace the one you just deleted
sudo mv ~/Downloads/eclipse /usr/lib/eclipse
#optional and may cause issues - [See this comment below for a possible fix](http://crlog.info/2011/06/30/upgrading-eclipse-on-ubuntu-from-3-5-to-3-7-indigo-works-for-other-versions-too/comment-page-1/#comment-153)
#sudo mv /usr/lib/eclipse/eclipse.ini /usr/lib/eclipse/eclipse.ini.bak
#sudo ln -s /etc/eclipse.ini /usr/lib/eclipse/eclipse.ini

Open /usr/bin/eclipse using
sudo gedit /usr/bin/eclipse
Replace old version name with the version you downloaded. E.g. If you downloaded Indigo and you have galileo installed
then replace galileo with indigo using the text editor.

That's it...you could play around and only move some of the folders and keep the plugins folder to then do updates on your existing plugins.

The steps in method 2 leaves the original start up links from the Ubuntu menu, taskbar, toolbar and any other pre-existing links.

**UPDATE: As pointed out by Jacob in the comments:
**(Untested since I didn't keep my old plugins) One needs to modify /usr/lib/eclipse/eclipse.ini to get eclipse to start (e.g. change the names of the plugins to match those available in the plugins folder)
