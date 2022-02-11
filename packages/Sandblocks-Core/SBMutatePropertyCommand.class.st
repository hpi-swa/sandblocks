Class {
	#name : #SBMutatePropertyCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'selector',
		'value',
		'oldValue',
		'mutateSelector'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> affectedMorphs [

	^ {target}
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> do [

	oldValue ifNil: [oldValue := target perform: selector].
	target perform: (mutateSelector ifNil: [selector asSimpleSetter]) with: value.
	^ target containingSandblock
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> mutateSelector: aSymbol [

	mutateSelector := aSymbol
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> oldValue [

	^ oldValue
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> oldValue: anObject [

	oldValue := anObject
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> selector: aSymbol [

	selector := aSymbol
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> setArtefactFrom [

	^ target
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> target: anObject selector: aSymbol value: aNewObject [

	self target: anObject.
	self selector: aSymbol.
	self value: aNewObject
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> undo [

	target perform: (mutateSelector ifNil: [selector asSimpleSetter]) with: oldValue.
	^ target
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> value: anObject [

	value := anObject
]
