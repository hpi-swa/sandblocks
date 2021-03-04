Class {
	#name : #SBJsModule,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsModule class >> example [

	^ SBJsModule new body: (SBJsDeclaration new
	binding: (SBJsVariable new contents: 'hello')
	value: (SBJsClosure new
		arguments: {SBJsVariable new contents: 'abc'}
		statements: {
			SBJsPrefixOperator new contents: 'return'; expression: (SBJsString new contents: '12332')
		})
	declarationType: 'const')
]

{ #category : #'as yet unclassified' }
SBJsModule >> binding: aString for: block class: aClass ifPresent: aBlock [

	| globals |
	globals := #('console' 'window' 'true' 'false' 'undefined' 'null' 'this' 'require').
	globals detect: [:global | global = aString] ifFound: [:inst | ^ aBlock value: inst] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBJsModule >> body [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsModule >> body: aMorph [

	self removeAllMorphs.
	self addMorphBack: (SBJsClosure new addMorphBack: aMorph)
]

{ #category : #'as yet unclassified' }
SBJsModule >> childSandblocksDo: aBlock [

	aBlock value: self body
]

{ #category : #'as yet unclassified' }
SBJsModule >> initialize [

	super initialize.
	
	self
		layoutInset: 8;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new;
		addMorphBack: (SBJsBlockScope new addMorphBack: self newNullBlock)
]

{ #category : #'as yet unclassified' }
SBJsModule >> insertStatementAboveOrBelow: anAboveBoolean [

	| statement |
	statement := self newNullBlock.
	self sandblockEditor
		do: ((SBInsertCommand newFor: self)
			index: (anAboveBoolean ifTrue: [2] ifFalse: [self body submorphCount + 1]);
			container: self body;
			morph: statement;
			shouldMergeWithNext: true;
			yourself);
		startInput: statement at: 1 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsModule >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> isMethod [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self body layoutCommands}
]

{ #category : #'as yet unclassified' }
SBJsModule >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
]

{ #category : #'as yet unclassified' }
SBJsModule >> saveTryFixing: aBoolean quick: aQuickBoolean [

	(self tryFixingMethod: aBoolean) ifFalse: [^ false].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> tryFixingMethod: aFixBoolean [

	self allBlocksDo: [:block |
		block valid ifFalse: [
			aFixBoolean ifFalse: [^ false] ifTrue: [
				block tryFixIfFail: [^ false].
				" we had to apply a fix, start over (tree might have changed) "
				^ self tryFixingMethod: aFixBoolean]]].
	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> writeSourceOn: aStream [

	self body writeSourceOn: aStream
]
