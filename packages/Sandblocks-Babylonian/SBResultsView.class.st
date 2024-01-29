Class {
	#name : #SBResultsView,
	#superclass : #SBExploriantsView,
	#instVars : [
		'morphResizer'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBResultsView >> buildAllPossibleResults [
	
	self subclassResponsibility
]

{ #category : #initialization }
SBResultsView >> initialize [ 

	super initialize.
	
	morphResizer := SBMorphResizer newThumbmail.
]

{ #category : #actions }
SBResultsView >> visualize [ 

	super visualize.
	self buildAllPossibleResults 
]
