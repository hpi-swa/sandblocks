# Custom Commands

To allow for undo and change tracking, all mutations to state in Sandblocks must be performed through commands.
Commands are subclasses of `SBCommand` that describe the change in the system:
```
SBReplaceCommand new
    target: ...;
    replacer: ...;
    yourself
```

To perform a command, call `do:` on the SBEditor:
```
self sandblockEditor do: (SBReplaceCommand new
    target: ...;
    replacer: ...;
    yourself)
```

Commands will ensure that the next artefact in the block tree will be marked as having unsaved changes after a command is applied.

## Combining Commands

Often, you will want to perform multiple things at once but they should be undo-able with a single click.
For this purpose, you may use the `SBCombinedCommand`:

```
SBCombinedCommand newWith: (targets collect: [:target |
    SBDeleteCommand new target: target])
```

## Some Built-in Commands
Here is a quick overview of some built-in commands. Use Ctrl+Shift+N in the Squeak image to see how each is used.

|Command         |Effect                 |
|----------------|-----------------------|
|SBMutateProperty|Change the field of an object, such the checked state of a checkbox|
|SBDeleteCommand |Delete a block|
|SBInsertCommand |Insert a block at a given index|
|SBReplaceCommand|Replace a block with another|

## Custom Commands

If you need to perform a more complicated side effect, often a custom command will be the easiest way to perform it.
Custom commands are simple to implement: subclass `SBCommand` and implement `do` and `undo`.
You can consider subclassing from a more specific command, such as the `SBDeleteCommand` if both a block should disappear and something else should happen in the system.

For a more lightweight alternative, you can also use the general purpose `SBDoItCommand` and combine it with another command, e.g.:
```
SBCombinedCommand newWith: {
    SBDoItCommand new
        do: [Transcript showln: 'deleted block'];
        undo: [Transcript showln: 'restored block'. self];
        yourself.
    SBDeleteCommand new
        target: self;
        yourself
}
```

But generally, a custom subclass is a preferred, as it allows inspecting the data inside the command more easily.
