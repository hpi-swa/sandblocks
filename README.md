# Sandblocks
A projectional editor for Squeak/Smalltalk.

This is a research prototype. Hiccups during usage are very much expected. Save often.

![The sandblocks editor](https://raw.githubusercontent.com/tom95/sandblocks/master/screenshots/sandblocks.png)

### Installing
Make sure you're running on a Squeak5.3 image (in beta at the time of writing, find one [here](https://files.squeak.org/5.3beta/) if necessary).
Then run:
```smalltalk
Metacello new
  baseline: 'Sandblocks';
  repository: 'github://tom95/Sandblocks:master/packages';
  load.

SBEditor openFor: Morph>>#openInWorld:
```
