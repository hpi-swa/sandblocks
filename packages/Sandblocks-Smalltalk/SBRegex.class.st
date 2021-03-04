Class {
	#name : #SBRegex,
	#superclass : #SBStSubstitution,
	#instVars : [
		'text',
		'examples',
		'exampleLabel'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBRegex class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock selector = 'asRegex' and: [aBlock receiver isStringBlock]) or:
	[(aBlock receiver satisfies: #(notNil isBinding)) and: [aBlock receiver contents = self name] and: [aBlock selector = 'regex:examples:']]
]

{ #category : #'as yet unclassified' }
SBRegex class >> newFor: aBubble [

	^ aBubble selector = 'asRegex'
		ifTrue: [
			self new regexString: aBubble receiver contents examples: #()]
		ifFalse: [
			self new
				regexString: aBubble arguments first contents
				examples: (aBubble arguments second childSandblocks collect: #contents)]
]

{ #category : #'as yet unclassified' }
SBRegex class >> regex: aRegex examples: aCollection [

	^ aRegex asRegex
]

{ #category : #'as yet unclassified' }
SBRegex >> addExample: aString [

	examples
		addMorph: (self createExample: aString)
		asElementNumber: (examples submorphCount max: 1).
	self updateLabel
]

{ #category : #'as yet unclassified' }
SBRegex >> canDeleteChild: aBlock [

	^ aBlock owner = examples
]

{ #category : #'as yet unclassified' }
SBRegex >> checkExamples [

	examples submorphsDo: [:example |
		(self regexMatches: example contents)
			ifTrue: [example detachDecorators: SBErrorDecorator]
			ifFalse: [(example hasDecorator: SBErrorDecorator) ifFalse: [example attachDecorator: SBErrorDecorator new]]]
]

{ #category : #'as yet unclassified' }
SBRegex >> childSandblocksDo: aBlock [

	aBlock value: text.
	examples owner ifNotNil: [examples submorphsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBRegex >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBRegex >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBRegex >> createExample: aString [

	^ SBTextBubble new
		contents: aString;
		when: #contentsChanged send: #checkExamples to: self;
		yourself
]

{ #category : #'as yet unclassified' }
SBRegex >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBRegex >> guessedClass [

	^ RxParser preferredMatcherClass
]

{ #category : #'as yet unclassified' }
SBRegex >> initialize [

	super initialize.
	
	self
		layoutInset: 2 withScalingFactor;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #center;
		addMorphBack: (text := SBTextBubble new when: #contentsChanged send: #checkExamples to: self);
		addMorphBack: ((exampleLabel  := SBStringMorph new) on: #click send: #toggleExamples to: self);
		addMorphBack: ((examples := SBColumn new) when: #morphAdded send: #checkExamples to: self);
		updateLabel
]

{ #category : #'as yet unclassified' }
SBRegex >> insertCommandRequest: anAfterBoolean near: aBlock [

	| index |
	examples owner ifNil: [self toggleExamples].
	index := aBlock = text
		ifTrue: [1]
		ifFalse: [((examples submorphIndexOf: aBlock) ifNil: [1]) + (anAfterBoolean ifTrue: [1] ifFalse: [0])].
	
	^ (SBInsertCommand newFor: self containingArtefact)
		container: examples;
		index: index;
		morph: (self createExample: '');
		shouldMergeWithNext: true
]

{ #category : #'as yet unclassified' }
SBRegex >> prefix [

	^ 'r '
]

{ #category : #'as yet unclassified' }
SBRegex >> printOn: aStream [

	aStream nextPutAll: 'regex '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBRegex >> regexMatches: aString [

	^ self contents asRegex matches: aString
]

{ #category : #'as yet unclassified' }
SBRegex >> regexString: aString examples: aCollection [

	self contents: aString.
	
	examples removeAllMorphs.
	aCollection do: [:example | self addExample: example]
]

{ #category : #'as yet unclassified' }
SBRegex >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	text stopEditing: aCommand
]

{ #category : #'as yet unclassified' }
SBRegex >> symbols [

	^ self colorPolicy symbolsForRegex: self
]

{ #category : #'as yet unclassified' }
SBRegex >> toggleExamples [

	examples owner
		ifNotNil: [examples delete]
		ifNil: [self addMorphBack: examples]
]

{ #category : #'as yet unclassified' }
SBRegex >> updateLabel [

	exampleLabel contents: ' -- Examples: '
]

{ #category : #'as yet unclassified' }
SBRegex >> valid [

	[self contents asRegex] on: RegexSyntaxError do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBRegex >> writeSourceOn: aStream [

	examples hasSubmorphs
		ifTrue: [
			aStream nextPut: $(; nextPutAll: self className; nextPutAll: ' regex: '.
			text contents storeOn: aStream.
			aStream nextPutAll: ' examples: #('.
			examples submorphs do: [:morph | morph contents storeOn: aStream] separatedBy: [aStream space].
			aStream nextPutAll: '))']
		ifFalse: [
			text contents storeOn: aStream.
			aStream nextPutAll: ' asRegex']
]
