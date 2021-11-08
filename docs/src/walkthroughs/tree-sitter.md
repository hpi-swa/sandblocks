# Tree Sitter

In this video, we work with Sandblocks' Tree Sitter backend, giving us access to languages such as Python or Javascript.
We create a replacement for Javascript's `window.fetch` and a palette for Javascript.

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%;"><iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://player.vimeo.com/video/643502024" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe></div>

## Git Setup Links
* `git clone` [git@github.com:tom95/sandblocks](https://github.com/tom95/sandblocks)
* `git clone` [git@github.com:hpi-swa-lab/sb-tree-sitter](https://github.com/hpi-swa-lab/sb-tree-sitter)

## Relevant Entrypoints

* `SBTSPalette`: superclass for custom palettes. Make sure to look at its class-side.
* `SBInlineBlockReplace`: superclass for replacing blocks with custom morphs
* `applyReplacements` / `Ctrl/Cmd+r`: action / shortcut for performing all matching replacements on a block
* [Documentation](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries) for Queries in Tree Sitter
* [Playground](https://tree-sitter.github.io/tree-sitter/playground) for parsing and queris in Tree Sitter
