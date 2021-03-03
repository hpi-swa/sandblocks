Class {
	#name : #SBStAssignmentLabel,
	#superclass : #SBStNameBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> fixActions [

	^ self valid
		ifTrue: [#()]
		ifFalse: [{
			SBCodeAction
				labeled: 'Declare method temporary' for: self block
				do: [:node | node containingArtefact body declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare block-local' for: self block
				do: [:node | node containingBlock declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare instance variable' for: self block
				do: [:node | node behavior declareInstanceVariable].
		}]
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> isBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> printBlockOn: aStream [

	aStream nextPutAll: 'assign to '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> resolveBinding [

	self block binding: self contents for: self block class: self block containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForAssignmentLabel: self block
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> valid [

	^ self resolveBinding notNil
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> validBinding [

	^ self resolveBinding notNil
]
