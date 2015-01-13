---
author: zcourts
comments: true
date: 2011-08-24 08:15:14+00:00
layout: post
slug: archimedean-spiral-plug-a-bit-of-maths-in-and-magic-will-happen
title: Archimedean Spiral - "Plug a bit of maths in and 'magic' will happen!"
wordpress_id: 350
categories:
- Algorithm
- Math
tags:
- archimedean
- archimedean spiral
- canvas
- drawing
- html5
---

After looking at a few options for placing stuff in an outward spiral I came across the [Archimedean Spiral](en.wikipedia.org/wiki/Archimedean_spiral). I'm rendering my items on an HTML5 canvas so this is all being done in Javascript. After implementing it I started to play around with the values a bit and produced some very interesting effects. Below are two of my favorites...

[![](http://crlog.files.wordpress.com/2011/08/archimedean-spiral.png)](http://crlog.files.wordpress.com/2011/08/archimedean-spiral.png)

Mind you this is being done with part-finished code so it may not even be a good way of achieving it but it did the trick and I thought I'd post it before the code morphs into something far beyond what's necessary/needed for this.

[![](http://crlog.files.wordpress.com/2011/08/archimedean-spiral-right.png)](http://crlog.files.wordpress.com/2011/08/archimedean-spiral-right.png)
The little Javascript/HTML snippet that does this is:
```js
        <canvas id="tags" width="1200" height="600"></canvas>     
        <script type="text/javascript">

            window.onload=function(){
                var c = document.getElementById('tags');
                var context = c.getContext("2d");
                var halfx = context.canvas.width / 2;
                var halfy = context.canvas.height / 2;


                context.clearRect(0, 0, 300, 300);

                context.moveTo(halfx, halfy);
                context.beginPath();
                //check if both the max X and Y edges have been reached
                var Xmaxxed=false,Ymaxxed=false;
                var i=0;
                while(!Xmaxxed||!Ymaxxed){
                    var x = i*0.1 * Math.cos(i);
                    var y = i*0.1 * Math.sin(i);
                    x=x+600;
                    y=y+300;
                    if(x>=c.width){
                        Xmaxxed=true;
                        console.log(["xMaxxed",x,y]);
                    }
                    if(y>=c.height){
                        Ymaxxed=true;
                        console.log(["yMaxxed",x,y]);
                    }
                    console.log(["Attempt "+i,x,y]);
                    context.lineTo(x, y);
                    i+=1;
                }
                context.strokeStyle = "#000";
                context.stroke();

            }
        </script>
```

Well, that's it, play around with the two lines
                   var x = i*0.1 * Math.cos(i);
                    var y = i*0.1 * Math.sin(i);
and see what effects you can come up with, I'd be interested to see more...
