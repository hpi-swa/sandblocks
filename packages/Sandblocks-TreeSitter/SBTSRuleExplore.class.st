Class {
	#name : #SBTSRuleExplore,
	#superclass : #Object,
	#instVars : [
		'stream',
		'root',
		'matchFullToken'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> addVisitedSymbol: aSymbol [

	
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> atEnd [

	^ stream atEnd
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> cancel [
	" find last choice that is not fully explored and try again "

	
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> explore: aBlock for: String [

	self root: Morph new.
	self stream: String readStream.
	aBlock buildIn: self root info: self
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> hasVisitedSymbol: aSymbol [

	^ false
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> matchFullToken [

	^ matchFullToken
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> matchFullToken: aBoolean [

	matchFullToken := aBoolean
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> root [

	^ root
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> root: aBlock [

	root := aBlock
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> stream [

	^ stream
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> stream: aStream [

	stream := aStream
]

{ #category : #'as yet unclassified' }
SBTSRuleExplore >> success [

	| options |
	options add: root veryDeepCopy.
	self cancel
]
