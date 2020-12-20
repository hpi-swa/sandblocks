Class {
	#name : #RPEmbeddedSmalltalk,
	#superclass : #Object,
	#category : #'RatPack-Templating'
}

{ #category : #compiling }
RPEmbeddedSmalltalk class >> convertToCode: aString [
	"Converts the embedded smalltalk code into string concatenation with"
	| rs |
	rs := ReadStream on: aString.
	^ String streamContents: [:stream |
		self writePreambleFor: aString on: stream.
		[self renderLiteralStringFrom: rs to: stream.
		rs atEnd ifFalse: [self renderCodeFrom: rs to: stream].
		rs atEnd] whileFalse.
		self writePostscriptTo: stream]

]

{ #category : #rendering }
RPEmbeddedSmalltalk class >> render: aString [ 

	^ self evaluate: aString for: nil
]

{ #category : #rendering }
RPEmbeddedSmalltalk class >> render: aString for: anObject [

	^ Compiler new evaluate: (self convertToCode: aString) for: anObject logged: false
]

{ #category : #rendering }
RPEmbeddedSmalltalk class >> render: aString in: aContext [

	^ Compiler new evaluate: (self convertToCode: aString) in: aContext to: aContext receiver
]

{ #category : #compiling }
RPEmbeddedSmalltalk class >> renderCodeFrom: rs to: stream [
	| isInsert |
	(isInsert := rs peekFor: $=) ifTrue: [stream nextPutAll: 'r00t nextPutAll: ('].
	stream nextPutAll: (rs upToAll: '%>').
	isInsert ifTrue: [stream nextPutAll: ') asString.'].
	stream nextPut: Character cr.

]

{ #category : #compiling }
RPEmbeddedSmalltalk class >> renderLiteralStringFrom: rs to: stream [

	stream
		nextPutAll: 'r00t nextPutAll: ';
		nextPutAll: (rs upToAll: '<%') printString;
		nextPut: $.;
		nextPut: Character cr.

]

{ #category : #compiling }
RPEmbeddedSmalltalk class >> writePostscriptTo: stream [

	stream nextPutAll: 'r00t contents.'.
]

{ #category : #compiling }
RPEmbeddedSmalltalk class >> writePreambleFor: aString on: stream [
	"Initial code. Prepare the write stream to hold the rendered string"
	stream
		nextPutAll: '| r00t | r00t := WriteStream on: (String new: ';
		nextPutAll: (aString size / 2) floor printString;
		nextPutAll: ').';
		nextPut: Character cr.
]
