---
author: zcourts
comments: true
date: 2013-07-19 10:53:17+00:00
layout: post
slug: android-debugging-over-bluetooth-without-root
title: Android debugging over bluetooth (without root)
wordpress_id: 659
categories:
- Android
tags:
- adb
- android
- android wireless deployement
- bluetooth
- bluetooth debug
- no root
- tcp debugging
- tcpip
---

So I'm on a train to Reading and wanted to continue working on an app I've been hacking at but my USB cable is annoyingly inconvenient and Ubuntu keeps throwing a fit because I haven't been able to configure it to properly handle MTP enabled devices.   To get debugging going here's what I've just done.<!-- more -->

Connect the phone via USB and from the terminal enter (to run adb in tcp ip mode)

[code lang="bash"]

adb tcpip 4455

[/code]

Now on the phone enable debugging from Settings -> Developer options -> enable debugging.

Next enable  bluetooth and pair the phone with the laptop. Once paired, unpair the two and on the android device go to Settings -> Tethering and portable hotspot then enable "Bluetooth tethering"

Now go back to settings -> Blutetooth and repair the device with the laptop.

On Ubuntu click your network icon in the task bar to list the available networks

In Ubuntu click the network icon again after successfully connecting to the bluetooth network and click "Connection information" towards the bottom.

[![bluetooth Screenshot from 2013-07-19 11:40:05](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-114005.png)
](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-114005.png)

From the window that opens, note the Primary DNS IP. Copy it, write it down, whatever you need to but you need it for the next step.

Now from the command line again enter:

[code lang="bash"]

adb connect 192.168.44.1:4455

[/code]

That should produce

connected to 192.168.44.1:4455

Now if you're using Eclipse, Intellij or any other IDE with adb support  you can look at logcat to start seeing logs from the device:

[![bluetooth Screenshot from 2013-07-19 11:31:14](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-113114-e1374230755917.png)](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-113114.png)

From here on you can deploy your App to the device and/or debug it without a USB. And obviously each time just pair the devices and reconnect. You won't have to repeat all the steps - just those two.

Below are a series of screenshots that might help. They're in no particular order, I'm writing this post on the train and taking screenshots on the phone and laptop and uploading from both directly to the same post so it is what it is but should hopefully still be useful.

[![bluetooth-Screenshot from 2013-07-19 11:27:32](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-112732.png)](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-112732.png) [![bluetooth - Screenshot from 2013-07-19 11:30:55](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-113055.png)](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-113055.png) [![wpid-Screenshot_2013-07-19-11-26-56.png](http://crlog.files.wordpress.com/2013/07/wpid-screenshot_2013-07-19-11-26-56.png)](http://crlog.files.wordpress.com/2013/07/wpid-screenshot_2013-07-19-11-26-56.png) [![wpid-Screenshot_2013-07-19-11-28-54.png](http://crlog.files.wordpress.com/2013/07/wpid-screenshot_2013-07-19-11-28-54.png)](http://crlog.files.wordpress.com/2013/07/wpid-screenshot_2013-07-19-11-28-54.png) [![wpid-Screenshot_2013-07-19-11-28-59.png](http://crlog.files.wordpress.com/2013/07/wpid-screenshot_2013-07-19-11-28-59.png)](http://crlog.files.wordpress.com/2013/07/wpid-screenshot_2013-07-19-11-28-59.png) [![bluetooth Screenshot from 2013-07-19 11:28:16](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-112816.png)](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-112816.png) [![bluetooth Screenshot from 2013-07-19 11:30:16](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-113016.png)](http://crlog.files.wordpress.com/2013/07/bluetooth-screenshot-from-2013-07-19-113016.png)



Any questions, suggestions, feel free to ask.
