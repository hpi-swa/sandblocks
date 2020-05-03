Class {
	#name : #SBDeclarationBehavior,
	#superclass : #SBNameBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> allUsages [

	^ Array streamContents: [:stream |
		self scope select: #notNil thenDo: [:scope |
			scope allBlocksDo: [:block |
				(block isBinding and: [block behavior resolveBinding = self block]) ifTrue: [stream nextPut: block]]]]
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> isDeclaration [

	^ true
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> isMethodLocal [

	^ false
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> resolveBinding [

	^ self
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> scope [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> valid [

	^ self isReserved not
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> wasDeselected [

	self flag: #todo. " will not clean up on changed usages "
	self isInWorld ifTrue: [
		self allUsages do: [:b | b detachDecorators: SBHighlightDecorator]]
]

{ #category : #'as yet unclassified' }
SBDeclarationBehavior >> wasSelected [

	self allUsages do: [:b | b attachDecorator: SBHighlightDecorator new]
]
