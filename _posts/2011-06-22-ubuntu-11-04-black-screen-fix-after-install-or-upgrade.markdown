---
author: zcourts
comments: true
date: 2011-06-22 20:54:35+00:00
layout: post
slug: ubuntu-11-04-black-screen-fix-after-install-or-upgrade
title: Ubuntu 11.04 black screen fix (after install or upgrade)
wordpress_id: 278
categories:
- Operating Systems
- Ubuntu
tags:
- '11'
- '11.04'
- '11.10'
- backlight
- black screen
- fix
- no backlight
- os
- solution
- ubuntu
- ubuntu upgrade
---

I have been stumped for the last two days with my Ubuntu install.
I naively upgraded to 11.04 without checking the [Ubuntu release notes](https://wiki.ubuntu.com/NattyNarwhal/ReleaseNotes)... Turns out their is a known bug affecting [Ubuntu ARM](https://wiki.ubuntu.com/NattyNarwhal/ReleaseNotes#Ubuntu_ARM) installs.

<!-- more -->I upgraded and low and behold, black screen....When I rebooted I could see the Ubuntu logo then poof, darkness.
I borrowed another PC and [Google'd](http://www.google.com/search?client=ubuntu&channel=fs&q=ubuntu+11.04+black+screen&ie=utf-8&oe=utf-8&gl=uk) a bit and found some forum discussions.
One that got my attention was [http://ubuntuforums.org/showthread.php?t=1742352](http://ubuntuforums.org/showthread.php?t=1742352),

The fix suggested on there is to do the following:
Code:

    
    sudo gedit /etc/default/grub
    
    Edit the two lines (GRUB_CMDLINE_LINUX_DEFAULT and GRUB_CMDLINE_LINUX) to read as follows: 
    
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor vga=792"
    GRUB_CMDLINE_LINUX="acpi_osi=Linux"
    
    sudo update-grub
    #need to reboot
    #sudo reboot


I modified the suggestion a bit when it didn't work following [https://help.ubuntu.com/community/BootText](https://help.ubuntu.com/community/BootText) and added the last bit vga=792.
At first that didn't work either and I was reading around on the ubuntu help pages here [https://wiki.ubuntu.com/Kernel/Debugging/Backlight](https://wiki.ubuntu.com/Kernel/Debugging/Backlight)  and it mentioned that there may be a problem when using AC but on DC it disappears or visa versa so I unplugged my laptop's charger and nothing happened, for a moment. I randomly tried to increase the brightness and voila... it shines!
My backlight is back and after a reboot to test it, it all works fine.
if the above fails try
Code:

    
    echo 9>/sys/class/backlight/acpi_video0/brightness


It didn't work for me but there was a report of it working for others on the [Ubuntu](http://www.ubuntu.com/) forums.
