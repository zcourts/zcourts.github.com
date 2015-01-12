---
author: zcourts
comments: true
date: 2011-01-12 22:13:15+00:00
layout: post
slug: setup-svn-for-your-team
title: Setup SVN for your team
wordpress_id: 24
categories:
- Tutorials
---

Okay,as discussed earlier we will be using SVN as our version controller system. 

Download tortise svn from [http://tortoisesvn.net/downloads.html](http://tortoisesvn.net/downloads.html)


Install it and restart.... 


Create the folder to store all the project documents, the folder must be empty.


Right click on the folder and click SVN checkout


[![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor11.png)](http://tortoisesvn.net/downloads.html)


Enter http://svnurl.com as the SVN server URL.![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor2.png)

Click okay and enter your login details

![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor31.png)

When it's done click okay. There should now be a green tick on the folder icon. This means that the files were checked out properly...

![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor41.png)

![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor51.png)

After you have made changes to your files the green tick changes to the read icon on the folder below.

![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor61.png)

To make your changes available to everyone in the team right click on the folder and click SVN Commit.
![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor71.png)
That will push your changes to the server.

YOU MUST COMMIT YOUR CHANGES IN ORDER FOR THE REST OF THE TEAM TO SEE IT.

Once someone has updated the repository, in order for you to get the changes the rest of the team has made you need to right click on the folder and then click update to update your local version of the files. Aseen below

![](http://crlog.files.wordpress.com/2011/01/011211_2212_setupsvnfor81.png)
