as yet unclassified
setCopyBuffer: aMorph

	| form |
	copyBuffer := aMorph veryDeepCopy.
	form := aMorph imageForm.
	copyBufferPreview image: ((form scaledIntoFormOfSize: (self copyBufferPreviewSize min: form extent)) collectColors: [:c | c alpha: c alpha * 0.7])