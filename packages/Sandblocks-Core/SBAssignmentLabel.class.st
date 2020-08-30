Class {
	#name : #SBAssignmentLabel,
	#superclass : #SBNameBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> fixActions [

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
				do: [:node | node sandblockEditor declareInstanceVariable: node contents for: node containingArtefact methodClass].
		}]
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> inputCommandClass [

	^ SBBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> isBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> printBlockOn: aStream [

	aStream nextPutAll: 'assign to '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> resolveBinding [

	self block binding: self contents for: self block class: self block containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForAssignmentLabel: self block
]

{ #category : #'as yet unclassified' }
SBAssignmentLabel >> valid [

	^ self resolveBinding notNil
]
