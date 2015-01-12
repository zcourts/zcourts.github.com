---
author: zcourts
comments: true
date: 2011-07-03 07:11:26+00:00
layout: post
slug: creating-a-string-class-to-represent-and-manipulate-strings-in-php
title: Creating a String class to represent and manipulate strings in PHP
wordpress_id: 303
categories:
- PHP
- Programming
tags:
- class
- php
- php string class
- phpunit
- string
- unit testing
---

In getting started with PHPUnit, I didn't have any code I felt like writing unit tests for. Mainly because I wanted to start with something very simple. I started writing some code, one thing lead to another and I ended with a simple class to represent a string. It only has a few methods but it was more than enough to provide me with quite a few test cases. The unit test for the class in another post I'm going to do soon. (<del>PHP Unit tests for string class is here</del>)

<!-- more -->The class then is:

[code lang="PHP"]
<?php

class String {

    /**
     * The string content this object respresents
     * @var string
     */
    var $string;

    public function __construct($chars=NULL) {
        if ($chars != NULL) {
            $this->string = $chars;
        }
    }

    /**
     * @return integer The size/length of the string in its current state
     */
    public function size() {
        return strlen($this->string);
    }

    /**
     * Find and return the charcater at a given position
     * @param integer $idx
     * @return mixed NULL if the idnex is invalid or the character found at the
     * specified index.
     */
    public function charAt($idx) {
        if ($idx < 0 || $idx > strlen($this->string)) {
            return NULL;
        }
        return substr($this->string, $idx, 1);
    }

    /**
     * Compares two strings to determine if they are the same. Two strings are the
     * same , IF AND ONLY IF they have the same length and the same set or characters
     * in the same order.
     * @param string $someStr the string to compare to
     * @package $caseSensitive (Optional) Defaults to true, if true the a case sensitive
     * compaison is done, if false an in-case sensitive comparison is done.
     * @return Returns null if the parameter is an object that is not itself a String
     * or returns -1 if the string this object represent is less than the parameter
     * and 1 if it is greater and 0 if they're equal
     * So -1 if this string is less than the parameter;
     * 1 if this striing is greater than the paramter, and 0 if they are equal.
     *
     * if strings are the same length and chars don't match in exactly the same order
     * then -2 is returned
     */
    public function compareTo($someStr, $caseSensitive=TRUE) {
        if (is_object($someStr)) {
            if ($someStr instanceof String) {
                $someStr = $someStr->toString();
            } else {
                return NULL;
            }
        }
        if (strlen($this->string) < strlen($someStr))
            return -1;
        if (strlen($this->string) > strlen($someStr))
            return 1;
        //if they are the same length then compare chars
        $val = $this->string;
        if (!$caseSensitive) {
            $someStr = strtolower($someStr);
            $this->string = strtolower($this->string);
        }
        for ($i = 0; $i < strlen($this->string); $i++) {
            if ($val[$i] != $someStr[$i]) {
                //if strings are the same length and chars don't match
                return -2;
            }
        }
        //if the strins are a perfect match in length and chars
        return 0;
    }

    /**
     * Replace thw string this object represents and set the new string
     * specified in the param.
     * @param string $str The string to set
     * @return true if the string is set successfully false otherwise
     */
    public function setString($str) {
        if (!is_object($str)) {
            $this->string = $str;
            return true;
        }
        return false;
    }

    /**
     * Returns the string value this object represents after any operations
     * have been performed on it.
     * @return string
     */
    public function toString() {
        return $this->string;
    }

}
[/code]

As you can see it only has a few methods. I might add some more but there wasn't much point to writing this other than to get some unit tests written.
