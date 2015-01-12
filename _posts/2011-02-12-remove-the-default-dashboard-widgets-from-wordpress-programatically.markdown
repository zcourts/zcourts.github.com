---
author: zcourts
comments: true
date: 2011-02-12 00:41:31+00:00
layout: post
slug: remove-the-default-dashboard-widgets-from-wordpress-programatically
title: Remove the default dashboard widgets from Wordpress programatically
wordpress_id: 55
categories:
- PHP
- Wordpress
---

It's been over a week since I made a decent post (been extremely busy) so I thought I'd give it a go today.

One of the project's I've had going on requires building a website for a local charity. I discussed it with the charity and agreed on using wordpress. It turns out however, the API for wordpress admin is very minimal and has very little documentation.

I found myself having to develop a large portion of things for the admin section so I've had to make do. One of the things I was asked for was to show custom widgets on the dashboard with various things and to remove the default ones.... whaaaaa? Usually wordpress users just manually remove and/or configure these widgets, however the potential users of this are going to be people who have little or no technical expertise... Below is a quick and simple way to remove all the default widgets/modules that are loaded on the dashboard.

[code lang="php"]
function remove_dashboard_widgets() {
    // Globalize the metaboxes array, this holds all the widgets for wp-admin

    global $wp_meta_boxes;
    //remove all default dashboard apps
    unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_right_now']);
    unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_recent_comments']);
    unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_incoming_links']);
    unset($wp_meta_boxes['dashboard']['normal']['core']['dashboard_plugins']);
    unset($wp_meta_boxes['dashboard']['side']['core']['dashboard_quick_press']);
    unset($wp_meta_boxes['dashboard']['side']['core']['dashboard_recent_drafts']);
    unset($wp_meta_boxes['dashboard']['side']['core']['dashboard_primary']);
    unset($wp_meta_boxes['dashboard']['side']['core']['dashboard_secondary']);
}

// Hoook into the 'wp_dashboard_setup' action to register our function

add_action('wp_dashboard_setup', 'remove_dashboard_widgets');
[/code]
Put that block of code in your functions.php file, if it is a template you're working on or include it somewhere if it is a plugin.
That's all there is to it... In my next post I'll show you how to add your own modules.
Further reading:

[http://codex.wordpress.org/Dashboard_Widgets_API](http://codex.wordpress.org/Dashboard_Widgets_API)
