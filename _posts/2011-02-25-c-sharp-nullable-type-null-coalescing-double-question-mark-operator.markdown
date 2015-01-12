---
author: zcourts
comments: true
date: 2011-02-25 12:25:04+00:00
layout: post
slug: c-sharp-nullable-type-null-coalescing-double-question-mark-operator
title: C (#) sharp - Nullable type (null-coalescing/ double question mark) operator
wordpress_id: 74
categories:
- C#
- Programming
---

I came across a very interesting operator today in C#.
At first I thought it was like a ternary operator but it turned out not to be. The operator "??", yes two question marks.

It is known as the "nullable type", "null-coalescing" or just the double question mark operator.

I've only come accross it in C# and according to the Microsoft, help page:
"The **??** operator returns the left-hand operand if it is not null, or else it returns the right operand."

The remarks went on to say:<!-- more -->

"A nullable type can contain a value, or it can be undefined. The **??** operator defines the default value to be returned when a nullable type is assigned to a non-nullable type. If you try to assign a nullable type to a non-nullable type without using the **??** operator, you will generate a compile-time error. If you use a cast, and the nullable type is currently undefined, an **InvalidOperationException** exception will be thrown."

While its not very common, it can offer very tricky questions in interviews as a friend of mine recently found out.
Some example code of using it, (taken from the help page again):

[code lang="csharp"]
// nullable_type_operator.cs
using System;
class MainClass
{
    static int? GetNullableInt()
    {
        return null;
    }

    static string GetStringValue()
    {
        return null;
    }

    static void Main()
    {
        // ?? operator example.
        int? x = null;

        // y = x, unless x is null, in which case y = -1.
        int y = x ?? -1;

        // Assign i to return value of method, unless
        // return value is null, in which case assign
        // default value of int to i.
        int i = GetNullableInt() ?? default(int);

        string s = GetStringValue();
        // ?? also works with reference types.
        // Display contents of s, unless s is null,
        // in which case display "Unspecified".
        Console.WriteLine(s ?? "Unspecified");
    }
}
[/code]

Further reading (References)

[http://msdn.microsoft.com/en-us/library/ms173224(VS.80).aspx
](http://msdn.microsoft.com/en-us/library/ms173224(VS.80).aspx)[http://msdn.microsoft.com/en-us/library/ms173224.aspx](http://msdn.microsoft.com/en-us/library/ms173224.aspx)
[http://www.superjason.com/archive/2007/06/21/the-little-known-c-sharp-question-mark-operator.aspx](http://www.superjason.com/archive/2007/06/21/the-little-known-c-sharp-question-mark-operator.aspx)
