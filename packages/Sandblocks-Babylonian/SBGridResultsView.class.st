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
		wrapDirection: #topToBottom;
		wrapCentering: #topLeft;
		hResizing: #rigid;
		width: 50;
		cellInset: 0;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : #updating }
SBGridResultsView >> updateContainerWidth [

	gridContainer width: 
		(self multiverse universes size safeSquareRoot ceiling) 
			* (gridContainer lastSubmorph fullBounds width 
				+ (2 * gridContainer cellInset) 
				+ (2 * gridContainer cellGap) 
				+ 10)
]
