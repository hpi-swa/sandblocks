Class {
	#name : #SBLiveView,
	#superclass : #SBGridResultsView,
	#instVars : [
		'broadcaster'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBLiveView >> buildAllPossibleResults [
	
	self multiverse universes do: [:aUniverse | self buildPreviewFor: aUniverse activePermutation]
]

{ #category : #building }
SBLiveView >> buildBrodcaster [

	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: {
					SBOwnTextMorph new contents: 'Event Broadcaster'.
					broadcaster := SBInputBroadcaster new}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).

	"gridContainer addMorphBack: (SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		wrapCentering: #center;
		listCentering: #center;
		cellPositioning: #center;
		addMorph: (broadcaster := SBInputBroadcaster new))"
		
	self updateContainerWidth.	

]

{ #category : #building }
SBLiveView >> buildPreviewFor: aPermutation [
		
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					SBOwnTextMorph new contents: aPermutation asString.
					SBButton newApplyPermutationFor: aPermutation. 
					self newRegisteredListenerFor: aPermutation}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).
	
	self updateContainerWidth.
]

{ #category : #building }
SBLiveView >> buildSetUpRow [

	self block addMorph: (SBRow new
			changeTableLayout;
			hResizing: #spaceFill;
			wrapCentering: #center;
			listCentering: #center;
			cellPositioning: #center;
			cellGap: 8 * self scalingFactor;
			addMorphBack: (SBIcon iconSpinner
				balloonText: 'Toggle stepping';
				on: #click send: #toggleStepping to: self);
			addMorphBack: (SBStringMorph new contents: 'Setup:');
			addMorphBack: ([Morph new] asSandblock width: 200))
]

{ #category : #actions }
SBLiveView >> clean [

	self block submorphs allButFirst copy do: #delete.
	
	gridContainer := self newGridContainer.
]

{ #category : #actions }
SBLiveView >> evaluateSetUp [

	^ self setUpMorph evaluate value
]

{ #category : #updating }
SBLiveView >> gridSize [
	
	^ self multiverse universes size + 1
]

{ #category : #initialization }
SBLiveView >> initialize [ 

	super initialize.
	
	self name: 'Live View'.
	self buildSetUpRow.
]

{ #category : #accessing }
SBLiveView >> listeners [

	^ broadcaster listeners 
]

{ #category : #initialization }
SBLiveView >> newRegisteredListenerFor: aPermutation [ 

	| listener container |
	listener := self evaluateSetUp.
	container := broadcaster addListener: listener.
	
	listener allMorphsDo: [:aSubMorph | 
		SBExploriants objectToPermutation at: aSubMorph put: aPermutation].
	
	^ container
	
]

{ #category : #accessing }
SBLiveView >> setUpMorph [

	^ self block firstSubmorph "setup row" lastSubmorph 
]

{ #category : #actions }
SBLiveView >> toggleStepping [

	self listeners do: [:aMorph |
		aMorph isStepping ifFalse: [aMorph startStepping] ifTrue: [aMorph stopStepping]]
]

{ #category : #actions }
SBLiveView >> visualize [ 

	self clean.
	
	self buildBrodcaster.
	self block addMorphBack: self updateButton.
	self block addMorphBack: gridContainer.
	self buildAllPossibleResults.
	
	broadcaster extent: self listeners last extent. 
]
