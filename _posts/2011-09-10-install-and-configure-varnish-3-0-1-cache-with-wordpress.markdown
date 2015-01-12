---
author: zcourts
comments: true
date: 2011-09-10 11:30:34+00:00
layout: post
slug: install-and-configure-varnish-3-0-1-cache-with-wordpress
title: Install and configure Varnish (3.0.1) cache with Wordpress
wordpress_id: 363
categories:
- Apache
- High Performance
- Ubuntu
tags:
- varnish
- varnish and wordpress
- varnish cache
- varnish config
- varnish configuration
- wordpress
---

A few days ago I promised I'd go through what  I did when [setting up varnish with wordpress](http://crlog.info/2011/09/07/wordpress-varnish-cache-a-match-made-in-heaven/), its been slightly delay  but here goes. The blog I used it on was [Script and Scroll](http://www.scriptandscroll.com). I've ran the Apache benchmark tool against the site, only one URL but made 1Million requests to it and it held up quite well. The requests were completed in about 5 minutes, I may post the results in a later entry...

So, on the day that alarm bells went off form traffic spike, I just install varnish and cached everything and anything that I could... Obviously this isn't ideal in most cases but I had very little time to spend on this. So method one below is the "naive" approach I'd say, but it works and works fairly well. Method two is my current configuration which is based on a post [Donncha O Caoim](https://plus.google.com/106437496932759928522/posts/XMJMt8Yyu8N) did. I had to tweak a few things because I am using the latest version of varnish some of the configuration options he used changed in version 3 of varnish.

<!-- more -->The general config however is based on his, which in turn, he says is based on numerous tutorials/articles he read.

Start by grabbing Varnish
[https://www.varnish-cache.org/releases/varnish-cache-3.0.1](https://www.varnish-cache.org/releases/varnish-cache-3.0.1)
It may be easier to use a package manager.

[https://www.varnish-cache.org/installation/redhat](https://www.varnish-cache.org/installation/redhat) (Redhat/Centos etc) On the page above chose any of the other distros available to suit you. My server is Centos so my install became

yum install varnish
If you're on Ubnuntu/Debian the follow the instructions on that page but it'll end in you doing
apt-get install varnish

This post is mainly to focus on the configuration rather than the install because installation is quick and painless:
[https://www.varnish-cache.org/docs](https://www.varnish-cache.org/docs) has excellent guides to installing for your specific distro...

If you're upgrading and have a config file already then you need to pay attention to the upgrade notes to see what may have changed



	
  * [https://www.varnish-cache.org/docs/3.0/installation/upgrade.html?highlight=cacheable](https://www.varnish-cache.org/docs/3.0/installation/upgrade.html?highlight=cacheable)

	
  * [https://www.varnish-cache.org/docs/trunk/installation/upgrade.html](https://www.varnish-cache.org/docs/trunk/installation/upgrade.html)


The above URLs will have a complete set of changes, [https://www.varnish-cache.org/docs/2.1/reference/vcl.html](https://www.varnish-cache.org/docs/2.1/reference/vcl.html) is recommended if you want to tweak the config later. Although I've found in some cases, this page isn't always a true reflection of the latest version. This is true with just about anything though so just be careful when making changes if you're not sure they're compatible with your version of varnish.

Now then, once installed we can begin configuration for our website:

First thing to configure is Apache, it needs to listen on a different port (i.e. not port 80). In the example I use 8080 but it can be whatever you please. The two options to set are

    
    NameVirtualHost 127.0.0.1:8080
    Listen 127.0.0.1:8080


OR

    
    NameVirtualHost *:8080
    Listen *:8080


Now you can leave this until last if your configuring your production server because people accessing it will not be responded to until varnish is configured and running reload or restart apache,
/etc/init.d/apache restart or service httpd restart
Method 1

This caches everything it can except the wordpress login and admin pages, for more information please see [https://www.varnish-cache.org/trac/wiki/VarnishAndWordpress](https://www.varnish-cache.org/trac/wiki/VarnishAndWordpress):

[code]
backend default {
  .host = "127.0.0.1";
  .port = "8080";
}
       	# Drop any cookies sent to Wordpress.
       	sub vcl_recv {
               	if (!(req.url ~ "wp-(login|admin)")) {
                       	unset req.http.cookie;
               	}
       	}

       	# Drop any cookies Wordpress tries to send back to the client.
       	sub vcl_fetch {
               	if (!(req.url ~ "wp-(login|admin)")) {
                       	unset beresp.http.set-cookie;
               	}
       	}
[/code]


## Method 2


Varnish configuration language is a powerful domain specific language that gives you high granularity when it comes to controlling the cache. This version of the config has far more options than the above.

[code]
backend default {
    .host = "127.0.0.1";
    .port = "8080";
}
# Called after a document has been successfully retrieved from the backend.
sub vcl_fetch {
    # Uncomment to make the default cache "time to live" is 5 minutes, handy
    # but it may cache stale pages unless purged. (TODO)
    # By default Varnish will use the headers sent to it by Apache (the backend server)
    # to figure out the correct TTL.
    # WP Super Cache sends a TTL of 3 seconds, set in wp-content/cache/.htaccess

    set beresp.ttl   = 24h;

    # Strip cookies for static files and set a long cache expiry time.
    if (req.url ~ "\.(jpg|jpeg|gif|png|ico|css|zip|tgz|gz|rar|bz2|pdf|txt|tar|wav|bmp|rtf|js|flv|swf|html|htm)$") {
            unset beresp.http.set-cookie;
            set beresp.ttl   = 24h;
    }

    # If WordPress cookies found then page is not cacheable
    if (req.http.Cookie ~"(wp-postpass|wordpress_logged_in|comment_author_)") {
       # set beresp.cacheable = false;#versions less than 3
	#beresp.ttl>0 is cacheable so 0 will not be cached
	set beresp.ttl = 0s;
    } else {
       # set beresp.cacheable = true;
	set beresp.ttl=24h;#cache for 24hrs
    }

    # Varnish determined the object was not cacheable
	#if ttl is not > 0 seconds then it is cachebale
    if (!beresp.ttl > 0s) {
        set beresp.http.X-Cacheable = "NO:Not Cacheable";
    } else if ( req.http.Cookie ~"(wp-postpass|wordpress_logged_in|comment_author_)" ) {
        # You don't wish to cache content for logged in users
        set beresp.http.X-Cacheable = "NO:Got Session";
        return(hit_for_pass); #previously just pass but changed in v3+
    }  else if ( beresp.http.Cache-Control ~ "private") {
        # You are respecting the Cache-Control=private header from the backend
        set beresp.http.X-Cacheable = "NO:Cache-Control=private";
        return(hit_for_pass);
    } else if ( beresp.ttl < 1s ) {
        # You are extending the lifetime of the object artificially
        set beresp.ttl   = 300s;
        set beresp.grace = 300s;
        set beresp.http.X-Cacheable = "YES:Forced";
    } else {
        # Varnish determined the object was cacheable
        set beresp.http.X-Cacheable = "YES";
    }
    if (beresp.status == 404 || beresp.status >= 500) {
        set beresp.ttl = 0s;
    }

    # Deliver the content
    return(deliver);
}

sub vcl_hash {
    # Each cached page has to be identified by a key that unlocks it.
    # Add the browser cookie only if a WordPress cookie found.
    if ( req.http.Cookie ~"(wp-postpass|wordpress_logged_in|comment_author_)" ) {
        #set req.hash += req.http.Cookie;
   	hash_data(req.http.Cookie);
	 }
}

# Deliver
sub vcl_deliver {
    # Uncomment these lines to remove these headers once you've finished setting up Varnish.
    remove resp.http.X-Varnish;
    remove resp.http.Via;
    remove resp.http.Age;
    remove resp.http.X-Powered-By;
}

# vcl_recv is called whenever a request is received
sub vcl_recv {
    # remove ?ver=xxxxx strings from urls so css and js files are cached.
    # Watch out when upgrading WordPress, need to restart Varnish or flush cache.
    set req.url = regsub(req.url, "\?ver=.*$", "");

    # Remove "replytocom" from requests to make caching better.
    set req.url = regsub(req.url, "\?replytocom=.*$", "");

    remove req.http.X-Forwarded-For;
    set    req.http.X-Forwarded-For = client.ip;

    # Exclude this site because it breaks if cached
    #if ( req.http.host == "example.com" ) {
    #    return( pass );
    #}

    # Serve objects up to 2 minutes past their expiry if the backend is slow to respond.
    set req.grace = 120s;
    # Strip cookies for static files:
    if (req.url ~ "\.(jpg|jpeg|gif|png|ico|css|zip|tgz|gz|rar|bz2|pdf|txt|tar|wav|bmp|rtf|js|flv|swf|html|htm)$") {
        unset req.http.Cookie;
        return(lookup);
    }
    # Remove has_js and Google Analytics __* cookies.
    set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(__[a-z]+|has_js)=[^;]*", "");
    # Remove a ";" prefix, if present.
    set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");
    # Remove empty cookies.
    if (req.http.Cookie ~ "^\s*$") {
        unset req.http.Cookie;
    }
    if (req.request == "PURGE") {
        if (!client.ip ~ purgehosts) {
                error 405 "Not allowed.";
        }
	#previous version ban() was purge()
        ban("req.url ~ " + req.url + " && req.http.host == " + req.http.host);
        error 200 "Purged.";
    }

    # Pass anything other than GET and HEAD directly.
    if (req.request != "GET" && req.request != "HEAD") {
        return( pass );
    }      /* We only deal with GET and HEAD by default */

    # remove cookies for comments cookie to make caching better.
    set req.http.cookie = regsub(req.http.cookie, "1231111111111111122222222333333=[^;]+(; )?", "");

    # never cache the admin pages, or the server-status page, or your feed? you may want to..i don't
    if (req.request == "GET" && (req.url ~ "(wp-admin|bb-admin|server-status|feed)")) {
        return(pipe);
    }
    # don't cache authenticated sessions
    if (req.http.Cookie && req.http.Cookie ~ "(wordpress_|PHPSESSID)") {
        return(lookup);
    }
    # don't cache ajax requests
    if(req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache" || req.url ~
"(control.php|wp-comments-post.php|wp-login.php|bb-login.php|bb-reset-password.php|register.php)") {
        return (pass);
    }
    return( lookup );
}

#set of hosts/users from which purging can be done
acl purgehosts {
    "localhost";
    "www.domain.com";
    "123.456.789.123";#server IP
}
[/code]


This config again is based on the post I mentioned above. Change domain.com to your domain and the IP 123.456.etc to your server's IP.

I'm still myself getting used to varnish so this is by no means perfect and I'm continually tweaking and watching my site to see what options I can use to improve performance but so far it's been great.
