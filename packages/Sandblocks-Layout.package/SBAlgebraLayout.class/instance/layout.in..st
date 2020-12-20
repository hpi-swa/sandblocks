as yet unclassified
layout: aMorph in: aRectangle

	| final initial |
	(self isAlgebraLayoutRoot: aMorph) ifFalse: [^ self].
	
	initial := ((SBAlgebraState new offset: aRectangle topLeft) startX: aRectangle left).
	final := self
		layoutDocument: (self commandsForRoot: aMorph)
		at: initial
		limit: aRectangle right
		wrap: false.
	
	" if we do not have an owner, enforce our minSize ourselves"
	(aMorph owner isNil or: [aMorph owner layoutPolicy isNil]) ifTrue: [
		aMorph extent: ((final extentFrom: initial) max: aRectangle extent) + aMorph layoutInset asEdgeInsets]