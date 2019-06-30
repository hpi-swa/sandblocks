as yet unclassified
setCopyBuffer: aMorph

	copyBuffer := aMorph veryDeepCopy.
	copyBufferPreview image: (aMorph imageForm scaledIntoFormOfSize: self copyBufferPreviewSize)