# Sandblocks
A projectional editor for Squeak/Smalltalk.

This is a research prototype. Hiccups during usage are very much expected. Save often.

![The sandblocks editor](https://raw.githubusercontent.com/tom95/sandblocks/master/screenshots/sandblocks.png)

### Installing
Make sure you're running on a Squeak5.3 image. Then run:
```smalltalk
Metacello new
  baseline: 'Sandblocks';
  repository: 'github://tom95/Sandblocks:master/packages';
  load: #tutorial.

SBTutorialSnippets workspace.
```
