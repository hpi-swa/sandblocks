Class {
	#name : #SBDeclarationForLocalVariable,
	#superclass : #SBDeclarationBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'local variable'
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> attached: aBlock [

	super attached: aBlock.
	aBlock attachDecorator: (SBReportedValueDecorator new label: [self block binding value asString])
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> browse [
	<action>

	self binding value browse
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> detached: aBlock [

	aBlock detachDecorators: SBReportedValueDecorator.
	super detached: aBlock
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> guessedClass [

	^ self block binding value class
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> handleDroppedBlock: aBlock event: anEvent [

	self block binding value: aBlock evaluate.
	^ true
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> inputCommandClass [

	^ SBBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'local '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> scope [

	^ {self block containingArtefact}
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForLocalVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBDeclarationForLocalVariable >> valid [

	^ true
]
