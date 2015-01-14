---
author: zcourts
comments: true
date: 2013-05-31 21:30:33+00:00
layout: post
slug: angularjs-if-you-dont-have-a-dot-youre-doing-it-wrong
title: 'AngularJS: If you don''t have a dot, you''re doing it wrong!'
wordpress_id: 583
categories:
- Javascript
tags:
- angularjs
- bindings
- models
- nest scope
- properties
- reference types
- scopes
- two way binding
---

This has bitten me twice in the last 3 days so I'm doing a quick post to remind myself.

With AngularJS models, you typically have two way bindings between UI elements and your controller's properties. Directly from the [docs](http://docs.angularjs.org/api/ng.directive:input.text) ([Plunker](http://plnkr.co/edit/PCUFA3yARnIdpks84W4Z))

```javascript

<!doctype html>
<html ng-app>
 <head>
 <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.6/angular.min.js"></script>
 <script src="script.js"></script>

</head>
 <body>

<form name="myForm" ng-controller="Ctrl">
 Single word: <input type="text" name="input" ng-model="text"
 ng-pattern="word" required>
 <span class="error" ng-show="myForm.input.$error.required">
 Required!</span>
 <span class="error" ng-show="myForm.input.$error.pattern">
 Single word only!</span>

<tt>text = {{text}}</tt><br/>
 <tt>myForm.input.$valid = {{myForm.input.$valid}}</tt><br/>
 <tt>myForm.input.$error = {{myForm.input.$error}}</tt><br/>
 <tt>myForm.$valid = {{myForm.$valid}}</tt><br/>
 <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br/>
 </form>
 </body>
</html>

```

<!-- more -->JavaScript

```javascript

function Ctrl($scope) {
 $scope.text = 'guest';
 $scope.word = /^\w*$/;
}

```

This all works great until you get a simple property that's a 'primitive' so numbers, boolean etc. and you need to use this property within an angular repeater or another directive which creates its own scope. The problem is that, because JavaScript is a pass by value language, primitive types are copied within nested scopes. This means that, if a property changes within a local scope, the original/parent version of the property isn't updated with those changes. Not only that, angular (for good reason) no longer allow duplicates within a repeater, which is what lead me to [StackOverflow](http://stackoverflow.com/a/15975118/400048) the first time I encountered this.

The solution is simply replace the primitive with a JavaScript hash/object so instead of doing something like this:

```javascript

function Ctrl($scope) {
$scope.myProperty =true;
}

```

You should do

```javascript

function Ctrl($scope) {
$scope.myProperty ={someName:true};
}

```

I highly recommend watching this talk by [Miško Hevery](http://www.youtube.com/watch?v=ZhfUv0spHCY) on AngularJS best practices. I've watched it...not I just need to remember all of it :D

[youtube=http://www.youtube.com/watch?v=ZhfUv0spHCY]

For further reading, Jim Hoskins did a more in depth write up on [nested scopes in AngularJS](http://jimhoskins.com/2012/12/14/nested-scopes-in-angularjs.html).
