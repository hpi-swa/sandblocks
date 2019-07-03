as yet unclassified
addMessagePart

	self isUnary ifTrue: [ 
		currentInputMessagePart contents: currentInputMessagePart contents, $:.
		^ self addArgumentAndEditAfter: currentInputMessagePart].
	
	self isKeyword ifTrue: [ | new |
		"currentInputMessagePart isCursorAtStart ifTrue: [
			new := self textMorphFor: ':'].
		"
		new := self textMorphFor: currentInputMessagePart contentsBeforeCursor, $:.
		currentInputMessagePart contents: currentInputMessagePart contentsAfterCursor withFirstCharacterDownshifted.
		self addMorph: new inFrontOf: currentInputMessagePart.
		^ self addArgumentAndEditAfter: new]