as yet unclassified
selectedMethodIndex: aNumber moved: aBoolean
	
	(aNumber < 1 and: [aBoolean])
		ifTrue: [selectedMethodIndex := self methods size]
		ifFalse: [
			aNumber > self methods size
				ifTrue: [selectedMethodIndex := 1]
				ifFalse: [selectedMethodIndex := aNumber]].
	
	self changed: #selectedMethodIndex.
	
	preview ifNotNil: #delete.
	
	(selectedMethodIndex > 0 and: [selectedClassIndex > 0]) ifTrue: [
		preview := SBSelection new
			methodClass: self selectedClass;
			colorPolicy: SBEditor defaultColorPolicy new;
			addMorphBack: self selectedMethod asSandblock.
		preview openInWorld.
		preview topCenter: self bottomCenter]