A PHTIcon displays an icon. Create it with one of the many class methods.

The current icon list is imported from FontAwesome. See https://fontawesome.com/icons for a full list. Names are changed, e.g. instead of 'align-center' write 'iconAlign_center'.

Internally, it holds a reference to the requested SVGMorph (SVGCache) as well as a cached form of the rendered result of that SVG at the required size (FormCache).