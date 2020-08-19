Class {
	#name : #SBThresholdLayout,
	#superclass : #SBLayoutPolicy,
	#instVars : [
		'thresholdWidth'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBThresholdLayout >> layout: aMorph in: aRectangle [

	(self layoutPolicyFor: aMorph in: aRectangle) layout: aMorph in: aRectangle
]

{ #category : #'as yet unclassified' }
SBThresholdLayout >> layoutPolicyFor: aMorph in: aRectangle [

	^ (SBHorizontalLayout minExtentOf: aMorph in: aRectangle) x > thresholdWidth
		ifTrue: [SBVerticalLayout]
		ifFalse: [SBHorizontalLayout]
]

{ #category : #'as yet unclassified' }
SBThresholdLayout >> minExtentOf: aMorph in: aRectangle [

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := (self layoutPolicyFor: aMorph in: aRectangle) minExtentOf: aMorph in: aRectangle
]

{ #category : #'as yet unclassified' }
SBThresholdLayout >> thresholdWidth: aNumber [

	thresholdWidth := aNumber
]
