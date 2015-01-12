---
author: zcourts
comments: true
date: 2011-02-13 09:00:50+00:00
layout: post
slug: create-custom-widgets-or-modules-for-the-wordpress-dashboard
title: Create custom widgets for the wordpress dashboard
wordpress_id: 57
categories:
- PHP
- Wordpress
---

Following on from my previous post on [how to remove the default widgets/modules on the wordpress dashboard](http://www.crlog.info/tutorials/remove-the-default-dashboard-widgets-from-wordpress-programatically.html), today I'm going to show you how quick and simple it is to add your own custom widget/module that displays or does what ever you want it to.

The code below creates to widgets on our dashboard with the title of posts from two different categories,
specified by the cat=x parameter.

[code lang="php"]
 // add 10 most recent post to dashboard from category with id 10
 function blogPost_widget() {
 $recentPosts = new WP_Query();
 $recentPosts->query('showposts=10&cat=10');
 ?>
 <ul>
 <?php
 while ($recentPosts->have_posts()) : $recentPosts->the_post();
 ?>
 <li><a href="<?php  the_permalink(); ?>"><?php the_title(); ?></a></li>
 <?php endwhile; ?>
 </ul>
 <?php
 }
 //adds news widget to dashboard
 function blogNews_widget() {
 $recentPosts = new WP_Query();
 $recentPosts->query('showposts=10&cat=1');
 ?>
 <ul>
 <?php
 while ($recentPosts->have_posts()) : $recentPosts->the_post();
 ?>
 <li><a href="<?php echo the_permalink() ?>" ><?php the_title(); ?></a></li>
 <?php endwhile; ?>
 </ul>
 <?php
 }
 // Create the function use in the action hook

 function add_dashboard_widgets() {
 //this will display titles and links to the blog posts
 wp_add_dashboard_widget('blogPost_widget', 'Recent Blog Posts', 'blogPost_widget');//widget one
 wp_add_dashboard_widget('blogNews_widget', 'Company news', 'blogNews_widget');//widget two
 }

 // Hook into the 'wp_dashboard_setup' action to register our other functions

 add_action('wp_dashboard_setup', 'add_dashboard_widgets');
 [/code]

The above code goes into your functions.php file for a template or anywhere in your plugin file. Taken directly from the wordpress documentation, the wp_add_dashboard_widget is the magic function here,
it gives our widget an ID and a name and tells wordpress which function to invoke when creating the widget.
The parameters expected from the wordpress docs are:

<?php wp_add_dashboard_widget($widget_id, $widget_name, $callback, $control_callback ); ?>

**Parameters**

$widget_id

([_integer_](http://codex.wordpress.org/How_to_Pass_Tag_Parameters#Integer)) (_required_) an identifying slug for your widget. This will be used as its css class and its key

in the array of widgets.

Default: _None_

$widget_name

([_string_](http://codex.wordpress.org/How_to_Pass_Tag_Parameters#String)) (_required_) this is the name your widget will display in its heading.

Default: _None_

$callback

([_string_](http://codex.wordpress.org/How_to_Pass_Tag_Parameters#String)) (_required_) The name of a function you create that will display the actual contents of your widget.

Default: _None_

$control_callback

([_string_](http://codex.wordpress.org/How_to_Pass_Tag_Parameters#String)) (_optional_) The name of a function you create that will handle submission

of widget options forms, and will also display the form elements.

Further reading: [http://codex.wordpress.org/Function_Reference/wp_add_dashboard_widget](http://codex.wordpress.org/Function_Reference/wp_add_dashboard_widget)
