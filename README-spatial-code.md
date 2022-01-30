# Spatial Arrangement Of Software Systems

Here, we describe the project on spatial code.

![Screenshot of the subsystem](https://raw.githubusercontent.com/hpi-swa/sandblocks/live21/screenshots/spatial-code-light.png)
![Screenshot of the subsystem](https://raw.githubusercontent.com/hpi-swa/sandblocks/live21/screenshots/spatial-code-dark.png)

## Abstract

Conventional text editors usually struggle to present a lot of information simultaneously, e.g. one can have two files open at once, but any more than that usually hinders coding since most of the screen would be taken up by stuff. Additionally, other code inside the same file can only be accessed by scrolling.
Things get very cluttered when a bigger software system is in place, usually requiring many jumps between the different parts. 

Our approach to solving this is to arrange whole software systems spatially on a 2D canvas. The framework was Sandblocks, which already implemented arranging blocks of code on a canvas, which we improved upon. Specifically, we focused on the following aspects:

1. Correlating code via a force graph
2. Giving directions via indicators and waypoints
3. Visually grouping blocks
4. Saving and loading projects in 2D


## Installing

You can either directly use the [latest release](https://github.com/hpi-swa/sandblocks/releases/latest/download/sandblocks-all.zip) or install it in your Squeak 5.3 or trunk image as shown below.

To install it in an existing image, run:
```smalltalk
Metacello new
  baseline: 'Sandblocks';
  repository: 'github://hpi-swa/Sandblocks:master/packages';
  load: #tutorial.

SBEditor open.
```

## Usage

Make sure forces are activated in the Preferences ("Enable force-driven layout for blocks"). You can drag blocks onto other blocks to create a force between them. You can pin blocks from the context menu.

Blocks from methods inside the same class get automatically added to groups. Drag other blocks onto groups to add them. Remove blocks from groups via the context menu.

You can create waypoints from the Palette when any block is selected. You can highlight indicators using the context menu. You can hide non-waypoint indicators by setting "Hide always-visible offscreen indicators" in the Preferences.

You can save your spatial layout using "Save current blocks" in the context menu. You can load your saved layout using "Load blocks".
