Class {
	#name : #SBStLanguageBox,
	#superclass : #SBStSubstitution,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStLanguageBox class >> eval: aString lang: anotherString [

	^ [SBScmModule newInterpreter readAndEvaluate: aString]
		on: QoppaUnboundVariableFailure
		do: [:e | | context name |
			name := e variableName asSymbol asString.
			context := thisContext methodReturnContext sender.
			e resumeWithValue: (context namedTempAt: (context tempNames indexOf: name ifAbsent: [^ e signal]))]
]

{ #category : #'as yet unclassified' }
SBStLanguageBox class >> matches: aMessageSend [

	^ (super matches: aMessageSend) and: [aMessageSend selector = 'eval:lang:']
]

{ #category : #'as yet unclassified' }
SBStLanguageBox class >> newFor: aBlock [

	^ self new source: aBlock arguments first contents lang: aBlock arguments second contents
]

{ #category : #'as yet unclassified' }
SBStLanguageBox class >> suggestion [

	^ [:block | | box |
		box := (SBStLanguageBox new source: '' lang: 'scheme').
		block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
			target: block;
			replacer: box).
		box inputNextUnknown]
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> drawnColor [

	^ self root drawnColor
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> initialize [

	super initialize.
	
	self layoutInset: 2
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands. SBAlgebraCommand hardLine. self root layoutCommands}
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> root [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> source: aString lang: anotherString [

	self removeAllMorphs.
	self addMorphBack: (SBStringMorph new contents: anotherString).
	self addMorphBack: (aString ifEmpty: [SBScmModule new] ifNotEmpty: [SBScmModule fromString: aString])
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> writeSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: ''scheme'')'
]
