*Sandblocks-Core-override
extent: aPoint

	(bounds extent closeTo: aPoint) ifTrue: [^ self].
	self changed.
	bounds := (bounds topLeft extent: aPoint) rounded.
	self removeProperty: #dropShadow.
	self layoutChanged.
	self changed.

	self triggerEvent: #extentChanged.