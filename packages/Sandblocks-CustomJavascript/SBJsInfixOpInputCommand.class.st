Class {
	#name : #SBJsInfixOpInputCommand,
	#superclass : #SBCommand,
	#instVars : [
		'operator',
		'previousOperator',
		'previousRhs',
		'morph',
		'doRotate',
		'undoRotate'
	],
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> do [

	| rhs |
	morph contents: operator.
	
	rhs := morph allRhs.
	rhs size > morph arity ifTrue: [rhs from: morph arity + 1 to: rhs size do: [:arg | arg delete]].
	rhs size < morph arity ifTrue: [rhs size + 1 to: morph arity do: [:i | morph addMorphBack: morph newNullBlock]].
	
	doRotate ifTrue: [
		undoRotate := morph parentSandblock.
		(SBSubtreeRotateCommand new target: morph) do].
	
	^ morph rhs ifNil: [morph]
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> doRotate: aBoolean [

	doRotate := aBoolean
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> hasChange [

	^ operator ~= previousOperator
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> operator: aString [

	operator := aString
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> previousOperator [

	^ previousOperator
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> previousOperator: aString [

	previousOperator := aString
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> previousRhs: aCollection [

	previousRhs := aCollection
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> setArtefactFrom [

	^ morph
]

{ #category : #'as yet unclassified' }
SBJsInfixOpInputCommand >> undo [

	doRotate ifTrue: [(SBSubtreeRotateCommand new target: undoRotate) do].
	
	morph contents: previousOperator.
	
	morph allRhs do: #delete.
	morph addAllMorphsBack: previousRhs.
	
	^ morph
]
