Class {
	#name : #SBStLanguageBox,
	#superclass : #SBStSubstitution,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #suggestions }
SBStLanguageBox class >> instanceSuggestion [

	^ [
		SBStLanguageBox new
			source: '' lang: 'scheme';
			yourself]
]

{ #category : #testing }
SBStLanguageBox class >> matches: aMessageSend [

	^ aMessageSend selector = 'eval:lang:'
]

{ #category : #'instance creation' }
SBStLanguageBox class >> newFor: aBlock [

	^ self new source: aBlock arguments first contents lang: aBlock arguments second contents
]

{ #category : #suggestions }
SBStLanguageBox class >> suggestion [

	^ [:block | | box |
		box := self instanceSuggestion value.
		block sandblockEditor do: (SBReplaceCommand new
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
SBStLanguageBox >> language [

	^ self submorphs second contents
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands. SBAlgebraCommand gap. self submorphs second layoutCommands. SBAlgebraCommand hardLine. self root layoutCommands}
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> root [

	^ self submorphs last
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> source: aString lang: anotherString [

	self removeAllMorphs.
	self addMorphBack: (SBStringMorph new contents: anotherString).
	self addMorphBack: (anotherString
		caseOf: {
			['scheme'] -> [aString ifEmpty: [SBScmModule new] ifNotEmpty: [SBScmModule fromString: aString]].
			['js'] -> [SBJsModule fromString: aString]}
		otherwise: [SBStringMorph new contents: 'unsupported language']).
	
	self addMorphFront: self root class icon asMorph
]

{ #category : #'as yet unclassified' }
SBStLanguageBox >> writeSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: '.
	aStream store: self language.
	aStream nextPutAll: ')'
]
