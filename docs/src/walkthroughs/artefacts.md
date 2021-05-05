# Saving and Artefacts

Artefacts collect changes to blocks and allow saving these changes to the system.
In this video, we create an artefact that acts as a convenient editor over existing Squeak/Smalltalk classes.

We also demonstrate how to generate blocks quickly and conveniently.

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%;"><iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://player.vimeo.com/video/545451309" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe></div>

### Basic Steps

1. Create a block subclass
2. Return `true` from `isArtefact`
3. Implement `saveTryFixing:quick:` and return `true` or `false`

### Generating Blocks

By using the SBStBuilder class, you can quickly generate or save blocks.
Explore its methods to see more.

To create a block without saving it, do `[:b | b to: (b name: 'Object') send: #new] sbStBuild`.
If you are creating an artefact, such as a method or class, you can call `sbStSave` instead, which will build the block, call save on it, and finally return it.
