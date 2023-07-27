# Custom Projections

Here, we take the custom block from the previous walkthrough and map it to a Smalltalk constructor. Using this mapping, whenever this constructor is seen in Smalltalk code, it will instead be displayed as our custom block.

> **NOTES / API CHANGES:**
> * the first condition of `asWeatherReport:` should be `self selector = 'newFor:temperature:' ` instead of `self receiver isName`
> * an `object ^ self` method is no longer necessary but the default
> * instead of `#canAppearInBlockBody`, you should now only implement `#isExpression` (which also sets `#canAppearInBlockBody`)

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%;"><iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://player.vimeo.com/video/541133593" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe></div>

## Recap: Basic Steps
0. prepare your custom projection/widget
1. add a converter method to SBStMessageSend that matches the expressions you want to substitute for (optional: specify it as `<automatic>`)
2. implement `#writeSourceOn:` on your widget to produce Smalltalk code
3. mark the capabilities of your projection by returning `true` from `#isSmalltalk` and `#isExpression`
3. implement `#updatePCFrom:` to get debugging support (can leave it empty)
4. optional: add a converter method back to smalltalk using your `#writeSourceOn:`

