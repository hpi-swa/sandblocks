as yet unclassified
recognizeTextOn: aForm

	| bytes form |
	aForm unhibernate.
	form := self preprocessForm: aForm.
	self assert: form extent = self requiredFormExtent.
	self assert: form depth = 8.
	
	bytes := form bits asByteArray.
	^ self ffiRecognizeText: bytes length: bytes size