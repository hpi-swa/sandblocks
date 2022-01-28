Class {
	#name : #SBJsPrefixOperator,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsPrefixOperator class >> validPrefixOperators [

	^ #('new' 'delete' '++' '--' 'await' 'yield' 'yield*' 'return')
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> contents [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> continueInputInRhs: anEvent [

	self sandblockEditor startInput: self rhs at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> currentTextMorph [

	^ self operator
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> expression: aBlock [

	self submorphCount > 1 ifTrue: [self lastSubmorph delete].
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> initialize [

	super initialize.
	
	self addMorphBack: SBOwnTextMorph new
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self class validPrefixOperators
		detect: [:operator | operator beginsWith: self currentTextMorph contents]
		ifNone: [
			self currentTextMorph deleteBeforeCursor.
			self continueInputInRhs: anEvent]
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand morph data: self operator.
			SBAlgebraCommand gap.
			SBAlgebraCommand gap.
			self rhs layoutCommands
		}
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> operator [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> operator: anOperatorString rhs: aRhsBlock [

	self operator contents: anOperatorString.
	self expression: aRhsBlock
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> precedence [

	^ {
		#('new') -> 20.
		" missing: new without arg list -> 19 "
		#('++' '--') -> 17.
		#('yield' 'yield*') -> 2.
	} detect: [:assoc | assoc key includes: self contents] ifFound: #value ifNone: [super precedence]
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> preferredColorIn: aColorPolicy [

	^ aColorPolicy keyword
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> rhs [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self currentTextMorph contents;
		yourself.
	
	aBoolean
		ifTrue: [
			self currentTextMorph
				contents: '';
				moveCursorTo: 0]
		ifFalse: [self currentTextMorph moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBJsPrefixOperator >> writeSourceOn: aStream [

	aStream nextPutAll: self contents.
	aStream space.
	self rhs writeSourceOn: aStream
]
