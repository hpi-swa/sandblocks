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
SBScmBrowser >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> module: aModule [

	| defs |
	self fileReference contents: aModule filename.
	
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
	self currentDefinition statements: {defs first veryDeepCopy}
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> moduleDefinitions [

	^ self definitions submorphs collect: [:d | d sexpr]
]

{ #category : #'as yet unclassified' }
SBScmBrowser >> open: anSExpr [

	self currentDefinition statements: {anSExpr}
]
