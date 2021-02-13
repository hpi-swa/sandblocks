Class {
	#name : #SBScmModule,
	#superclass : #SBScmASTNode,
	#instVars : [
		'interpreter',
		'filename',
		'unsavedChanges'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmModule class >> fromFilestream: file [

	^ (SBScmParser new parse: file ascii) filename: file name
]

{ #category : #'as yet unclassified' }
SBScmModule class >> fromPath: aString [

	^ FileStream readOnlyFileNamed: aString do: [:file | self fromFilestream: file]
]

{ #category : #'as yet unclassified' }
SBScmModule class >> fromString: aString [

	^ SBScmParser new parse: aString readStream
]

{ #category : #'as yet unclassified' }
SBScmModule >> binding: aString for: block class: aClass ifPresent: aBlock [

	| sym |
	self
		withStatementsDo: [:l |
			l detect: [:s | s isSExpr and: [s ifDefinition: [:d | d = aString] otherwise: [false]]] ifFound: [:s | aBlock value: s]]
		ifNotApplicable: [].
	
	sym := aString asSymbol.
	self interpreter globalEnv car do: [:cons | cons car = sym ifTrue: [^ aBlock value: (SBScmIdentifier new contents: aString)]].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBScmModule >> canDeleteChild: aBlock [

	^ self expressions size > 1
]

{ #category : #'as yet unclassified' }
SBScmModule >> childSandblocksDo: aBlock [

	self expressions do: aBlock
]

{ #category : #'as yet unclassified' }
SBScmModule >> commandPaletteClass [

	^ SBScmPalette
]

{ #category : #'as yet unclassified' }
SBScmModule >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	self hasUnsavedChanges ifTrue: [ | adornment |
		adornment := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas translucentImage: adornment at: self position + ((self width - adornment width) @ 0)]
]

{ #category : #'as yet unclassified' }
SBScmModule >> expressions [

	^ self filename ifNotNil: [self submorphs viewAllButFirst] ifNil: [self submorphs]
]

{ #category : #'as yet unclassified' }
SBScmModule >> filename [

	^ filename
]

{ #category : #'as yet unclassified' }
SBScmModule >> filename: aString [

	filename := aString.
	self addMorphFront: (SBFileReference new
		prefix: 'File: ';
		contents: aString;
		yourself)
]

{ #category : #'as yet unclassified' }
SBScmModule >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmModule >> hasFilename [

	^ filename notNil
]

{ #category : #'as yet unclassified' }
SBScmModule >> hasUnsavedChanges [

	^ unsavedChanges
]

{ #category : #'as yet unclassified' }
SBScmModule >> hasUnsavedChanges: aBoolean [

	unsavedChanges ~= aBoolean ifTrue: [
		unsavedChanges := aBoolean.
		self changed]
]

{ #category : #'as yet unclassified' }
SBScmModule >> initialize [

	super initialize.
	
	unsavedChanges := false.
	
	self
		layoutInset: 8;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new;
		addMorphBack: self newNullBlock
]

{ #category : #'as yet unclassified' }
SBScmModule >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBScmModule >> interpreter [

	^ interpreter ifNil: [interpreter := QoppaInterpreter new]
]

{ #category : #'as yet unclassified' }
SBScmModule >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> isMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmModule >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBScmModule >> reloadModule [
	<action>
	<actionValidIf: #hasFilename>

	^ self replaceBy: ((SBScmModule fromPath: self filename) position: self position)
]

{ #category : #'as yet unclassified' }
SBScmModule >> sandblockBlockColorIfAbsent: aBlock [

	^ Color r: 0.271 g: 0.682 b: 0.851
]

{ #category : #'artefact protocol' }
SBScmModule >> saveTryFixing: aBoolean quick: anotherBoolean [

	self allBlocksDo: [:b | b valid ifFalse: [^ false]].
	self filename ifNotNil: [
		FileStream
			forceNewFileNamed: self selectedFilename
			do: [:file |
				self writeSourceOn: file indent: 0.
				self hasUnsavedChanges: false.
				self flag: #todo. " delete old file if renamed? "
				filename := self selectedFilename]].
	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> selectedFilename [

	^ filename ifNotNil: [self firstSubmorph contents]
]

{ #category : #'as yet unclassified' }
SBScmModule >> statements [

	^ self expressions
]

{ #category : #'as yet unclassified' }
SBScmModule >> withStatementsDo: aBlock ifNotApplicable: anotherBlock [

	aBlock value: self expressions
]

{ #category : #'as yet unclassified' }
SBScmModule >> writeSourceOn: aStream [

	self statements do: [:s | s writeSourceOn: aStream] separatedBy: [aStream cr]
]

{ #category : #'as yet unclassified' }
SBScmModule >> writeSourceOn: aStream indent: aNumber [

	self statements
		do: [:s | s writeSourceOn: aStream indent: aNumber]
		separatedBy: [aStream cr]
]
