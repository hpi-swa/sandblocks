Class {
	#name : #SBStDeclarationForLocalVariable,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'local variable'
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> attached: aBlock [

	super attached: aBlock.
	aBlock attachDecorator: (SBReportedValueDecorator new label: [self block binding value asString])
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> browse [
	<action>

	self binding value browse
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> detached: aBlock [

	aBlock detachDecorators: SBReportedValueDecorator.
	super detached: aBlock
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> guessedClass [

	^ self block binding value class
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	self block binding value: aBlock unpackSelection evaluate.
	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> objectInterface [

	^ SBInterfaces stExpression
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'local '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> scope [

	^ {self block containingArtefact}
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForLocalVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationForLocalVariable >> valid [

	^ true
]
