as yet unclassified
setCopyBuffer: aMorph

	| form |
	copyBuffer := aMorph veryDeepCopy.
	
	form := aMorph imageForm.
	copyBufferPreview image: (form scaledIntoFormOfSize: (self copyBufferPreviewSize min: form extent))