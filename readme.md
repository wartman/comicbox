Comicbox
========

A VS Code plugin to write comic scrips using the Boxup language.

Example
-------

Comicbox's syntax is simple. A script will look something like this:

```boxup
[Comic]
    title = Example Comic Script
    author = Peter Wartman
    version = 1
    date = 10/28/2020
    firstPageNumber = 1
    status = Published

[Page] 

    [/ Comments are valid anywhere! /]

    [Notes]
        The first panel here should be big -- really
        get that stormy atmosphere.

        Maybe like <this>[Link url = "some/url.png"]?

    [Panel]
        We open on a dark and stormy night.
  
    [Panel]
        FRED turns to his friend.

        [/ We can use special characters -- like `@` -- instead of having
           to write [Dialog character = FRED modifier = off]
        /]
        [@FRED modifier = off]
            [Mood] Looking around nervously

            Hey Bob, it sure is /stormy/ out here.
            
            [&] Kind of *scary*.

        [Dialog character = 'BOB\'S BOBSTINE']
            You got that right, friend.

    [Panel]
        There is a long and awkward silence.

[Page]

    [Panel]
        A lightning bolt comes out of nowhere and
        incinerates both characters. It is grisly
        and a bit horrifying.

        But also funny.

    [Panel]
        Fade to black.

        In a comic.

        You can figure it out.
```
