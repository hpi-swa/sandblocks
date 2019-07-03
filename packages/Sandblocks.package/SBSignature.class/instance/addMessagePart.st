as yet unclassified
addMessagePart

	self isUnary ifTrue: [
		currentInputMessagePart contents: currentInputMessagePart contents, $:.
		^ self addArgumentAndEditAfter: currentInputMessagePart focusKeyword: nil].
	
	(self isKeyword and: [(currentInputMessagePart contents occurrencesOf: $:) > 1]) ifTrue: [ | msg | 
		msg := currentInputMessagePart contentsBeforeCursor.
		msg last ~= $: ifTrue: [msg := msg, $:].
		currentInputMessagePart contents: (currentInputMessagePart contentsAfterCursor withFirstCharacterDownshifted ifEmpty: [':']).
		^ self
			addMessagePart: msg
			after: currentInputMessagePart submorphBefore
			focusKeyword: (currentInputMessagePart contents = ':' ifTrue: [currentInputMessagePart])]