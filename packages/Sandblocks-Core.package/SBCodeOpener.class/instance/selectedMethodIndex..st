as yet unclassified
selectedMethodIndex: aNumber

	selectedMethodIndex := aNumber.
	self changed: #selectedMethodIndex.
	
	preview ifNotNil: #delete.
	
	(selectedMethodIndex > 0 and: [selectedClassIndex > 0]) ifTrue: [
		preview := SBSelection new
			methodClass: self selectedClass;
			colorPolicy: SBDefaultColorPolicy new;
			addMorphBack: self selectedMethod asSandblock.
		preview openInWorld.
		preview topCenter: self bottomCenter]