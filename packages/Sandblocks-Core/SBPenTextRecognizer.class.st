Class {
	#name : #SBPenTextRecognizer,
	#superclass : #Object,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPenTextRecognizer >> ffiRecognizeText: aByteArray length: aNumber [
	"<apicall: char* 'recognize_text' (byte* long) module: 'libtextrecognizer.so'>
	^ self externalCallFailed"
]

{ #category : #'as yet unclassified' }
SBPenTextRecognizer >> preprocessForm: aForm [

	| scale newForm decal target |
	scale  := (self requiredFormExtent y / aForm width min: self requiredFormExtent x / aForm height).
	"^ aForm rotateBy: 90 magnify: scale smoothing: 4"
	newForm := aForm blankCopyOf: aForm boundingBox scaledBy: scale * 0.9.
	(WarpBlt toForm: newForm)
                sourceForm: aForm;
                colorMap: (aForm colormapIfNeededFor: newForm);
                cellSize: 8;
                combinationRule: 3;
                copyQuad: aForm boundingBox innerCorners toRect: newForm boundingBox.
	
	decal := (newForm rotateBy: -90) flipVertically.
	target := Form extent: self requiredFormExtent depth: 8.
	target getCanvas
		fillColor: Color white;
		drawImage: decal at: ((target width / 2) - (decal width / 2)) floor @ 0"(target height - decal height)".
	
	^ target
]

{ #category : #'as yet unclassified' }
SBPenTextRecognizer >> recognizeTextOn: aForm [

	| bytes form |
	aForm unhibernate.
	form := self preprocessForm: aForm.
	self assert: form extent = self requiredFormExtent.
	self assert: form depth = 8.
	
	bytes := form bits asByteArray.
	^ self ffiRecognizeText: bytes length: bytes size
]

{ #category : #'as yet unclassified' }
SBPenTextRecognizer >> requiredFormExtent [

	^ 32 @ 128
]
