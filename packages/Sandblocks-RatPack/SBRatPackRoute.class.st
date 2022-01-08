Class {
	#name : #SBRatPackRoute,
	#superclass : #SBStMethodSubstitution,
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRatPackRoute class >> matchSpecific: aBlock [

	^ Smalltalk at: #RPApplication ifPresent: [:a | (aBlock methodClass inheritsFrom: a) and: [aBlock pragmas anySatisfy: [:p | self validMethods includes: p keyword]]] ifAbsent: [false]
]

{ #category : #'as yet unclassified' }
SBRatPackRoute class >> newFor: anObject [

	| block |
	block := anObject asSandblock.
	^ self new
		selector: block selector arguments: block arguments class: block methodClass;
		body: block body;
		yourself
]

{ #category : #'as yet unclassified' }
SBRatPackRoute class >> validMethods [

	^ #(get: put: post: delete: patch: head: options: trace: connect:)
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> argumentsDo: aBlock [

	self signature argumentsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> body [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> body: aBlock [

	super body: aBlock.
	
	self statements
		detect: [:s | s isPragma and: [self class validMethods includes: s selector]]
		ifFound: [:pragma |
			pragma delete.
			self methodInput object: pragma selector allButLast asSymbol.
			self pathArray addMorphBack: pragma arguments first]
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> initialize [

	super initialize.
	
	self
		addMorphBack: (SBRow new
			layoutPolicy: SBAlgebraLayout new;
			addMorphBack: (SBMethodSelect new object: #get);
			addMorphBack: SBStArray new;
			addMorphBack: (SBStSignature new hResizing: #spaceFill));
		layoutInset: 4;
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			"SBAlgebraCommand morph data: "self firstSubmorph layoutCommands.
			SBAlgebraCommand hardLine withGap: true.
			self body layoutCommands
		}
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> methodInput [

	^ self firstSubmorph firstSubmorph
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> openRequestTracker [
	<action>
	
	self sandblockEditor openMorphInView: (SBRatPackRequestTracker new serverClass: self methodClass)
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> pathArray [

	^ self firstSubmorph submorphs second
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> reload [
	<action>
	
	self replaceBy: (SBRatPackRoute newFor: (self compiledMethod asSandblock))
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> selector [

	^ self currentSelector
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> selector: aSymbol arguments: aCollection class: aClass [

	super selector: aSymbol arguments: aCollection class: aClass.
	
	self signature selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> signature [

	^ self firstSubmorph submorphs third
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> writeSignatureSourceOn: aStream [

	self signature writeSourceOn: aStream
]

{ #category : #'as yet unclassified' }
SBRatPackRoute >> writeSourceOn: aStream [

	self writeSignatureSourceOn: aStream.
	aStream space.
	(SBStPragma new selector: self methodInput object asSimpleSetter arguments: {self pathArray submorphs first veryDeepCopy}) writeSourceOn: aStream.
	aStream space.
	self body writeSourceOn: aStream
]
