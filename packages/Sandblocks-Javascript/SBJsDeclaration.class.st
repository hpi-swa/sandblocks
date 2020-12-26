Class {
	#name : #SBJsDeclaration,
	#superclass : #SBJsBinaryOperator,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsDeclaration >> binding [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> binding: aVariable value: aBlock [

	self addMorphBack: aVariable.
	self addMorphBack: (SBStringMorph new contents: ' = ').
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> expression [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> isDeclaration [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self binding layoutCommands.
			SBAlgebraCommand gap.
			SBAlgebraCommand morph data: self submorphs second.
			SBAlgebraCommand indent data: {
				SBAlgebraCommand softLineOrGap.
				self expression layoutCommands}}
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> lhs: aVariable rhs: aBlock [

	self binding: aVariable value: aBlock
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> startInputAt: aNumber replacingContents: aBoolean [

	^ nil
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> symbols [

	^ #('let ' nil)
]
