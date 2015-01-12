---
author: zcourts
comments: true
date: 2011-02-16 00:33:54+00:00
layout: post
slug: algorithm-to-swap-the-values-of-two-variables-without-using-a-temporary-variable
title: Algorithm to swap the values of two variables without using a temporary variable
wordpress_id: 65
categories:
- Algorithm
- Java
- Programming
---

In a recent interview, I was asked whether or not it would be possible to swap the contents of two variables without using a temporary variable of any sort.

The scenario, given two variables X,Y where X=5 and Y=3; Swap the contents of the variables such that,
outputting X produces the value 3 and outputting Y produces the value 5. Your algorithm must only use the two variables
X and Y and you're allowed to perform any Mathematical operation on them to achieve the desired results.

What I came up with worked...sort of (that was on the fly without much time/thought). After thinking about the algorithm I came up with below achieves this using only the two variables by using addition and subtraction. (The below solution is an extension of what my original answer was).

The Java program (works in any language,easily translated)

[code lang="Java"]

/**
 *
 * @author Courtney
 */
public class Test {

    public static void main(String... args) {
        int y = 3;
        int x = 5;
        System.out.println(&quot;Original X and Y Value&quot;);
        System.out.println(&quot;Y : &quot; + y);
        System.out.println(&quot;X : &quot; + x);
        //add X on to Y so that we can take it off again later
        x = x + y;
        /**
         * We want to get the original X value into Y
         *we now know that sum(x)=x+y
         *therefore remove y =&gt; (x-y)
         */
        y = x - y;
        /**
         * At this point we know that the original X value is stored in Y,
         * we also know that X's value is x+y i.e. sum(x)=x+y
         * and we want X to get Y's original value so remove X's original
         * value and we're left with Y's original value
         */
        x = x - y;
        System.out.println(&quot;Swaped X and Y Value&quot;);
        System.out.println(&quot;Y : &quot; + y);
        System.out.println(&quot;X : &quot; + x);
    }
}

[/code]

The output from the program should be:

[code lang="Java"]
Original X and Y Value
Y : 3
X : 5
Swaped X and Y Value
Y : 5
X : 3
[/code]


Never thought about doing this before so I was caught completely off guard when asked...didn't even know it was
possible until I was asked... Hope it helps
