# Frequently Asked Questions

**How do I open a morph in the editor?**

> In a Smalltalk workspace (open via the plus button up top), run:
> ```
> sbEditor openMorphInView: MyBlock new
> ```

**How do I copy-paste text into the blocks?**
> Whenever you use ctrl+c on a block, it is also copied to the system clipboard as text.
> To paste text from the system clipboard, use ctrl+shift+V.

**How do I select themes and which ones are recommended?**
> Right click into the editor or press ctrl+; to open the list of global actions.
> Filter for `color` and press enter.
> 
> Currently recommended themes are `ColorMinimal`, as well as `LightPlus`, `Solarized`, and `SolarizedDark`.

**Where can I find all the shortcuts?**
> Have a look at `SBTextInputMapping>>#registerDefaultShortcuts`.

**How do I (no longer) use the Sandblocks editor as default in all the Squeak tools?**
> Run `CodeHolder addSandblocksDefault: true` or `false` to still have it as an option but not make it the default.
