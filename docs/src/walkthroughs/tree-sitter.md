# Tree Sitter

In this video, we work with Sandblocks' Tree Sitter backend, giving us access to languages such as Python or Javascript.
We create a replacement for Javascript's `window.fetch` and a palette for Javascript.

> **Notes & Errata**
> 
> [41min04] instead of calling `SBJavascript parse: '2 + 2'` it is now recommended to call `SBJavascript parseElement: '2 + 2'` if we only want a single parsed AST node instead of a full program
>
> [46min09] when we add the `factory:` call for the palette block, use `SBJavascript instance` instead of `SBJavascript new` to avoid rebuilding the grammar.

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

## Questions and Common Patterns

### Adding Existing Tree Sitter Blocks Inside a Replacement
This is generally easy, just add them as you usually would and include a `buildCopy` to support undo:
```smalltalk
SBBlock new addMorphBack: aTSBlock buildCopy.
```
(Without `buildCopy` the replaced block will contain a hole where the nested block used to be, breaking undo).

### Adding New Tree Sitter Blocks Inside a Replacement
To create a new instance of a specific rule, use e.g.:
```
SBBlock new addMorphBack: (SBPython build: 'expression')
```

If you need a complete block, you can use `parse:` or `parseElement:`:
```
SBBlock new addMorphBack: (SBPython parseElement: '3 + 4')
```
With `parseElement:`, you get the first child of the toplevel node.
In this specific example, the toplevel node is a `program`, nesting a `binary_operator`.
If you need multiple elements, use `parse:` instead:
```
SBPython parse:
'def a():
  pass
a()'
```

### Accessing Fields
Many Tree Sitter blocks contain field names, e.g.:
```javascript
pair: $ => seq(
  field('key', $._property_name),
  ':',
  field('value', $.expression)
)
```
You can access these using the `access` helper, e.g.
```
aPairBlock access key sourceString
```
This helper wraps the block in a proxy object that looks up field names and, if matched, returns the corresponding block. All other messages are forwarded to the wrapped block.

A more complex example:
```python
ax.set(12, "abc",
       xlim=(0,8), xticks=np.arange(1,8), ylim=(0,8), yticks=np.arange(1,8))
```
Query all arguments as either just plain values or key/value pairs:
```smalltalk
self access arguments children collect: [:arg |
  arg type = 'keyword_argument' ifTrue: [arg name contents -> arg value] ifFalse: [arg]]
```
Resulting in:
```
{(integer) . (string) . 'xlim'->(tuple) . 'xticks'->(call) . 'ylim'->(tuple) . 'yticks'->(call)}
```

You can send `fields` to any block to find what field names this block knows (e.g. a `keyword_argument` knows `name` and `value`).

### Creating a Replacement
1. Subclass `SBInlineBlockReplace`.
2. Create a matcher function on its class side (see video).
3. Build your UI.
4. Implement `writeSourceOn:` to produce textual source code that is the equivalent of your replacement.
5. Implement `type` to inform the system what sort of node you are replacing. For example, if you are replacing a `(call)` in python, simple return `^ 'call'` from `type`.
