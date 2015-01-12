---
author: zcourts
comments: true
date: 2011-08-14 12:17:23+00:00
layout: post
slug: github-access-denied-or-ssh-key-already-taken-on-windows-puttyvs-git-extension
title: Github access denied or SSH key already taken on windows (Putty+VS git extension)
wordpress_id: 328
categories:
- Windows
tags:
- access denied
- github
- ssh
- windows
---

This is just a quick post to point to the solution.
I had to do some C# work a week or so ago and then push everything to [github](http://github.com). I already had an SSH key on my account but since that was generated under Ubuntu...A new one was needed for Windows.<!-- more -->

I followed the github [setting up guide](http://help.github.com/win-set-up-git/) but once I added the new ssh key it reported that my SSH key had already been taken...

It was a less than useful error message since it doesn't mean what it suggests...from what I've come to understand anyway.
After a bit more than diligent "Googling" I found this thread on Google groups which eventually lead to the issue being resolved.

The problem is likely to be that the format for the public key putty generates is different to what is expected (i.e. format that you'd get on linux for e.g.)
The link to the post then is:
[http://groups.google.com/group/github/browse_thread/thread/21fd06fb8c3f43bd/f5c44b2197d1be15](http://groups.google.com/group/github/browse_thread/thread/21fd06fb8c3f43bd/f5c44b2197d1be15)

It'd be convenient to copy the steps posted there to this post but I played no part in that thread so...just have a look, the first post by "Eric" has a detailed solution...if it ever becomes unavailable I have an offline version.
