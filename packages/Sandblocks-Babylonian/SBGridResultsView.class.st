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
	widthTillWrap := self multiverse sandblockEditor width * 0.9.
	gridContainer fullBounds width < widthTillWrap ifTrue: [^ self]. 
	
	self descentToScreenRatioMaxWidth: widthTillWrap.
	
	gridContainer hResizing: #shrinkWrap.
]

{ #category : #updating }
SBGridResultsView >> descentToScreenRatioMaxWidth: maxWidth [

	| editorRatio submorphIndex |
	gridContainer hResizing: #rigid; wrapDirection: #topToBottom.
	editorRatio := DisplayScreen boundingBox width /  DisplayScreen boundingBox height.
	submorphIndex := gridContainer submorphs size.
	
	[gridContainer fullBounds width / gridContainer height > editorRatio 
		and: [submorphIndex > 1]]
		whileTrue: [ | isBelowMax |
			isBelowMax := gridContainer width < maxWidth.
			gridContainer width: gridContainer width 
								- (gridContainer submorphs atWrap:  submorphIndex) width.
				
			(editorRatio > 1 
			and: [gridContainer fullBounds height >= gridContainer width]
			and: [isBelowMax])
				ifTrue: [ gridContainer width: gridContainer width 
											+(gridContainer submorphs atWrap:  submorphIndex) width.
						submorphIndex := -1]
				ifFalse: [submorphIndex := submorphIndex - 1]].
				
	gridContainer width > maxWidth ifTrue: [gridContainer width: maxWidth]
]

{ #category : #updating }
SBGridResultsView >> gridSize [

	self subclassResponsibility 
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
