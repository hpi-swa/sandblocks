as yet unclassified
saveTryFixing: aBoolean quick: aQuickBoolean

	| text newSelector |
	self allBlocksDo: [:block |
		block valid ifFalse: [
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	text := aQuickBoolean ifTrue: [self sourceString] ifFalse: [self prettySourceString].
	newSelector := self methodClass compile: text asText.
	(self currentClass ~= self methodClass or: [self currentSelector ~= #'' and: [newSelector ~=self  currentSelector]]) ifTrue: [
		self currentClass removeSelector: self currentSelector].
	self currentSelector: newSelector.
	
	aQuickBoolean ifFalse: [self updatePCs].
	self hasUnsavedChanges: false.
	^ true