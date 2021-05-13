# Drag and Drop

Drag and drop is enabled on all blocks in Sandblocks by default.
Those, that have a Move Decorator, can be picked up via Ctrl+Drag.
If the user holds Shift when starting to drag, the block is instead duplicated instead of moved.

In the previous chapter on lists, we saw that by implementing `fixedNumberOfChildren`, child blocks can be added to our custom block.
If we do so, dragging another block onto our custom block, will prompt the user to insert the block.

For blocks that do have a `fixedNumberOfChildren`, dropping a block will instead replace the block.

## Custom Drop Handling

If, instead, you want to have custom logic be performed when a block is dropped, implement `specialDropCommand:` on your block class.
`specialDropCommand:` receives the candidate block that is about to be dropped onto your block and should return a command that would be executed if the block was released.

> You must never perform side effects in `specialDropCommand:`, as it is also called to just check whether a special command is available.

For example, assume our custom block should log the name of the dropped block to the `Transcript`:

```
CustomBlock>>specialDropCommand: aBlock

    ^ (SBDoItCommand newFor: self containingArtefact)
        do: [Transcript showln: aBlock asString]
```
