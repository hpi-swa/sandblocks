as yet unclassified
addMessagePart

	self isUnary ifTrue: [ 
		currentInputMessagePart contents: currentInputMessagePart contents, $:.
		^ self addArgumentAndEditAfter: currentInputMessagePart].
	
	self isKeyword ifTrue: [ | new |
		new := self textMorphFor: currentInputMessagePart contentsBeforeCursor, $:.
		currentInputMessagePart contents: currentInputMessagePart contentsAfterCursor.
		self addMorph: new inFrontOf: currentInputMessagePart.
		^ self addArgumentAndEditAfter: new]