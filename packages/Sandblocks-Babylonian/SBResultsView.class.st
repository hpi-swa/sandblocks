Class {
	#name : #SBResultsView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBResultsView >> buildAllPossibleResults [
	
	self subclassResponsibility
]

{ #category : #actions }
SBResultsView >> visualize [ 

	super visualize.
	self buildAllPossibleResults 
]
