Class {
	#name : #SBStAssignmentLabel,
	#superclass : #SBStNameBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStAssignmentLabel class >> checkCastFor: aBlock parent: aMorph [

	^ aMorph isAssignment and: [aBlock isFirstChild]
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> browseSenders [
	<action>

	self resolveBinding ifNotNil: [:binding | binding behavior browseReferences]
]

{ #category : #'as yet unclassified' }
SBStAssignmentLabel >> fixActions [

	^ (self valid or: [self block validContents not])
		ifTrue: [#()]
		ifFalse: [
			{
				(self block containingBlock ifNotNil: [:b | b isMethodBody not] ifNil: [false])
					ifTrue: [
						SBCodeAction
							labeled: 'Declare block-local'
							for: self block
							do: [:node | node containingBlock declareTemporaryVariable: node contents]]
					ifFalse: [nil].
				SBCodeAction
					labeled: 'Declare method temporary'
					for: self block
					do: [:node | node containingArtefact body declareTemporaryVariable: node contents].
				SBCodeAction
					labeled: 'Declare instance variable'
					for: self block
					do: [:node | node behavior declareInstanceVariable]} select: #notNil]
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

	self block
		binding: self contents
		for: self block
		class: (self block containingArtefact ifNotNil: #relatedClass)
		ifPresent: [:b | ^ b].
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
