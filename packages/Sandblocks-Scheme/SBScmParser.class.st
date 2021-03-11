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
	module := SBScmModule new removeAllMorphs.
	self skipWhitespacesOn: module.
	[stream atEnd] whileFalse: [
		module addMorphBack: self parseExpression.
		self skipWhitespacesOn: module].
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
				SBToggledCode comment: '()' active: 1 do: {[stream next: 1]}.
				^ SBScmExpression new quoted: true].
			stream back.
			^ self parseSExpression quoted: true].
		stream
			back;
			back].
	endCheck := stream peek caseOf: {[$"] -> [[:c | c = $"]]} otherwise: [[:c | c isSeparator or: [c = $)]]].
	contents := String streamContents: [:str |
		[str nextPut: stream next] doWhileTrue: [stream peek notNil and: [(endCheck value: stream peek) not]]].
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
	sexpr := SBScmExpression new.
	self skipWhitespacesOn: sexpr.
	[stream peek ~= $)] whileTrue: [
		self skipWhitespacesOn: sexpr.
		sexpr addMorphBack: self parseExpression.
		self skipWhitespacesOn: sexpr].
	SBToggledCode comment: ')' active: 1 do: {[stream next]}.
	^ sexpr
]

{ #category : #'as yet unclassified' }
SBScmParser >> skipWhitespacesOn: aMorph [

	| crCount |
	crCount := 0.
	[stream atEnd not and: [stream peek isSeparator or: [stream peek = $;]]] whileTrue: [
		stream peek = $; ifTrue: [
			crCount := 0.
			stream next.
			aMorph addMorphBack: (aMorph newCommentBlock contents: (String streamContents: [:s |
				[({Character cr. Character lf} includes: stream peek) not and: [stream atEnd not]] whileTrue: [s nextPut: stream next]]))].
		({Character cr. Character lf} includes: stream next) ifTrue: [crCount := crCount + 1].
		
		crCount = 2 ifTrue: [
			aMorph addMorphBack: SBEmptyLine new.
			crCount := 0]]
]
