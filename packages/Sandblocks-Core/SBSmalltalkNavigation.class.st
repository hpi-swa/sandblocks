Class {
	#name : #SBSmalltalkNavigation,
	#superclass : #SBNavigation,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> nextFrom: aBlock [

	| next |
	next := SBDepthFirstPreOrderNavigation new nextFrom: aBlock.
	^ next ifNotNil: [self nextWithoutMessageSend: next]
]

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> nextOnMessage: next with: aBlock [

	^ next isMessageSend
		ifTrue: [next firstDeepChild]
		ifFalse: [
			(next parentSandblock isMessageSend and: [aBlock isLastChild]) ifTrue: [aBlock parentSandblock] ifFalse: [next]]
]

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> nextWithoutMessageSend: aBlock [

	^ aBlock skipLeftRightNavigation
		ifTrue: [
			(aBlock isMessageSend and: [aBlock receiver isNil])
				ifTrue: [aBlock messageParts first]
				ifFalse: [self nextWithoutMessageSend: aBlock childSandblocks first]]
		ifFalse: [aBlock]
]

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> previousFrom: aBlock [

	| previous |
	previous := SBDepthFirstPreOrderNavigation new previousFrom: aBlock.
	^ previous ifNotNil: [self previousWithoutMessageSend: previous]
]

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> previousWithoutMessageSend: aBlock [

	^ aBlock skipLeftRightNavigation
		ifTrue: [ | adjacent |
			adjacent := aBlock adjacentBlock: -1.
			self previousWithoutMessageSend: (adjacent ifNotNil: [adjacent lastDeepChild] ifNil: [aBlock parentSandblock])]
		ifFalse: [aBlock]
]
