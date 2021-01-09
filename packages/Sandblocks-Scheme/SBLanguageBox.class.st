Class {
	#name : #SBLanguageBox,
	#superclass : #SBSubstitution,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBLanguageBox class >> eval: aString lang: anotherString [

	^ QoppaInterpreter new readAndEvaluate: aString
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> matches: aMessageSend [

	^ (super matches: aMessageSend) and: [aMessageSend selector = 'eval:lang:']
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> newFor: aBlock [

	^ self new source: aBlock arguments first contents
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> suggestion [

	^ [:block |
		block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
			target: block;
			replacer: (SBLanguageBox new source: ''))]
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> childSandblocksDo: aBlock [

	aBlock value: self root
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> initialize [

	super initialize.
	
	self layoutInset: 2
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands. SBAlgebraCommand hardLine. self root layoutCommands}
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> root [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> source: aString [

	self removeAllMorphs.
	self addMorphBack: (SBStringMorph new contents: 'SCHEME').
	self addMorphBack: (aString ifEmpty: [SBScmModule new] ifNotEmpty: [SBScmModule fromString: aString])
]

{ #category : #'as yet unclassified' }
SBLanguageBox >> writeSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: ''scheme'')'
]
