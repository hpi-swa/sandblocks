Class {
	#name : #SBRow,
	#superclass : #Morph,
	#instVars : [
		'hideWhenEmpty'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRow >> hideWhenEmpty [

	^ hideWhenEmpty
]

{ #category : #'as yet unclassified' }
SBRow >> hideWhenEmpty: anObject [

	hideWhenEmpty := anObject.
	self visible: self visible
]

{ #category : #'as yet unclassified' }
SBRow >> initialize [ 

	super initialize.
	
	hideWhenEmpty := false.

	self
		extent: 0 @ 0;
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBRow >> visible [

	^ self hideWhenEmpty not or: [self submorphs anySatisfy: [:s | s visible]]
]

{ #category : #'as yet unclassified' }
SBRow >> wantsMetaMenu [

	^ false
]
