# Custom Palettes

In this walkthrough, we create a custom palette that is only active if we are in a subclass of the `System` class.

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%;"><iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://player.vimeo.com/video/541133965" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe></div>

## Recap: The Basic Steps
1. Create a subclass of `SBPalette`.
2. Implement its `#context` method on the **class** side to match against the block selection.
3. Implement the `#buildOn`: method on the **class** side to return pre-built blocks.
