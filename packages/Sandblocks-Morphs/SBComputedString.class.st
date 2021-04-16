"
A SBComputedString implements the String interface but always queries the block given to value: when it is asked for its contents. Best not to change this answer mid-frame.
"
Class {
	#name : #SBComputedString,
	#superclass : #String,
	#instVars : [
		'value'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBComputedString >> at: aNumber [

	^ self value at: aNumber
]

{ #category : #'as yet unclassified' }
SBComputedString >> do: aBlock [

	self value do: aBlock
]

{ #category : #'as yet unclassified' }
SBComputedString >> size [

	^ self value size
]

{ #category : #'as yet unclassified' }
SBComputedString >> value [

	^ value value
]

{ #category : #'as yet unclassified' }
SBComputedString >> value: aBlock [

	value := aBlock
]
