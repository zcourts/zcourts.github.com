---
author: zcourts
comments: true
date: 2011-07-02 09:33:51+00:00
layout: post
slug: installing-xampp-and-adding-orupdating-phpunit-and-phpdocumenter-and-configuring-netbeans-7-to-use-them-on-windows
title: Installing Xampp and adding/updating PHPUnit and PHPDocumenter and configuring
  Netbeans 7 to use them on Windows
wordpress_id: 295
categories:
- PHP
- Programming
- Tutorials
tags:
- netbeans
- pear
- php documentor
- phpunit
- unit testing
- vista
- windows
- windows 7
- xampp
- xp
---

That title is quite a mouthful isn't it? I usually do development on [Ubuntu ](http://www.ubuntu.com/)and only ever develop Windows specific programs on Windows using [.NET](http://www.microsoft.com/NET/) but I've found the need to setup an environment to do some [PHP](http://www.php.net)/[MySQL](http://www.mysql.com) dev on windows (7). I'm running Windows 7 but the steps should work fine for XP and Vista too.


## <!-- more -->Step 1:


Install Xampp, If you already have it installed skip to step 2.
Download Xampp from [http://www.apachefriends.org/en/xampp-windows.html#641
](http://www.apachefriends.org/en/xampp-windows.html#641)Run the installation, if you encounter any issues, try to resolve them before continuing.


## Step 2


Open Window's CMD promt, on XP click start --> run --> cmd
On XP,Vista or Windows 7, Click start -> All programs -> Accessories -> Command Promt


###### (Note that on Vista or Windows 7 you need to right click "Command Promt" from the menu and run as an Administrator.)




## Step 3


With the command prompt open you need to change directory to where you installed xampp. My installation is in C:/xampp so I'll be using that path, but you need to change it to where you installed it.
In the command prompt type in
cd C:/xampp/php
In this directory you will find the PHP executable,PEAR and the other extensions that are installed by default.


## Step 4


[Install phpunit](http://www.phpunit.de/manual/current/en/installation.html), the instructions on the official PHPUnit page now applies so type in the command prompt:

    
    <strong><code>pear channel-discover pear.phpunit.de</code></strong>
    
    <strong><code>pear channel-discover components.ez.no</code></strong>
    
    <strong><code>pear channel-discover pear.symfony-project.com</code></strong>


This has to be done only once. Now the PEAR Installer can be used to install packages from the PHPUnit channel:

    
    <strong><code>pear install phpunit/PHPUnit</code></strong>


You should see an output similar to

    
    C:\xampp\php>pear.bat  install phpunit/PHPUnit
    Did not download optional dependencies: ezc/ConsoleTools, use --alldeps to download automatically
    phpunit/PHPUnit requires PEAR Installer (version >= 1.9.2), installed version is 1.7.2
    phpunit/PHPUnit can optionally use PHP extension "curl"
    phpunit/PHPUnit can optionally use PHP extension "dbus"
    phpunit/DbUnit requires PEAR Installer (version >= 1.9.2), installed version is 1.7.2
    phpunit/File_Iterator requires PEAR Installer (version >= 1.9.2), installed version is 1.7.2
    phpunit/Text_Template requires PEAR Installer (version >= 1.8.1), installed version is 1.7.2
    phpunit/PHP_CodeCoverage requires PEAR Installer (version >= 1.9.1), installed version is 1.7.2
    phpunit/PHP_CodeCoverage requires package "phpunit/File_Iterator" (version >= 1.2.2)
    phpunit/PHP_CodeCoverage requires package "phpunit/Text_Template" (version >= 1.0.0)
    phpunit/PHP_CodeCoverage can optionally use PHP extension "xdebug" (version >= 2.0.5)
    phpunit/PHP_Timer requires PEAR Installer (version >= 1.9.0), installed version is 1.7.2
    phpunit/PHPUnit_MockObject requires PEAR Installer (version >= 1.9.2), installed version is 1.7.2
    phpunit/PHPUnit_MockObject requires package "phpunit/Text_Template" (version >= 1.0.0)
    phpunit/PHPUnit_Selenium requires PEAR Installer (version >= 1.9.2), installed version is 1.7.2
    phpunit/PHP_TokenStream requires PEAR Installer (version >= 1.9.1), installed version is 1.7.2
    downloading YAML-1.0.6.tgz ...
    Starting to download YAML-1.0.6.tgz (10,010 bytes)
    .....done: 10,010 bytes
    downloading ConsoleTools-1.6.1.tgz ...
    Starting to download ConsoleTools-1.6.1.tgz (869,994 bytes)
    ...done: 869,994 bytes
    downloading Base-1.8.tgz ...
    Starting to download Base-1.8.tgz (236,357 bytes)
    ...done: 236,357 bytes
    install ok: channel://pear.symfony-project.com/YAML-1.0.6
    install ok: channel://components.ez.no/Base-1.8
    install ok: channel://components.ez.no/ConsoleTools-1.6.1


If it says install ok then you're good to go. If you get an error similar to:

    
    'pear' is not recognized as an internal or external command,
    operable program or batch file.


Then you need to change the above commands and replace "pear" with "pear.bat"...
If that fails, check and ensure your in the right directory, it must be in xampp-install-folder/php


## Step 5


Using the command:

    
    dir


Check if a file exists named phpdoc.bat, if it does then skip to step 6.
If it doesn't exist then type the command

    
     pear install  PhpDocumentor


You should get an output similar to

    
    C:\xampp\php>pear install  PhpDocumentor
    downloading PhpDocumentor-1.4.3.tgz ...
    Starting to download PhpDocumentor-1.4.3.tgz (2,423,486 bytes).......................done: 2,423,486 bytes
    install ok: channel://pear.php.net/PhpDocumentor-1.4.3


If it doesn't say install ok and gives an error saying something along the lines of:

    
    Ignoring installed package pear/PhpDocumentor
    Nothing to install


In which case try the following:

    
    pear uninstall  PhpDocumentor
    uninstall ok: channel://pear.php.net/PhpDocumentor-1.4.2


This will remove the default version that ships with xampp.
Once again try to install it:

    
    pear install  PhpDocumentor


That should do it...

NOTE: A known issue is documented at
You may be facing the same issue as the person
[http://stackoverflow.com/questions/4717547/cant-install-pear-on-windows-7-structures-graph-error  ](http://stackoverflow.com/questions/4717547/cant-install-pear-on-windows-7-structures-graph-error)
Another issue may be related to php.net updating their channel's protocol... if you get a warning similar to

    
    WARNING: channel "pear.php.net" has updated its protocols, use "channel-update pear.php.net" to update
    downloading PhpDocumentor-1.4.3.tgz ...


Just do as it says and type

    
    pear channel-update pear.php.net


Once again run the installation command.


## Step 6


Finally, Open netbeans and go to Tools -> Options
Chose PHP from the top set of tabs available
When you chose PHP you will be given 3 additional tabs below, the first one asking for the location of the PHP interpretor
Type in

    
    C:\xampp\php\php.exe


IMPORTANT: You must add the path to PHPUnit's classes to the Global include path in the first tab, if you want to get help from netbeans when writing unit tests. By help I mean suggestions on the available methods from phpunit.
The path should be C:\xampp\php\PEAR\PHPUnit, So below where you add the path to php.exe there is a section for global includes. Click "Add folder" and type that path in.

Click the next tab "Unit Testing"
The path to phpunit.bat is

    
    C:\xampp\php\phpunit.bat


Click the last tab "PhpDoc", the path to it is

    
    C:\xampp\php\phpdoc.bat


Final NOTE:
If you got a bunch of errors through out the install and tried uninstalling and re-installing, it may be worth deleting PEAR's temp files to force it to fetch new files from the servers when you install. The temp folder is usually:
C:\Users\Courtney\AppData\Local\Temp\pear
Remove the folders in that directory and retry installation.

Of course if you installed xampp somewhere else then change the path details appropriately.

I realise there are a lot of debugging stuff here for a simple install but this is exactly why I try to avoid none
Windows development on a windows machine. The setups are more often than not long winded and error prone. Unless you
get lucky with a project like xampp or wamp that provides an installer and even then things still go wrong sometimes.
Anyway, enough ranting, hope it helps :-)
