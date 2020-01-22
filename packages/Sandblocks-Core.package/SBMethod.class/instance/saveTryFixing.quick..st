as yet unclassified
saveTryFixing: aBoolean quick: aQuickBoolean

	| text newSelector |
	self allBlocksDo: [:block |
		block valid ifFalse: [
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	text := aQuickBoolean ifTrue: [self sourceString] ifFalse: [self prettySourceString].
	newSelector := self methodClass compile: text asText.
	(currentSelector ~= #'' and: [newSelector ~= currentSelector]) ifTrue: [
		self methodClass removeSelector: currentSelector].
	currentSelector := newSelector.
	
	aQuickBoolean ifFalse: [self updatePCs].
	^ true