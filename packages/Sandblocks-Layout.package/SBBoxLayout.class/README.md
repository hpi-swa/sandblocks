A BoxLayout is a layout policy laying out its children in one direction according to a height-for-width algorithm.

Each widget is asked a minimum and a natural size, which it is supposed to return via its `preferredSizeOf:in:` function. The layout then makes sure its container is at least the minimum size. If there is left-over space, we first try to make as many widgets as possible their natural size and attribute the rest of the space evenly to all widgets that have `expand` set to true.

Possible optimizations:
- cache queries to our minimumSizeOf:in:
- collect all the valid children once at the start