Class {
	#name : #SBScmBrowser,
	#superclass : #SBBlock,
	#instVars : [
		'definitions',
		'currentDefinition'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmBrowser >> currentDefinition [

	^ currentDefinition
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> definitions [

	^ definitions
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> fileReference [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> initialize [

	| defScroll modScroll |
	super initialize.
	
	self
		changeTableLayout;
		extent: 500 @ 380;
		cellGap: 8;
		listDirection: #topToBottom;
		layoutInset: 4;
		hResizing: #rigid;
		vResizing: #shrinkWrap;
		addMorphBack: (SBFileReference new prefix: 'File: ');
		addMorphBack: (SBRow new
			changeTableLayout;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			addMorphBack: (defScroll := ScrollPane new vResizing: #spaceFill);
			addMorphBack: (modScroll := ScrollPane new
				hResizing: #spaceFill;
				vResizing: #spaceFill));
		attachDecorator: SBResizableDecorator new;
		attachDecorator: SBMoveDecorator new.
	
	defScroll scroller addMorphBack: (definitions := SBColumn new).
	modScroll scroller addMorphBack: (currentDefinition := SBScmSplitModule new hResizing: #spaceFill).
	modScroll
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		hScrollBarPolicy: #never.
	modScroll scroller layoutPolicy: SBSimpleLayout new
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> module: aModule [

	| defs topLevel |
	aModule filename ifNotNil: [
		self fileReference contents: aModule filename].
	
	defs := aModule definitions.
	
	self definitions addAllMorphs: (defs collect: [:def |
		def
			ifDefinition: [:name | | definition |
				definition := def veryDeepCopy.
				SBScmDefinitionButton new
					contents: name;
					when: #selected send: #open: to: self with: definition;
					sexpr: definition;
					yourself]
			otherwise: [self assert: false]]).
	self open: self definitions submorphs first sexpr.
	
	topLevel := aModule statements reject: [:s | (defs includes: s) or: [s isKindOf: SBUnknown]].
	
	self definitions addMorphBack: (SBScmDefinitionButton new
		contents: '<toplevel>';
		when: #selected send: #open: to: self with: topLevel;
		sexpr: topLevel;
		yourself)
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> moduleDefinitions [

	^ self definitions submorphs allButLast collect: [:d | d sexpr]
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> open: anSExprOrCollection [

	self currentDefinition statements: (anSExprOrCollection isCollection
		ifTrue: [anSExprOrCollection]
		ifFalse: [{anSExprOrCollection}])
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	self definitions submorphsDo: [:b | b valid ifFalse: [^ false]].
	
	self selectedFilename ifNotNil: [:name |
		FileStream
			forceNewFileNamed: name
			do: [:file |
				self writeSourceOn: file.
				self flag: #todo. " delete old file if renamed? "]].
	^ true
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> selectedFilename [

	^ self fileReference contents
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> writeSourceOn: aStream [

	self definitions submorphs do: [:d | d writeSourceOn: aStream. aStream cr; cr]
]
