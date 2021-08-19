Class {
	#name : #SBInlineBlockText,
	#superclass : #SBInlineBlock,
	#instVars : [
		'regexString',
		'regex'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockText >> ambiguitiesOn: aStream [

	
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	| start |
	start := aStream position + 1.
	^ (self regex matchesStreamPrefix: aStream)
		ifTrue: [self veryDeepCopy contents: (aStream originalContents copyFrom: start to: aStream position)]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> buildPartial: anOptions with: aString [

	^ self veryDeepCopy contents: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> contents: aString [

	self firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> cursorPositionsDo: aBlock [

	self inline not ifTrue: [aBlock value: (SBCursorSelect new block: self)].
	
	self containingSandblock startInputCommand ifNotNil: [:command |
		aBlock value: (SBCursorText new
			block: self containingSandblock;
			currentCommand: command)]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> initialize [

	super initialize.
	
	self addMorphBack: (SBOwnTextMorph new contents: '')
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> isUnambiguous [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> printTitleOn: aStream [

	aStream nextPutAll: regexString
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> regex [

	^ regex
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> regexString: aString [

	regexString := aString.
	regex := aString asRegex
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ anOptions addLeaf: self if: [:option |
		SBToggledCode
			comment: ''
			active: 0
			do: {[aBoolean ifTrue: [self regex matches: aString] ifFalse: [self regex matchesPrefix: aString]]}.
		self regex matches: aString, (aBoolean ifTrue: [' '] ifFalse: [''])]
]
