# Setting up Squeak

In this walkthrough, we present a couple of preferences that we recommend you enable in Squeak, followed by a couple of debugging or exploration workflows.

In between our image even crashes, so we got to demonstrate recovering unsaved changes you made after a crash.

<iframe src="https://player.vimeo.com/video/541134203" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>

# Recap

1. Preferences mentioned
    * Open tools attached to cursor
    * Mouse over for keyboard focus
    * Auto enclose brackets
    * Enclose selection with brackets
2. Packages mentioned
    * [Autocompletion](https://github.com/LeonMatthes/Autocompletion)
    * [Sandblocks](https://github.com/tom95/sandblocks)
3. Shortcuts mentioned
    * Global
      * `Ctrl+w` close window (if enabled in `SystemWindow>>#filterEvent:for:`)
      * `Ctrl+Shift+Q` save image (if enabled in `PasteUpMorph>>#tryInvokeKeyboardShortcut:`)
      * `Ctrl+0` to focus search
      * `Middleclick`/`Alt+Leftclick` open halo (add `Shift` to start from the innermost)
      * `Alt+.` halt execution of current process (e.g. when in an infinite loop)
    * Editing/Evaluating
      * `Ctrl+f` in the class list to find a class
      * `Alt+num` to insert the num'th argument
      * `Ctrl+p` print selected expression or full line
      * `Ctrl+d` do selected expression or full line
      * `Ctrl+Shift+I` evaluate selected expression or full line and explore result
    * Exploring code
      * `Ctrl+b` browse class of object or selected class name
      * `Ctrl+n` show senders of selected symbol
      * `Ctrl+m` show implementors of selected symbol
      * `Ctrl+Shift+N` show references to selected variable or class
4. Methods mentioned
    * `self halt`
    * `self haltOnce`
    * `1 setHaltOnce`

