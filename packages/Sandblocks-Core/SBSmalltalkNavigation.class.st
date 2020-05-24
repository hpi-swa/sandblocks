Class {
	#name : #SBSmalltalkNavigation,
	#superclass : #SBNavigation,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> nextFrom: aBlock [

	| next |
	next := SBDepthFirstPreOrderNavigation new nextFrom: aBlock.
	next isMessageSend
]

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> nextOnMessage: next with: aBlock [

	^ next isMessageSend
		ifTrue: [next firstDeepChild]
		ifFalse: [
			(next parentSandblock isMessageSend and: [aBlock isLastChild]) ifTrue: [aBlock parentSandblock] ifFalse: [next]]
]

{ #category : #'as yet unclassified' }
SBSmalltalkNavigation >> previousFrom: aBlock [

	^ aBlock isMessageSend
		ifTrue: [
			SBDepthFirstPostOrderNavigation new previousFrom: aBlock]
		ifFalse: [
			SBDepthFirstPreOrderNavigation new previousFrom: aBlock]
]
