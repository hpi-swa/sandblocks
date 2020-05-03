Class {
	#name : #SBMutatePropertyCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'selector',
		'value',
		'oldValue'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> affectedMorphs [

	^ {target}
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> do [

	oldValue ifNil: [oldValue := target perform: selector].
	target perform: selector asSimpleSetter with: value.
	^ target
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
SBMutatePropertyCommand >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> undo [

	target perform: selector asSimpleSetter with: oldValue.
	^ target
]

{ #category : #'as yet unclassified' }
SBMutatePropertyCommand >> value: anObject [

	value := anObject
]
