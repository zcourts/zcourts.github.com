---
author: zcourts
comments: true
date: 2011-01-16 06:53:41+00:00
layout: post
slug: fix-wordpress-blank-page
title: Fix wordpress blank page
wordpress_id: 29
categories:
- Wordpress
---

Now, I like many others use wordpress. Not just for blogging but for a range of things.

Sometimes it doesn’t work out too well however...like after migrating host.
I set up a new centos distro a few days ago with a simple LAMP stack. After moving over,

This blog didn’t work and I got a blank page with no error. It’s bad when your sites are giving errors
but when you’ve got nothing, that’s when you’re really in trouble.

Going through the logs I noticed this line:

    
    “[Fri Jan 14 07:40:11 2011] [error] [client xxx.xxx.xx.xxx] PHP Parse error:  syntax error, unexpected T_STRING in /var/www/vhosts/crlog.info/httpdocs/wp-config.php on line 14”


Checking the file revealed that somehow the settings on that line got
split into two lines and right in the middle of a php function.
I am pretty sure that is due to editing the file using nano when
I changed the DB settings.

There seems to be a tonne of php notices in the log as well, for websites
that only just got transferred this will be a problem.
The log file is already megabytes in size. I’d advise anyone seeing
similar issues to go through the logs and take a note of the
Path to the file generating the notice,warning or error.
Once done, try finding an alternative method to replace the one causing
the issue. Most notices for deprecated functions
will have the new function to replace your existing one with.

Enough of the ranting though, simple steps to fixing the issue:
1)  Check file permissions, and execute chmod –R 755 httpdocs (or whatever
your directory is called so recursively set permissions to 755)
2)  Enable wp_debug options in wp-config.php by adding a line
with “define(‘WP_DEBUG’,true);”
3)  If you moved from an old host and created a tar file using
tar cf archive.tar * then this does not include your .htaccess file.
You need to create .htaccess on the new host and copy the contents
from the old host or modify your tar command.
4)  Check your log files, as above there may be an [error] somewhere.
5)  If all else fails, it may be your database as discussed on
the [wordpress forums](http://wordpress.org/support/topic/posting-new-post-leads-to-blank-php-screen?replies=13#post-721909).
Check for any suspicious looking enabled plugins.
In wordpress 3.0 and on wards this will be in the wp_options table and
the option_name column will be ‘active_plugins’. You can safely remove
the contents of the option_value for this row. Plugins can always be re-enable
later. For older versions of wordpress, consider upgrading. If that’s no an
option then you will have wp_settings table instead of wp_options.
6)  Move all plugins and themes out of the plugin and theme directories to
somewhere else. Leave the wordpress default theme in place “twentyten” for wordpress 3.0.

There are a few more tip/tricks to debugging and getting around this but
I can’t remember them at the moment. I’ll update this post as I do.
