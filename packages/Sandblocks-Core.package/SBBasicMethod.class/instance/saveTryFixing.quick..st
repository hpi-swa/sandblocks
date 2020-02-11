as yet unclassified
saveTryFixing: aBoolean quick: aQuickBoolean

	| text newSelector |
	self allBlocksDo: [:block |
		block valid ifFalse: [
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	text := aQuickBoolean ifTrue: [self sourceString] ifFalse: [self prettySourceString].
	newSelector := self methodClass compile: text asText.
	(self currentSelector ~= #'' and: [newSelector ~=self  currentSelector]) ifTrue: [
		self methodClass removeSelector: self currentSelector].
	self currentSelector: newSelector.
	
	aQuickBoolean ifFalse: [self updatePCs].
	^ true