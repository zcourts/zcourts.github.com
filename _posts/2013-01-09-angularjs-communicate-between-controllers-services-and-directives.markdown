---
author: zcourts
comments: true
date: 2013-01-09 02:45:50+00:00
layout: post
slug: angularjs-communicate-between-controllers-services-and-directives
title: AngularJS - Communicate between controllers, services and directives
wordpress_id: 487
categories:
- Javascript
tags:
- angularjs
- events
- jquery
- pubsub
---

This solution uses JQuery.
I already include JQuery in the page so why not use it. If you need a non-JQuery solution here are a few links:

[StackOverflow suggestions](http://stackoverflow.com/questions/11252780/whats-the-correct-way-to-communicate-between-controllers-in-angularjs)
[Video tutorial](http://onehungrymind.com/angularjs-communicating-between-controllers/)
[Native AngularJS broadcast](http://docs.angularjs.org/api/ng.$rootScope.Scope#$broadcast)


```javascript
angular.module('fillta.service.Events', ['ngResource'])
    .factory('Events', function () {
        var el = document.createElement('div')
        var EventsListener = {
            on:function (event, callback, unsubscribeOnResponse) {
                $(el).on(event, function () {
                    if (unsubscribeOnResponse) {
                        $(el).off(event, el, callback)
                    }
                    callback.apply(this, arguments) //invoke client callback
                })
            },
            emit:function (event) {
                $(el).trigger(event, arguments)
            }
        }
        return EventsListener;
    })
```



This is a very quick and dirty entry. Essentially JQuery already has an amazing, cross-browser event system implemented. Its included in the page to make use of a few plugins, it seemed like a better idea to just use it over the other work arounds. And it seems (apparently, not tested myself) the native AngularJS way can be inefficient.

Stick that block of code in your services file. whenever you need to use it in another server or controller just add "Events" as a dependency then you can use, Events.emit('event',arg1,arg2) and in your other controllers subscribe using Events.on('event',function(arg1,arg2){},false) - The third argument is optional, if true then a function is unsubscribed when the event is emitted for the first time, otherwise it stays subscribed and listen for events.


That's it. I have about 30 unpublished posts I need to finish off - Hopefully get the time soon but look forward to some tutorials and info on my experiences working with a range of technologies the last 7+ months (NodeJS,Socket.IO,Cassandra,AngularJS,requireJS,Netty,Higgs and loads more). Hope it is useful.
