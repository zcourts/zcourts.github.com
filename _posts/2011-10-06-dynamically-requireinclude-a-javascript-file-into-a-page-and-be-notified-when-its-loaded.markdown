---
author: zcourts
comments: true
date: 2011-10-06 07:46:15+00:00
layout: post
slug: dynamically-requireinclude-a-javascript-file-into-a-page-and-be-notified-when-its-loaded
title: Dynamically require/include a Javascript file into a page and be notified when
  its loaded
wordpress_id: 377
categories:
- Javascript
tags:
- callback
- external file
- include
- javascript
- onload
- onreadystatechanged
- require
---

This is a simple little JavaScript snippet I wrote the other day that basically includes an external javascript file in an HTML page head section.

Its pretty straight forward,



	
  * it first gets a reference to the head tag.

	
  * Creates a script element using document.createElement

	
  * Sets the source/url of the file

	
  * sets the type of the script element to the correct mime type of "text/javascript"

	
  * Then sets the onload property of the script element to a callback function you supply. In i.e. it will check the onreadystatechange and execute the callback function you provide.

	
  * And finally it appends the script element to the head of the page



```js

		/**
		 *Load an externl JS file and append it to the head
		 */
		function require(file,callback){
			var head=document.getElementsByTagName("head")[0];
			var script=document.createElement('script');
			script.src=file;
			script.type='text/javascript';
			//real browsers
			script.onload=callback;
			//Internet explorer
			script.onreadystatechange = function() {
				if (_this.readyState == 'complete') {
					callback();
				}
			}
			head.appendChild(script);
		}
```

Probably a million and one ways to do this but it works decently in I.E 7+,Firefox,Chrome,Safari and Opera
