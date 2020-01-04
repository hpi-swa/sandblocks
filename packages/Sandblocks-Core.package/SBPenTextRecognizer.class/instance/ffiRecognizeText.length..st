as yet unclassified
ffiRecognizeText: aByteArray length: aNumber
	<apicall: char* 'recognize_text' (byte* long) module: 'libtextrecognizer.so'>
	^ self externalCallFailed