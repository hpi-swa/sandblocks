Class {
	#name : #SBLanguageBox,
	#superclass : #SBBlock,
	#instVars : [
		'language'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLanguageBox class >> eval: aString lang: anotherString [
	
	anotherString = 'smalltalk' ifTrue: [
		^ SBExecutionEnvironment value
			ifNotNil: [:artefact | | context |
				context := artefact evaluationContext.
				Compiler new
					evaluate: aString
					in: context
					to: (context ifNil: [artefact evaluationReceiver] ifNotNil: #receiver)
					notifying: artefact
					ifFail: nil]
		ifNil: [Compiler evaluate: aString]].
	
	anotherString = 'scheme' ifTrue: [ | interpreter |
		interpreter := SBScmModule newInterpreter.
		^ [interpreter readAndEvaluate: aString]
			on: QoppaUnboundVariableFailure
			do: [:e | | context name |
				name := e variableName asSymbol asString.
				context := thisContext methodReturnContext sender.
				e resumeWithValue: (self resolve: name interpreter: interpreter inSmalltalk: context ifAbsent: [^ e signal])]].
	
	^ self error: ('no runtime for {1} installed' format: {anotherString}).
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> matches: aMessageSend [

	^ (super matches: aMessageSend) and: [aMessageSend selector = 'eval:lang:']
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> newFor: aBlock [

	^ self new source: aBlock arguments first contents lang: aBlock arguments second contents
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> resolve: aString interpreter: anInterpreter inSmalltalk: context ifAbsent: aBlock [

	^ context namedTempAt: (context tempNames
		indexOf: aString
		ifAbsent: [
			SBExecutionEnvironment value ifNotNil: [:env |
				anInterpreter bindInGlobalEnv: aString value: ((env bindingOf: aString asSymbol) ifNotNil: [:b | ^ b value])].
			^ Smalltalk globals at: aString asSymbol ifAbsent: [^ aBlock value]])
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> suggestion [

	^ [:block | | box |
		box := SBStLanguageBox new source: '' lang: 'scheme'.
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: box).
		box inputNextUnknown]
]

{ #category : #testing }
SBLanguageBox >> actionProviders [

	^ {self grammarHandler. self}
]

{ #category : #testing }
SBLanguageBox >> canAppearInBlockBody [

	^ true
]

{ #category : #'colors and color policies' }
SBLanguageBox >> drawnColor [

	^ self root drawnColor
]

{ #category : #evaluation }
SBLanguageBox >> evaluate [

	^ self root evaluate
]

{ #category : #accessing }
SBLanguageBox >> grammarHandler [

	^ self parentSandblock grammarHandler
]

{ #category : #initialization }
SBLanguageBox >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 0;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #testing }
SBLanguageBox >> isExpression [

	^ true
]

{ #category : #accessing }
SBLanguageBox >> language [

	^ language
]

{ #category : #layout }
SBLanguageBox >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self firstSubmorph layoutCommands.
			self root statements size > 1
				ifTrue: [SBAlgebraCommand hardLine withGap: true]
				ifFalse: [SBAlgebraCommand gap].
			self root layoutCommands}
]

{ #category : #testing }
SBLanguageBox >> newNullBlock [

	^ self grammarHandler newNullBlock
]

{ #category : #accessing }
SBLanguageBox >> object [

	^ self
]

{ #category : #printing }
SBLanguageBox >> printOn: aStream [

	aStream nextPutAll: language.
	aStream nextPutAll: ' language box'
]

{ #category : #accessing }
SBLanguageBox >> root [

	^ self submorphs last
]

{ #category : #accessing }
SBLanguageBox >> setEmptyWithHint: aString [

	self statements: {self root grammarHandler newNullBlock label: aString}
]

{ #category : #initialization }
SBLanguageBox >> source: aString lang: anotherString [

	language := anotherString.

	self removeAllMorphs.
	self addMorphBack: (anotherString
		caseOf: {
			['smalltalk'] -> [SBStContainer new setFromSource: aString].
			['scheme'] -> [SBScmModule fromString: aString].
			['js'] -> [SBJsModule fromString: aString]}
		otherwise: [SBMultilineOwnTextMorph new contents: aString]).
	
	self addMorphFront: ((self root class respondsTo: #icon)
		ifTrue: [self root class icon asMorph]
		ifFalse: [SBIcon iconQuestion])
]

{ #category : #accessing }
SBLanguageBox >> statements: aCollection [

	self root statements: aCollection
]

{ #category : #printing }
SBLanguageBox >> writeSourceOn: aStream [

	self grammarHandler writeSourceOn: aStream for: self
]
