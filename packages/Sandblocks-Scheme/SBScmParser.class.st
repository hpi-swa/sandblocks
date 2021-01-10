Class {
	#name : #SBScmParser,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmParser >> parse: aStream [

	| module |
	stream := aStream.
	self skipWhitespaces.
	module := SBScmModule new removeAllMorphs.
	[stream atEnd] whileFalse: [
		module addMorphBack: self parseExpression.
		self skipWhitespaces].
	^ module
]

{ #category : #'as yet unclassified' }
SBScmParser >> parseExpression [

	| c |
	c := stream peek.
	^ c = $( ifTrue: [self parseSExpression] ifFalse: [self parseLiteral]
]

{ #category : #'as yet unclassified' }
SBScmParser >> parseLiteral [

	| contents endCheck |
	(stream size - stream position) >= 2 ifTrue: [
		(stream next: 2) = '''(' ifTrue: [
			stream peek = $) ifTrue: [
				SBToggledCode comment: '()' active: 1 do: {[stream next: 2]}.
				^ SBScmExpression new quoted: true].
			stream back.
			^ self parseSExpression quoted: true].
		stream
			back;
			back].
	endCheck := stream peek caseOf: {[$"] -> [[:c | c = $"]]} otherwise: [[:c | c isSeparator]].
	contents := String streamContents: [:str |
		[str nextPut: stream next] doWhileTrue: [stream peek notNil and: [(endCheck value: stream peek) not and: [stream peek ~= $)]]]].
	(contents first isDigit or: [contents first = $-]) ifTrue: [^ SBScmNumber new contents: contents].
	contents first = $' ifTrue: [^ SBScmSymbol new contents: contents allButFirst].
	contents first = $" ifTrue: [
		SBToggledCode comment: '"' active: 1 do: {[stream next]}.
		^ SBScmString new contents: contents allButFirst].
	^ SBScmIdentifier new contents: contents
]

{ #category : #'as yet unclassified' }
SBScmParser >> parseSExpression [

	| sexpr |
	SBToggledCode comment: '(' active: 1 do: {[stream next]}.
	self skipWhitespaces.
	sexpr := SBScmExpression new.
	[stream peek ~= $)] whileTrue: [
		self skipWhitespaces.
		sexpr addMorphBack: self parseExpression.
		self skipWhitespaces].
	SBToggledCode comment: ')' active: 1 do: {[stream next]}.
	^ sexpr
]

{ #category : #'as yet unclassified' }
SBScmParser >> skipWhitespaces [

	[stream atEnd not and: [stream peek isSeparator or: [stream peek = $;]]] whileTrue: [
		stream peek = $; ifTrue: [[stream peek ~= Character cr and: [stream atEnd not]] whileTrue: [stream next]].
		stream next]
]
