Class {
	#name : #SBStRegex,
	#superclass : #SBStSubstitution,
	#instVars : [
		'text',
		'examples',
		'exampleLabel'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #testing }
SBStRegex class >> instanceSuggestion [

	^ [self new regexString: '' examples: #()]
]

{ #category : #testing }
SBStRegex class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock selector = 'asRegex' and: [aBlock receiver isStringBlock]) or:
	[(aBlock receiver satisfies: #(notNil isBinding)) and: [aBlock receiver contents = self name] and: [aBlock selector = 'regex:examples:']]
]

{ #category : #'instance creation' }
SBStRegex class >> newFor: aBubble [

	^ aBubble selector = 'asRegex'
		ifTrue: [
			self new regexString: aBubble receiver contents examples: #()]
		ifFalse: [
			self new
				regexString: aBubble arguments first contents
				examples: (aBubble arguments second childSandblocks collect: #contents)]
]

{ #category : #'instance creation' }
SBStRegex class >> regex: aRegex examples: aCollection [

	^ aRegex asRegex
]

{ #category : #'as yet unclassified' }
SBStRegex >> addExample: aString [

	examples addMorphBack: (self createExample: aString)
]

{ #category : #'as yet unclassified' }
SBStRegex >> canDeleteChild: aBlock [

	^ aBlock owner = examples
]

{ #category : #'as yet unclassified' }
SBStRegex >> checkExamples [

	examples submorphsDo: [:example |
		(self regexMatches: example contents)
			ifTrue: [example detachDecorators: SBErrorDecorator]
			ifFalse: [(example hasDecorator: SBErrorDecorator) ifFalse: [example attachDecorator: SBErrorDecorator new]]]
]

{ #category : #'as yet unclassified' }
SBStRegex >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBStRegex >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBStRegex >> createExample: aString [

	^ SBTextBubble new
		contents: aString;
		when: #contentsChanged send: #checkExamples to: self;
		yourself
]

{ #category : #'as yet unclassified' }
SBStRegex >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBStRegex >> guessedClass [

	^ RxParser preferredMatcherClass
]

{ #category : #'as yet unclassified' }
SBStRegex >> initialize [

	super initialize.
	
	self
		layoutInset: 2;
		changeTableLayout;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellPositioning: #center;
		addMorphBack: (text := SBTextBubble new when: #contentsChanged send: #checkExamples to: self);
		addMorphBack: (exampleLabel := SBStringMorph new contents: 'Examples:');
		addMorphBack: ((examples := SBColumn new) when: #morphAdded send: #checkExamples to: self)
]

{ #category : #'as yet unclassified' }
SBStRegex >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ SBRelInsertCommand new
		near: aBlock before: aBoolean in: examples morph: aMorph;
		yourself
]

{ #category : #'as yet unclassified' }
SBStRegex >> newEmptyChildNear: aBlock before: aBoolean [

	^ self createExample: ''
]

{ #category : #'as yet unclassified' }
SBStRegex >> prefix [

	^ 'r '
]

{ #category : #'as yet unclassified' }
SBStRegex >> printOn: aStream [

	aStream nextPutAll: 'regex '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStRegex >> regexMatches: aString [

	^ self contents asRegex matches: aString
]

{ #category : #'as yet unclassified' }
SBStRegex >> regexString: aString examples: aCollection [

	self contents: aString.
	
	examples removeAllMorphs.
	aCollection do: [:example | self addExample: example]
]

{ #category : #'as yet unclassified' }
SBStRegex >> symbols [

	^ self colorPolicy symbolsForRegex: self
]

{ #category : #'as yet unclassified' }
SBStRegex >> valid [

	[self contents asRegex] on: RegexSyntaxError do: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBStRegex >> writeSourceOn: aStream [

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
