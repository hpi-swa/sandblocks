Class {
	#name : #SBTSQuery,
	#superclass : #Object,
	#instVars : [
		'stream',
		'captures',
		'lastMatch',
		'expressions'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSQuery >> evalExpression: anExpression against: aBlock ifMatch: aMatchBlock ifFail: aFailBlock ifSpecial: aSpecialBlock [
	" symbol "

	(anExpression isArray and: [anExpression type = $( and: [anExpression first isString]]) ifTrue: [
		((aBlock isKindOf: SBInlineBlockSymbol) and: [aBlock type = anExpression first or: [anExpression first = '_']])
			ifTrue: [
				^ self
					evalExpression: anExpression allButFirst
					against: aBlock
					ifMatch: [
						self lastMatch: aBlock.
						aMatchBlock value]
					ifFail: aFailBlock
					ifSpecial: aSpecialBlock]
			ifFalse: [^ aFailBlock value]].
	
	" alternative "
	(anExpression isArray and: [anExpression type = $[]) ifTrue: [
		anExpression do: [:expr | self evalExpression: expr against: aBlock ifMatch: [^ aMatchBlock value] ifFail: [] ifSpecial: []].
		^ aFailBlock value].
	
	" sequence "
	anExpression isArray ifTrue: [ | exprs blocks |
		exprs := anExpression readStream.
		blocks := OrderedCollection withAll: aBlock childrenForQuery.
		[exprs atEnd not] whileTrue: [ | expr nextBlocks |
			expr := exprs next.
			nextBlocks := expr last = $:
				ifTrue: [ | b |
					b := blocks detect: [:child | child field = expr allButLast] ifNone: [^ aFailBlock value].
					expr := exprs next.
					{b}]
				ifFalse: [blocks ifEmpty: [{nil}] ifNotEmpty: [blocks]].
			(nextBlocks anySatisfy: [:nextBlock |
				self
					evalExpression: expr
					against: nextBlock
					ifMatch: [
						self lastMatch: nextBlock.
						blocks remove: nextBlock.
						true]
					ifFail: [false]
					ifSpecial: [true]]) ifFalse: [^ aFailBlock value]].
		exprs atEnd ifFalse: [^ aFailBlock value].
		^ aMatchBlock value].
	
	" capture "
	anExpression first = $@ ifTrue: [
		self lastMatch ifNotNil: [
			captures at: anExpression allButFirst put: self lastMatch.
			self lastMatch: nil].
		^ aSpecialBlock value].
	
	" anonymous/label node "
	anExpression first = $" ifTrue: [
		((aBlock isKindOf: SBInlineBlockLabel) and: [aBlock label = (anExpression copyFrom: 2 to: anExpression size - 1)])
			ifTrue: [
				self lastMatch: aBlock.
				^ aMatchBlock value]
			ifFalse: [^ aFailBlock value]].
	
	" field name that we want to handle above in sequences "
	anExpression last = $: ifTrue: [^ self assert: false].
	
	^ aFailBlock value
]

{ #category : #'as yet unclassified' }
SBTSQuery >> execute: aString against: aBlock capturesDo: aClosure [

	self prepare: aString.
	^ self executeAgainst: aBlock capturesDo: aClosure
]

{ #category : #'as yet unclassified' }
SBTSQuery >> executeAgainst: aBlock capturesDo: aClosure [

	| ret target |
	target := aBlock.
	captures := Dictionary new.
	
	ret := false.
	expressions do: [:expression |
		self
			evalExpression: expression
			against: aBlock
			ifMatch: [ret := true]
			ifFail: [self lastMatch: nil]
			ifSpecial: []].
	
	ret ifTrue: [aClosure value: captures].
	
	^ ret
]

{ #category : #'as yet unclassified' }
SBTSQuery >> lastMatch [

	^ lastMatch
]

{ #category : #'as yet unclassified' }
SBTSQuery >> lastMatch: aBlock [

	lastMatch := aBlock
]

{ #category : #'as yet unclassified' }
SBTSQuery >> parseExpression [

	| c |
	c := stream peek.
	^ (c = $( or: [c = $[]) ifTrue: [self parseSExpression] ifFalse: [self parseLiteral]
]

{ #category : #'as yet unclassified' }
SBTSQuery >> parseLiteral [

	| contents endCheck |
	endCheck := stream peek
		caseOf: {
			[$"] -> [[:c | c = $"]]}
		otherwise: [[:c | c isSeparator or: [c = $) or: [c = $(]]]].
	contents := String streamContents: [:str | [str nextPut: stream next] doWhileTrue: [stream peek notNil and: [(endCheck value: stream peek) not]]].
	
	contents first = $" ifTrue: [SBToggledCode comment: '"' active: 1 do: {[contents := contents, stream next]}].
	^ contents
]

{ #category : #'as yet unclassified' }
SBTSQuery >> parseSExpression [

	| expr end start |
	start := SBToggledCode comment: '( or [' active: 1 do: {[stream next]}.
	end := start caseOf: {
		[$(] -> [$)].
		[$[] -> [$]]}.
	
	self skipWhitespaces.
	expr := (SBArrayWithType streamContents: [:s |
		[stream peek ~= end] whileTrue: [
			self skipWhitespaces.
			s nextPut: self parseExpression.
			self skipWhitespaces]]) type: start.
	SBToggledCode comment: ') or ]' active: 1 do: {[stream next]}.
	^ expr
]

{ #category : #'as yet unclassified' }
SBTSQuery >> prepare: aString [

	stream := aString readStream.
	expressions := Array streamContents: [:s |
		self skipWhitespaces.
		[stream atEnd] whileFalse: [
			s nextPut: self parseExpression.
			self skipWhitespaces]]
]

{ #category : #'as yet unclassified' }
SBTSQuery >> skipWhitespaces [

	[stream atEnd not and: [stream peek isSeparator or: [stream peek = $;]]] whileTrue: [
		stream peek = $; ifTrue: [ | text |
			stream next.
			text := String streamContents: [:s | [({Character cr. Character lf} includes: stream peek) not and: [stream atEnd not]] whileTrue: [s nextPut: stream next]]].
		stream next]
]
