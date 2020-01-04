as yet unclassified
checkExclusiveFocusTo: aBlock

	| lens |
	aBlock ifNotNil: [
		lens := aBlock codeContainer.
		(lens notNil and: [lens owner = self and: [lens ~= aBlock]]) ifTrue: [
			lens expand.
			self submorphsDo: [:morph | morph = lens ifFalse: [morph collapseCompletely]]]]