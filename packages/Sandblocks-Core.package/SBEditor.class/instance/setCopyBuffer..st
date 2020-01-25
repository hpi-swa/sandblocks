as yet unclassified
setCopyBuffer: aMorphOrCollection

	| form list |
	list := aMorphOrCollection isCollection ifTrue: [aMorphOrCollection] ifFalse: [{aMorphOrCollection}].
	copyBuffer := SBSelection new
		methodClass: (list first containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy.
	
	list select: [:m | m isCodeContainer not] thenDo: [:m | copyBuffer addMorphBack: m veryDeepCopy].
	form := copyBuffer imageForm.
	copyBufferPreview image: ((form scaledIntoFormOfSize: (self copyBufferPreviewSize min: form extent)) collectColors: [:c | c alpha: c alpha * 0.7])