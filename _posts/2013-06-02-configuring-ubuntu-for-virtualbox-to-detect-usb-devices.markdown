---
author: zcourts
comments: true
date: 2013-06-02 13:11:46+00:00
layout: post
slug: configuring-ubuntu-for-virtualbox-to-detect-usb-devices
title: Configuring Ubuntu for VirtualBox to detect USB devices
wordpress_id: 588
categories:
- Android
- Ubuntu
tags:
- android
- mosync
- permission denied
- usb
- usb devices
- virtualbox
- virtualbox list usb devices
- virtualbox usb setup
- windows
---

I've been developing Android Apps are more often recently but I've found the Linux support for some android tools less than appealing.
In particular, I've been using [MOSYNC](http://www.mosync.com/) and they don't provide a Linux installer, you have to [compile it from source](http://www.mosync.com/docs/sdk/tools/guides/extensions/building-mosync-source-linux/index.html). That's all well and good until something goes wrong then you spend forever trying to re-compile and fix build issues, time I'd rather spend doing something else.

Since I refuse to go back to windows as a main OS after it annoyed the crap outta me recently, I settled for the next best thing, virtualisation! I'm using [VirtualBox](https://www.virtualbox.org/) which is honestly one of the most awesome opensource software I know of! With Windows installed in VirtualBox, I was set...or so I thought. USB devices weren't being picked up by VirtualBox. A quick Google revealed that this is a common issue and well documented on [page 52 of the VirtualBox user manual (People read those?)](https://forums.virtualbox.org/viewtopic.php?f=8&t=45349). If you'd like to read it, it's all well documented in the [user manual under VirtualBox USB support](https://www.virtualbox.org/manual/ch03.html#idp19029008).

So to the point, the problem is that when VirtualBox is installed your user account probably wasn't added to the group it created. You can check and make sure you're facing the same issue by running the command:
<!-- more -->
```bash
ls -lR /dev/vboxusb
```
If it outputs "Permission denied" then it's probably the same issue. Now trying running it with sudo
```bash
sudo ls -lR /dev/vboxusb
```
If it lists all your USB devices then that means its very likely the same problem. You can confirm this by running
```bash

VBoxManage list usbhost

```
If  it says "None" and then running it with sudo lists the devices there's a good chance this solution will work for you...if not you can try it anyway. As I said earlier the problem is probably that your user account isn't in the right group. There are two ways to fix this, from the command line or through a GUI tool. The command line is quicker simply type
```bash
usermod -a -G vboxusers courtney #change courtney to your username
```
to use a GUI tool install system tools and use it to add your user account to the "vboxusers" users group. There's a [short guide here](http://askubuntu.com/a/66727/10273) but in short run

```bash
sudo apt-get install gnome-system-tools
```

Then add yourself, see images below:

[caption id="attachment_590" align="aligncenter" width="670"][![Find vboxusers and add your account to it](http://crlog.files.wordpress.com/2013/06/users-2.png)](http://crlog.files.wordpress.com/2013/06/users-2.png) Find vboxusers and add your account to it[/caption]

[caption id="attachment_591" align="aligncenter" width="670"][![Search for users](http://crlog.files.wordpress.com/2013/06/user-11.png)](http://crlog.files.wordpress.com/2013/06/user-11.png) Search for users[/caption]


Once you're added, you'll need to logout, and log back in for group permissions to take effect.

When you're logged back in, fire up virtual box, don't start windows, we're not quite finished yet. Open the settings dialog and select "USB" from the list of options on the left.
Now click the + icon to add a filter

[caption id="attachment_592" align="aligncenter" width="670"][![Add virtualbox usb filter](http://crlog.files.wordpress.com/2013/06/add-filter.png)](http://crlog.files.wordpress.com/2013/06/add-filter.png) Add virtualbox usb filter[/caption]


You should now have your USB devices listed, select the one you want from the list. For more info on filters, check the VirtualBox usb support page I linked to earlier.

[caption id="attachment_593" align="aligncenter" width="666"][![SamSung S3 added as a filter](http://crlog.files.wordpress.com/2013/06/samsung-filter.png)](http://crlog.files.wordpress.com/2013/06/samsung-filter.png) SamSung S3 added as a filter[/caption]

Hit OK and start windows. Windows will now get access to your device and install whatever drivers it needs to so that you get the usual open device dialog like this:

[caption id="attachment_594" align="aligncenter" width="670"][![S3 detected in VirtualBox](http://crlog.files.wordpress.com/2013/06/windows-ht-9300.png)](http://crlog.files.wordpress.com/2013/06/windows-ht-9300.png) S3 detected in VirtualBox[/caption]

Now one last thing! If you get Ubuntu automounting your device and showing that annoying popup hundreds of times, then unplug the device and prevent Ubuntu from automounting.

[caption id="attachment_595" align="aligncenter" width="393"][![Annoying ubuntu popup](http://crlog.files.wordpress.com/2013/06/annoying-ubuntu-popup.png)](http://crlog.files.wordpress.com/2013/06/annoying-ubuntu-popup.png) Annoying ubuntu popup[/caption]

Follow the instructions over at [Ubuntu's docs](https://help.ubuntu.com/community/Mount/USB). In short, open "**dconf-editor**" if it's not installed then install it with

```bashsudo apt-get install dconf-editor```

Open it and "Browse to **org.gnome.desktop.media-handling**".

[caption id="attachment_596" align="aligncenter" width="670"][![disable automount device on ubuntu](http://crlog.files.wordpress.com/2013/06/disable-automount.png)](http://crlog.files.wordpress.com/2013/06/disable-automount.png) disable automount device on ubuntu[/caption]

Uncheck the box, close it and move on!

That's that! Now you can get all the Windows better tools for Android on Windows and stay with Ubuntu!

Links:
[Cannot find USB bug report](https://www.virtualbox.org/ticket/8978)
[No USB available with non root user](https://www.virtualbox.org/ticket/10087)
