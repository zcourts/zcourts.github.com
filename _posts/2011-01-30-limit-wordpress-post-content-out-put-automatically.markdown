---
author: zcourts
comments: true
date: 2011-01-30 15:03:32+00:00
layout: post
slug: limit-wordpress-post-content-out-put-automatically
title: Limit wordpress post content out put automatically
wordpress_id: 50
categories:
- PHP
- Tutorials
- Wordpress
---

This is a quick and dirty hack to limit the amount of words wordpress outputs on your homepage.

Its sometimes not ideal to have the entire post showing on the homepage when you have really long posts. 10 or 15 long posts will make the page take forever to load, especially if they all have images.

First thing to do is backup your theme's index.php file. So go to wp-content/themes/your-theme-name/ and make a copy of index.php
just in case you mess it up and forget what the original content was...

Open the file, (the original, not the copy ) and find where it has the_content();
Replace it with:

[code lang="php"]
<?php
$content = get_the_content();//apply_filters('the_content', $content);
$content = str_replace(']]>', ']]&gt;', $content);
$con=explode(" ",$content);
$i=0;
while($i<50 && $i<count($con)){
echo $con[$i]." ";
$i++;<
}
?>
<a href="<?php the_permalink(); ?>" rel="bookmark" title="
<?php the_title_attribute(); ?>">... <br />Continue reading, <?php the_title(); ?>.</a>
[/code]

Change 50 in the loop to the amount of words you want to allow. When done just save and re-upload the file.

Further reading:
[codex.wordpress.org/Template_Tags/the_content](codex.wordpress.org/Template_Tags/the_content)
