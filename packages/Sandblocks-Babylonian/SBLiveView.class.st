Class {
	#name : #SBLiveView,
	#superclass : #SBGridResultsView,
	#instVars : [
		'broadcaster'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBLiveView >> buildAllPossibleResults [
	
	self multiverse universes do: [:aUniverse | self buildPreviewFor: aUniverse activePermutation]
]

{ #category : #'as yet unclassified' }
SBLiveView >> buildBrodcaster [

	self block addMorphBack: (SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		wrapCentering: #center;
		listCentering: #center;
		cellPositioning: #center;
		addMorph: (broadcaster := SBInputBroadcaster new))
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
			addMorphBack: (([Morph new] asSandblock statements first) width: 200))
]

{ #category : #'as yet unclassified' }
SBLiveView >> clean [

	self block submorphs allButFirst copy do: #delete.
	
	gridContainer := self newGridContainer.
]

{ #category : #'as yet unclassified' }
SBLiveView >> evaluateSetUp [

	^ self setUpMorph evaluate
]

{ #category : #'as yet unclassified' }
SBLiveView >> gridObjects [
	
	^ self multiverse universes 
]

{ #category : #initialization }
SBLiveView >> initialize [ 

	super initialize.
	
	self name: 'Live View'.
	self buildSetUpRow.
]

{ #category : #'as yet unclassified' }
SBLiveView >> listeners [

	^ broadcaster listeners 
]

{ #category : #'as yet unclassified' }
SBLiveView >> newRegisteredListenerFor: aPermutation [ 

	| listener |
	listener := self evaluateSetUp.
	broadcaster listeners add: listener.
	
	listener allMorphsDo: [:aSubMorph | 
		SBExploriants objectToPermutation at: aSubMorph put: aPermutation].
	
	^ listener
	
]

{ #category : #'as yet unclassified' }
SBLiveView >> setUpMorph [

	^ self block firstSubmorph "setup row" lastSubmorph 
]

{ #category : #'as yet unclassified' }
SBLiveView >> toggleStepping [

	self listeners do: [:aMorph |
		aMorph isStepping ifFalse: [aMorph startStepping] ifTrue: [aMorph stopStepping]]
]

{ #category : #'as yet unclassified' }
SBLiveView >> visualize [ 

	self clean.
	
	self buildBrodcaster.
	self block addMorphBack: self updateButton.
	self block addMorphBack: gridContainer.
	self buildAllPossibleResults.
]
