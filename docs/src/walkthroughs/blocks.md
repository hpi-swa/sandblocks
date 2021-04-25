# Custom Blocks

Here, we define a custom block that should act as a little weather widget.

We show how to work with and debug layouts and how to get a live preview of our work while in Sandblocks.

<iframe src="https://player.vimeo.com/video/541133346" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>

## Recap: Interesting Commands

* `sbEditor openMorphInView: MyBlock new` when run in a Smalltalk workspace, opens `MyBlock` in the current editor
* `SBMorphExample` autocompletion: expands to a preview window for your block that reloads when you change the code
* `SBIcon` class for icons, here's the [full list](https://fontawesome.com/v4.7.0/icons/)
* `self attachDecorator: SBMoveDecorator new`, make the block move when left-click-dragged
* `<action>` pragma, mark a method as an action to show up in the context menu and be invokable via shortcuts
* `<globalAction>` pragma, a method that should appear in the context menu of the editor (can also be mapped to shortcuts, `<action>` shortcuts take precedence before `<globalAction>` shortcuts)
* `SBTextInputMapping>>#registerDefaultShortcuts`, list of all shortcut to action mappings
