Class {
	#name : #SBJsObjectLiteral,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> buildEmptyRow [

	^ SBRow new
		useAlgebraLayout;
		softWrap: false;
		addMorphBack: self newNullBlock;
		addMorphBack: (SBStringMorph new contents: ':');
		addMorphBack: self newNullBlock
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> childSandblocksDo: aBlock [

	self pairsDo: [:key :value |
		aBlock value: key.
		aBlock value: value]
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> deleteCommandFor: aBlock [

	^ (SBDeleteCommand newFor: self containingArtefact)
		target: aBlock owner
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> initialize [

	super initialize.
	
	self addMorphBack: (SBStringMorph new contents: '{').
	self addMorphBack: self buildEmptyRow.
	self addMorphBack: (SBStringMorph new contents: '}')
]

{ #category : #'as yet unclassified' }
SBJsObjectLiteral >> insertCommandRequest: anAfterBoolean near: aBlock [

	| row |
	row := self buildEmptyRow.
	^ (SBInsertCommand newFor: self containingArtefact)
		morph: row;
		select: row firstSubmorph;
		container: self;
		shouldMergeWithNext: true;
		index: (self submorphIndexOf: aBlock owner) + (anAfterBoolean ifTrue: [1] ifFalse: [0])
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
		data: (Array streamContents: [:stream |
			stream nextPut: (SBAlgebraCommand morph data: self firstSubmorph).
			self submorphCount > 2 ifTrue: [
				stream nextPut: (SBAlgebraCommand indent
					data: {SBAlgebraCommand softLineOrGap}, ((self submorphs viewFrom: 2 to: self submorphCount - 1) collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap]))].
			stream nextPut: SBAlgebraCommand softLineOrGap.
			stream nextPut: (SBAlgebraCommand morph data: self lastSubmorph).
		])
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
SBJsObjectLiteral >> writeSourceOn: aStream [

	aStream nextPut: ${.
	self pairsDo: [:key :value |
		key writeSourceOn: aStream.
		aStream nextPut: $:; space.
		value writeSourceOn: aStream].
	aStream nextPut: $}.
]
