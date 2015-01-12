---
author: zcourts
comments: true
date: 2011-03-28 15:30:40+00:00
layout: post
slug: migrating-from-self-hosted-to-hosted-wordpress
title: Migrating from self-hosted to hosted wordpress
wordpress_id: 188
categories:
- General
- Tutorials
- Wordpress
tags:
- hosted
- hosted wordpress
- self-hosted wordpress
- wordpress
---

Been a while since I posted an entry, I thought I'd do one today after my little migration.

I’ve always used a self-hosted Wordpress until two nights ago. I decided the resources used by my blog just wasn’t worth having it on my VPS with my other sites. I didn’t want to use a wordpress.com sub-domain either but then I read about a little and found that you can map your existing domain name, I thought “sweet”. For pennies I can get my domain and blog hosted and not worry about server and all that stuff. So here’s a quick break down of migrating from a self-hosted wordpress installation, over to the “hosted” wordpress.<!-- more -->

Essentially you need an account with wordpress.com so head over to [https://en.wordpress.com/signup/](https://en.wordpress.com/signup/) to get a free account.

Now, verify all the details, just your e-mail really.

Go back over to the old blog (self hosted) and click “Tools” in the admin area,then choose “Export”, the URL will be yourdomain.com/wp-admin/export.php -

Choose “All content” this will contain all of your posts, pages, comments, custom fields, terms, navigation menus and custom posts.Or if you just want the “Posts” or “Pages” only, choose one of the other options.

Click “Download export file”, which will create an XML file containing all* your data. I say all your data but it can only contain all the text, anything in your library will be handled later.
[![image](http://crlog.files.wordpress.com/2011/03/image_thumb.png)](http://crlog.files.wordpress.com/2011/03/image.png)

You’ll now have your data in a file. If you have tonnes of info, you need to bear in mind that the file can be 15MB max to upload on wordpress.com.

When you’ve done that, sign into your account on wordpress.com, that’ll be at username.wordpress.com/wp-admin
Go to Tools again, and click “Import” this time. Now you have a set of options to choose from:
[![image](http://crlog.files.wordpress.com/2011/03/image_thumb1.png)](http://crlog.files.wordpress.com/2011/03/image1.png)
From the above, choose “Wordpress” since we’re moving from wordpress. On the next screen where it says “Choose file”, find the XML file you downloaded from your old blog and then click “Upload file and Import”.

Once you’ve done that, it’ll have imported your posts etc. It will now ask you to map the old username to the current username (see the image below)
[![image](http://crlog.files.wordpress.com/2011/03/image_thumb2.png)](http://crlog.files.wordpress.com/2011/03/image2.png)


# IMPORTANT: Select the “Import Attachments” option.


If you want your images etc to be downloaded from your old blog to the new one and added to your library automatically, you must make sure you select the option to “Download and import file attachments”.

Once you’ve done that click “Submit” and Wordpress will map your old user to the new one and download all your attachments back into your new library.

At this point you should have all your old posts on the new blog.

You can delete the old ones or whatever you choose and continue blogging on wordpress.com…

This next stage is optional:
If you want your old domain to remain the URL ( AND you have custom DNS records that you want to keep such as extenernal mail) of your blog then keep reading.
On your old server open SSH with Putty or a similar tool and do :
cd /var/named/run-root/var or the location of your bind DNS file if its different.
Open the file for your old blog’s domain name with nano domain.com or pico domain.com
You need to copy the entries which will be similar to :

mymail.domain.com.                 IN CNAME        ghs.google.com.
domain.com.              IN MX  10 ASPMX.L.GOOGLE.COM.
domain.com.              IN MX  20 ALT1.ASPMX.L.GOOGLE.COM.
domain.com.              IN MX  20 ALT2.ASPMX.L.GOOGLE.COM.

Copy this info into a file and remove the first section of each line to make the DNS entry into the “short” version wordpress uses. So the above becomes (if you use Google Apps and Gmail for your mail then simply replace mymail with your sub-domain and the rest will be the same):

CNAME mymail ghs.google.com.

MX 20 ALT1.ASPMX.L.GOOGLE.COM.
MX 20 ALT2.ASPMX.L.GOOGLE.COM.
MX 10 ASPMX.L.GOOGLE.COM.

The DNS template for Wordpress is:


##### Record formats


Four types of records are allowed: MX, TXT, CNAME, and A. We use a minimalistic format for each record type, shown below. TTL is set automatically. When validating, we only check that your records can be safely saved.

    
    MX <pref> <host>
    TXT <text>
    CNAME <subdomain> <host>
    A <subdomain> <IP>




##### Sample records



    
    MX 10 MAIL1.EXAMPLE.COM.
    MX 20 MAIL2.EXAMPLE.COM.
    TXT v=spf1 include:mail.example.com ~all
    CNAME autodiscover EXCHANGE.EXAMPLE.COM.
    A webmail 1.2.3.4


Once that’s in the correct format, go into your new Wordpress admin area and choose Upgrades –> Domains

If you haven’t already done so, add your domain on this screen. Follow the instructions on screen to complete this stage, it will be different if your registering a brand new domain, but you’ll now need to pay a fee. Sort that out and come back…

Once your domain is added, When you choose Upgrades –> Domains, you will now have your registered domain.com as well as username.wordpress.com listed.

Click the radio button next to the domain name and choose “Update primary domain”. Doing so will let all traffic/users from username.wordpress.com redirect to domain.com

Next to the newly registered or transferred domain, click “Edit DNS”
[![image](http://crlog.files.wordpress.com/2011/03/image_thumb3.png)](http://crlog.files.wordpress.com/2011/03/image3.png)

Paste the “short” version of your DNS entries into the available text box.
[![image](http://crlog.files.wordpress.com/2011/03/image_thumb4.png)](http://crlog.files.wordpress.com/2011/03/image4.png)

Once done, choose “Validate without saving” to make sure you got it all right, then choose “Save DNS records” to save the records.

That should be it…. Anything I’ve missed out isn’t important, the rest is the same as being on a self-hosted wordpress. Although, the hosted version is limited, in that, you can’t upload your own theme or plugins so you’ve got to use what’s provided.

Good luck, hope that helps.
