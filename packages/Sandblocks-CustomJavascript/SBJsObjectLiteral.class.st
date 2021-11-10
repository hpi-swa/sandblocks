Class {
	#name : #SBJsObjectLiteral,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> buildEmptyRow [

	^ SBRow new
		useAlgebraLayout;
		softWrap: false;
		layoutInset: 4 @ 0;
		addMorphBack: (self newNullBlock label: 'key');
		addMorphBack: (SBStringMorph new contents: ':');
		addMorphBack: (self newNullBlock label: 'value')
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> deleteCommandFor: aBlock [

	^ SBDeleteCommand new target: aBlock owner
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> initialize [

	super initialize.
	
	self addMorphBack: self buildEmptyRow
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	(aBlock notNil and: [aBlock = aBlock owner firstSubmorph and: [aBoolean not]]) ifTrue: [^ nil].
	(aBlock notNil and: [aBlock = aBlock owner lastSubmorph and: [aBoolean]]) ifTrue: [^ nil].
	^ SBRelInsertCommand new
		near: (aBlock ifNotNil: #owner) before: aBoolean in: self morph: aMorph;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> keys [

	^ Array streamContents: [:s | self keysDo: [:k | s nextPut: k]]
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> keysDo: aBlock [

	(self submorphs viewFrom: 2 to: self submorphCount - 1) do: [:row | aBlock value: row firstSubmorph]
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (Array streamContents: [:stream | stream nextPut: (SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap}, (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap]))])
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> newEmptyChildNear: aBlock before: aBoolean [

	^ self buildEmptyRow
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> pairs: aCollectionOrAssociations [

	self submorphs from: 2 to: self submorphCount - 1 do: [:m | m delete].
	
	aCollectionOrAssociations do: [:pair | | row |
		row := self buildEmptyRow.
		row firstSubmorph replaceBy: pair key.
		row lastSubmorph replaceBy: pair value.
		self addMorph: row asElementNumber: self submorphCount]
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> pairsDo: aBlock [

	(self submorphs viewFrom: 2 to: self submorphCount -1) do: [:row |
		aBlock value: row firstSubmorph value: row lastSubmorph]
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> printOn: aStream [

	aStream nextPutAll: 'object literal with '.
	self keys
		do: [:key | aStream nextPutAll: key contents]
		separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> symbols [

	^ #('{' '}')
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> writeSourceOn: aStream [

	aStream nextPut: ${.
	self pairsDo: [:key :value |
		key writeSourceOn: aStream.
		aStream nextPut: $:; space.
		value writeSourceOn: aStream].
	aStream nextPut: $}.
]
