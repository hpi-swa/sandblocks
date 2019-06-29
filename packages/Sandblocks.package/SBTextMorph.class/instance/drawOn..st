as yet unclassified
drawOn: aCanvas
	"Draw the receiver on a canvas -- copy because self color was not used here and we want to change based on constrast "

	| fauxBounds |
	self setDefaultContentsIfNil.
	false ifTrue: [self debugDrawLineRectsOn: aCanvas].  "show line rects for debugging"
	(self startingIndex > text size)
		ifTrue: [self drawNullTextOn: aCanvas].
	"Hack here:  The canvas expects bounds to carry the location of the text, but we also need to communicate clipping."
	fauxBounds := self bounds topLeft corner: self innerBounds bottomRight.
	aCanvas paragraph: self paragraph bounds: fauxBounds color: self color