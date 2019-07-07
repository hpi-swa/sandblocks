as yet unclassified
setCopyBuffer: aMorphOrCollection

	| form |
	copyBuffer := SBSelection new.
	(aMorphOrCollection isCollection ifTrue: [aMorphOrCollection] ifFalse: [{aMorphOrCollection}])
		do: [:m | copyBuffer addMorphBack: m veryDeepCopy].
	form := copyBuffer imageForm.
	copyBufferPreview image: ((form scaledIntoFormOfSize: (self copyBufferPreviewSize min: form extent)) collectColors: [:c | c alpha: c alpha * 0.7])