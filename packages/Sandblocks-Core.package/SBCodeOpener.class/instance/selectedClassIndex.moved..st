as yet unclassified
selectedClassIndex: aNumber moved: aBoolean

	(aNumber < 1 and: [aBoolean])
		ifTrue: [selectedClassIndex := self classes size]
		ifFalse: [
			aNumber > self classes size
				ifTrue: [selectedClassIndex := 1]
				ifFalse: [selectedClassIndex := aNumber]].

	self changed: #selectedClassIndex.
	self changed: #methods.
	self selectedMethodIndex: 0 moved: false