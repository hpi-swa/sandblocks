Class {
	#name : #SBScmModule,
	#superclass : #SBScmASTNode,
	#instVars : [
		'interpreter',
		'filename'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmModule class >> example [

	^ SBScmModule fromString: '(define (filter list test)
  (cond
    ((null? list) list)
    ((test (car list)) (cons (car list) (filter (cdr list) test)))
    (else (filter (cdr list) test))))

(filter (list 1 2 3 4) (lambda (x) (> x 3)))'
]

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
SBScmModule class >> newInterpreter [

	| interpreter |
	interpreter := QoppaInterpreter new.
	interpreter
		bindInGlobalEnv: #'eval-lang'
			value: (interpreter wrapPrim: [:lang :source |
				lang content = 'js' ifTrue: [^ self error: 'no runtime for js installed'].
				self assert: lang = 'smalltalk'.
				Compiler evaluate: source content] countingArgs: true);
		bindInGlobalEnv: #perform
			value: (interpreter
				wrapPrim: [:args |
					args size < 2 ifTrue: [QoppaArityMismatchError signal: 'ArityMismatch for perform'].
					args first perform: args second asSymbol withArguments: (args allButFirst: 2)]
				countingArgs: false).
	^ interpreter
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
SBScmModule >> canPersist [

	^ self hasFilename
]

{ #category : #'as yet unclassified' }
SBScmModule >> commandPaletteClass [

	^ SBScmPalette
]

{ #category : #'as yet unclassified' }
SBScmModule >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas.
	
	(self hasUnsavedChanges and: [self artefactForPersisting = self]) ifTrue: [ | adornment |
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
SBScmModule >> initialize [

	super initialize.
	
	self
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

	^ interpreter ifNil: [interpreter := self class newInterpreter]
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
SBScmModule >> isEditor [

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
SBScmModule >> layoutInset [

	^ self floating ifTrue: [8] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBScmModule >> reloadModule [
	<action>
	<actionValidIf: #hasFilename>

	^ self replaceBy: ((SBScmModule fromPath: self filename) position: self position)
]

{ #category : #'as yet unclassified' }
SBScmModule >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
]

{ #category : #'as yet unclassified' }
SBScmModule >> saveAs [
	<action>

	
	self filename: ((UIManager default saveFilenameRequest: 'Choose a filename' initialAnswer: 'file.scm') ifNil: [^ self]).
	self sandblockEditor save
]

{ #category : #'artefact protocol' }
SBScmModule >> saveTryFixing: aBoolean quick: anotherBoolean [

	self allBlocksDo: [:b | b valid ifFalse: [^ false]].
	
	self filename ifNotNil: [
		FileStream
			forceNewFileNamed: self selectedFilename
			do: [:file |
				self writeSourceOn: file indent: 0.
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
SBScmModule >> statements: aCollection [

	self statements copy do: #delete.
	self addAllMorphs: aCollection
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
