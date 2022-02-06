Class {
	#name : #SBStCascade,
	#superclass : #SBStASTNode,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #converting }
SBStCascade >> asReactComponent: converter [
	<convert>
	<automatic>

	converter
		if: [self receiver isMessageSend and: [self receiver selector = 'asElementBuilder' and: [self messages last selector = 'build']]]
		do: [
			SBStReactComponent new
				componentClass: self receiver receiver
				props: (self messages
					detect: [:m | m selector = 'props:']
					ifFound: [:m | m arguments first]
					ifNone: [SBStArray new])
				children: (self messages
					detect: [:m | m selector = 'children:']
					ifFound: [:m | m arguments first]
					ifNone: [SBStArray new])]
]

{ #category : #actions }
SBStCascade >> browse [

	(Project uiManager
		chooseFromLabeledValues: (self messages collect: [:message | message selector -> message] as: OrderedDictionary)
		title: 'Browse which message?') ifNotNil: [:message | message browse]
]

{ #category : #actions }
SBStCascade >> browseImplementors [

	(Project uiManager
		chooseFromLabeledValues: (self messages collect: [:message | message selector -> message] as: OrderedDictionary)
		title: 'Browse which message?') ifNotNil: [:message | message browseImplementors]
]

{ #category : #'insert/delete' }
SBStCascade >> canDeleteChild: aBlock [

	^ aBlock ~= self receiver
]

{ #category : #'layout properties - table' }
SBStCascade >> cellGap [

	^ self colorPolicy lineGap
]

{ #category : #'as yet unclassified' }
SBStCascade >> codeActions [

	^ super codeActions, (SBStSubstitution allSubclasses
		select: [:substition | substition matchesCascades and: [substition matches: self]]
		thenCollect: [:substitution |
			SBCodeAction labeled: 'Convert to ', substitution name for: self do: [:node |
				node sandblockEditor do: (SBReplaceCommand new
					target: node;
					replacer: ((substitution newFrom: self) pc: self pc))]])
]

{ #category : #converting }
SBStCascade >> converterOptionsDo: aBlock [

	super converterOptionsDo: aBlock.
	
	SBStSubstitution allSubclassesDo: [:substitution |
		(substitution matches: self) ifTrue: [
			aBlock value: (SBConvertOption named: substitution prettyName do: [:converter | converter do: [substitution newFor: self]])]]
]

{ #category : #'testing hierarchy' }
SBStCascade >> fixedNumberOfChildren [

	^ false
]

{ #category : #accessing }
SBStCascade >> guessedClass [

	^ self submorphs last guessedClass
]

{ #category : #'insert/delete' }
SBStCascade >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	((aBlock = self receiver or: [aBlock isNil]) and: [aBoolean]) ifTrue: [^ nil].
	^ super insertCommandRequest: aMorph near: aBlock before: aBoolean
]

{ #category : #testing }
SBStCascade >> isCascade [

	^ true
]

{ #category : #testing }
SBStCascade >> isExpression [

	^ true
]

{ #category : #layout }
SBStCascade >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self receiver layoutCommands.
			SBAlgebraCommand group data: (self messages gather: [:message | {SBAlgebraCommand hardLine withGap: true. message layoutCommands}])}
]

{ #category : #'as yet unclassified' }
SBStCascade >> messages [

	^ self submorphs allButFirst
]

{ #category : #'as yet unclassified' }
SBStCascade >> newEmptyChildNear: aBlock before: aBoolean [

	(aBlock isNil and: [aBoolean]) ifTrue: [^ super newEmptyChildNear: aBlock before: aBoolean].
	^ SBStMessageSend new receiver: nil selector: #'' arguments: #()
]

{ #category : #'object interface' }
SBStCascade >> objectInterfaceNear: aBlock at: aSymbol [

	aBlock = self receiver
		ifTrue: [
			^ aSymbol = #replace
				ifTrue: [SBInterfaces stExpression]
				ifFalse: [SBInterfaces never]].
	^ SBInterfaces stMessage
]

{ #category : #printing }
SBStCascade >> printOn: aStream [

	aStream nextPutAll: 'cascade to '.
	self hasSubmorphs ifTrue: [self firstSubmorph printOn: aStream]
]

{ #category : #'as yet unclassified' }
SBStCascade >> receiver [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStCascade >> receiver: aBlock messages: aCollection [

	self addMorphBack: aBlock.
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #printing }
SBStCascade >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space.
	self submorphs allButFirst do: [:m | m writeSendSourceOn: aStream] separatedBy: [aStream nextPutAll: '; '].
	aStream nextPut: $)
]
