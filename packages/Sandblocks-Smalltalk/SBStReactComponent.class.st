Class {
	#name : #SBStReactComponent,
	#superclass : #SBStASTNode,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStReactComponent >> children [

	^ self submorphs third
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> componentClass [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> componentClass: aClassBlock props: aDictionary children: anArray [

	aClassBlock currentTextMorph ifNotNil: [:t | t bold].
	self addMorphBack: aClassBlock.
	self addMorphBack: (SBStInvisibleArray new addAllMorphs: aDictionary submorphs veryDeepCopy).
	self addMorphBack: (SBStInvisibleArray new addAllMorphs: anArray submorphs veryDeepCopy)
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> drawBackgroundOn: aCanvas [

	aCanvas
		frameAndFillRoundRect: self bounds
		radius: 5
		fillStyle: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self)
		borderColor: (self colorPolicy borderColorForBlock: self)
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		layoutInset: 8;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self componentClass layoutCommands.
			SBAlgebraCommand gap.
			self props layoutCommands.
			SBAlgebraCommand indent data: (self children hasSubmorphs
				ifTrue: [{SBAlgebraCommand hardLine withGap: true}]
				ifFalse: [{SBAlgebraCommand gap}]), {self children layoutCommands}}
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> props [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBStReactComponent >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self componentClass writeSourceOn: aStream.
	aStream nextPutAll: ') asElementBuilder'.
	
	self props submorphs ifNotEmpty: [
		aStream nextPutAll: ' props: '.
		self props writeSourceOn: aStream.
		aStream nextPut: $;].
	self children submorphs ifNotEmpty: [
		aStream nextPutAll: ' children: '.
		self children writeSourceOn: aStream.
		aStream nextPut: $;].
	aStream nextPutAll: 'build'
]
