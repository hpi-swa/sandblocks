Class {
	#name : #SBJsDeclaration,
	#superclass : #SBJsInfixOperator,
	#instVars : [
		'declarationType'
	],
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsDeclaration >> binding [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> binding: aVariable value: aBlock declarationType: aString [

	self declarationType: aString.
	self addMorphBack: aVariable.
	self addMorphBack: (SBStringMorph new contents: ' = ').
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> contents [

	^ '='
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> declarationType: aString [

	declarationType := aString
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
SBJsDeclaration >> isExpression [

	^ false
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

	self binding: aVariable value: aBlock declarationType: 'let'
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> preferredColorIn: aColorPolicy [

	^ aColorPolicy keyword
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> startInputCommand [

	^ nil
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> stopEditing: aCommand [
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> symbols [

	^ {declarationType, ' '. nil}
]

{ #category : #'as yet unclassified' }
SBJsDeclaration >> writeSourceOn: aStream [

	aStream nextPutAll: declarationType; space.
	self binding writeSourceOn: aStream.
	aStream nextPutAll: ' = '.
	self rhs writeSourceOn: aStream
]
