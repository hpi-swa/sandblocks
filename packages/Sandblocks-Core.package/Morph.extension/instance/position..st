*Sandblocks-Core-override
position: aPoint 
	"Change the position of this morph, which is the top left corner of its bounds."
	
	| delta box |
	delta := (aPoint - self bounds topLeft) rounded.
	
	"Skip drawing and layout updates for null changes."
	(delta x = 0 and: [delta y = 0])
		ifTrue: [^ self].

	"Optimize drawing. Record one damage rectangle for short distance and two damage rectangles for large distances."
	box := self fullBounds.	
	(delta dotProduct: delta) > 100 "More than 10 pixels?"
		ifTrue: [self
					invalidRect: box;
					invalidRect: (box translateBy: delta)]
		ifFalse: [self
					invalidRect: (box merge: (box translateBy: delta))].
	
	"Move this morph and *all* of its submorphs."
	self privateFullMoveBy: delta.
	
	self triggerEvent: #positionChanged.
	
	"For all known layout policies, my layout and the layout of my children is fine. Only the layout of my owner might be affected. So, tell about it."
	self owner ifNotNil: [:o | 
		self flag: #todo. "mt: Maybe we can save a lot of effort and troubles by only calling #layoutChanged if the owner has a layout policy installed? Take the thumbs of scroll-bars as an example..."
		o layoutChanged].