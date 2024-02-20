Class {
	#name : #SBGridResultsView,
	#superclass : #SBResultsView,
	#instVars : [
		'gridContainer'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #actions }
SBGridResultsView >> clean [

	super clean.
	
	self block addMorphBack: (gridContainer := self newGridContainer)
	
]

{ #category : #updating }
SBGridResultsView >> concludeContainerWidth [
	
	| widthTillWrap |
	widthTillWrap := self multiverse sandblockEditor width * 0.95.
	gridContainer fullBounds width < widthTillWrap ifTrue: [^ self]. 
	
	gridContainer hResizing: #rigid; wrapDirection: #topToBottom.
	gridContainer width: widthTillWrap.
	gridContainer hResizing: #shrinkWrap.
]

{ #category : #initialization }
SBGridResultsView >> initialize [ 

	super initialize.
	
	self block addMorphBack: (gridContainer := self newGridContainer).
]

{ #category : #building }
SBGridResultsView >> newGridContainer [

	^ SBBlock new
		changeTableLayout;
		color: Color white;
		listDirection: #leftToRight;
		wrapCentering: #topLeft;
		cellInset: 0;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		yourself
]

{ #category : #actions }
SBGridResultsView >> visualize [ 

	super visualize.
	self concludeContainerWidth
]
