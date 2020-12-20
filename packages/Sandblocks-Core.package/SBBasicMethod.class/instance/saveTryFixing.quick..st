as yet unclassified
saveTryFixing: aBoolean quick: aQuickBoolean

	| text newSelector |
	(self savedMethodHasComments and: [(UIManager default confirm: 'Currently saved version has comments that will be removed. Still save?') not]) ifTrue: [^ false].
	
	self allBlocksDo: [:block |
		block valid ifFalse: [
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	(self hasExternalModification not or: [(UIManager default confirm: 'Method may have changed elsewhere, continue?')])
		ifTrue: [self externalModification: false]
		ifFalse: [^ false].
	
	text := aQuickBoolean ifTrue: [self sourceString] ifFalse: [self prettySourceString].
	
	self ignoreChangeNotifierDuring: [
		newSelector := self methodClass compile: text asText.
		(self currentClass ~= self methodClass or: [self currentSelector ~= #'' and: [newSelector ~=self  currentSelector]]) ifTrue: [
			self currentClass removeSelector: self currentSelector]].
	self currentSelector: newSelector.
	self currentClass: self methodClass.
	
	aQuickBoolean ifFalse: [self updatePCs].
	^ true