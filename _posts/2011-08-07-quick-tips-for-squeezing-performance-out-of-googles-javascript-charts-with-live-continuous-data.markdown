---
author: zcourts
comments: true
date: 2011-08-07 10:18:42+00:00
layout: post
slug: quick-tips-for-squeezing-performance-out-of-googles-javascript-charts-with-live-continuous-data
title: Quick tips for squeezing performance out of Google's Javascript charts with
  live (continuous) data/streams
wordpress_id: 332
categories:
- Javascript
tags:
- google charts
- javascript
- live chart
- memory
- memory leaks
- real time
- real time processing
---

I, until a few days ago always used JQuery for literally everything that needed Javascript. I've recently needed to use [Google charts](http://code.google.com/apis/chart/) to show a live graphical representation of data. It needed to be a widget that didn't rely on any framework so I had to brush up on my Javascript and forget all the easy stuff JQuery usually gives me! The chart would be updated EVERY SECOND, yeah pretty often! In every second there could be any amount of new points to be plotted. In addition, I'm only interested in points that have occurred within a fixed time period, the results of all this will be an "animated" graph that shifts left when data is updated.<!-- more -->

On my first implementation (took about 3 hrs), it all worked "great", or so I thought. After watching the graph work nicely for about 1hr ( I didn't sit and watch if you're wondering, I used console.log()!) chrome,firefox and IE just went poooof! IE (expectedly died a lot earlier than the others). To get an idea of what went wrong I restarted everything (killed Firefox and IE, leaving chrome with a single tab), watching my CPU and Memory usage...they did nothing but climb until the chrome process hit about 1GB, I got er, "Ooops, He's dead Jim" page...

It was obvious I had a nasty memory leak somewhere...I started going through the code, line by line. I did it over and over and only spotted one or two things that I thought could be the cause....Sadly, I was wrong so I started Googling around.

Like I said, I'm (or was) no Javascript programmer...I didn't even know about garbage collection in Javascript. I found a few interesting resources though:

One interesting thing I found was about closure...Understanding this (or something about it can work wonders!). Here are a list of interesting things I found that helped me nail the problem down.



	
  1. [Javascript closure (A must read)](http://jibbering.com/faq/notes/closures/), If this breaks use the [Google cached version](http://webcache.googleusercontent.com/search?q=cache:I58BNV-HedYJ:jibbering.com/faq/notes/closures/+javascript+closure&hl=en&gl=uk&strip=1),it was broken when I tried to access it.

	
  2. [Javascript closure (A more concise introduction)](http://www.javascriptkit.com/javatutors/closuresleak/index2.shtml)

	
  3. [Private Members](http://www.crockford.com/javascript/private.html) in Javascript

	
  4. [JavaScript and Memory leaks](http://www.javascriptkit.com/javatutors/closuresleak/index.shtml)

	
  5. [Javascript cyclic references](http://www.ibm.com/developerworks/web/library/wa-memleak/)

	
  6. [Useful tips](http://stackoverflow.com/questions/2986039/ipad-iphone-browser-crashing-when-loading-images-in-javascript)


As I found out, Javascript garbage collection is done diferently in different browsers... I highly recommend reading the info on the links above!

So what did I do to "fix" my memory leaks?
After reading the stuff above, I went over the code again,

	
  * I set properties to null after they were used, i.e. myObject.property=null

	
  * Used the delete  keyword on the properties that were set to null, i.e delete myObject.property ( Notice I said property. According to the [mozilla docs](https://developer.mozilla.org/en/JavaScript/Reference/Operators/Special/delete), the delete keyword doesn't work on variables that are either function references or declared using the var keyword.)-  From what I understand if myObject.property is not null then it may not be garbage collected depending on how it has been used so setting to null is your best bet if you want it gone.

	
  * I found and removed circular references (see bullet 5 above)

	
  * I used this.myproperty to store my live data object and other properties that were used multiple places

	
  * I set this.myproperty to null when necessary

	
  * Re-used this.myproperty instead of creating a new object


Google charts, what an amazing monster! When I first looked at its APIs, I thought "ehhhhhh", I didn't know this was possible with Javascript! It was easy to get going and my charts were looking good.  I adjusted a few settings in my program and watched the chrome process to work out that:

    
     *In 4 minutes 40MB of additional memory was used with timeout
     *of 10 seconds (i.e. update charts every 10 seconds instead of every second)
     *That's 10mb per minute and refreshed 6 times (60 seconds/10 seconds timeout) in a minute
     *so 10/6=1.6MB... memory per iteration/refresh...


So in my first version of the program ~1.6MB of memory was being added each time the chart was refreshed/redrawn. That is just terrible! Even more terrifying was the fact that it just grew and grew and never levelled off!

I commented out the chart drawing code and left all the other processing code to run. After monitoring the chrome process for a few minutes, about 10, the memory usage moved from about 40MB to 42MB, when I did the same thing, prior to reading up and optimizing the memory added over about 5 minutes was in excess of 100MB and kept growing, clearly my optimization was effective.

I left the chart drawing commented and left the process running for about an hour, give or take. The maximum memory I saw was 60MB and this went back down to the 40's in seconds!

I was happy with this now so I uncommented the graph code and it started going up again, admittedly by a lot less than before, and I suppose some increase was to be expected considering the stuff had to be drawn... After seeing the memory level off without the graph I was convinced the whole thing working together could level off at an acceptable memory level. I dug through the Google charts reference and found that, I don't need to recreate my datatable object each time.



	
  * Instead of recreating the [DataTable](http://code.google.com/apis/chart/interactive/docs/reference.html#DataTable), I used the remove rows method of the object to remove the first row to N, where N is the row number up to which I want to remove. So if I want to get rid of row numbers 0 to 5, I would use, mytable.removeRows(0,5)

	
  * The second thing I did was stopped the re-creation of a graph on each update (You have no idea how expensive this was!), I made the graph object a property accessible under this.mygraph - this would only ever be created once if it is null

	
  * Finally, I updated/refactored the code so that this.mygrapgh.chart is the only thing being invoked on each update.


The graph now works with real time data and updates every second, memory usage averages about 100MB, I've seen 120MB  but it sometimes drop as low as 80MB and hasn't grown any more. I would certainly like to think I've fixed the memory leaks, if I haven't I've done pretty well at whatever's made it stay consistently low for hours on end. The graph has so far processed over 78hrs of data and the 120MB is the highest I've seen.

I may have been a total novice (possibly still is) but I've definitely learnt a metric tonne from this (I even implemented a fairly advanced [key value set](https://github.com/zcourts/javascript-hashSet) to keep my data sorted and accessible by keys), I hope this hasn't all been a long rant and is useful to you or helps you pinpoint where your javascript program is blowing up.
