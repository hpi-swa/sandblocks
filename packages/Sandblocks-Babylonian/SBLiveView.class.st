Class {
	#name : #SBLiveView,
	#superclass : #SBGridResultsView,
	#instVars : [
		'broadcaster',
		'errorDecorator',
		'errorIcon',
		'reportedError'
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
					SBOwnTextMorph new contents: 'Interact to send events'.
					broadcaster := SBInputBroadcaster new}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).

]

{ #category : #building }
SBLiveView >> buildButtonRow [

	self block addMorphBack: (SBRow new
			changeTableLayout;
			cellGap: 8 * self scalingFactor;
			addAllMorphsBack: {self updateButton. self rebuildButton})
]

{ #category : #building }
SBLiveView >> buildPreviewFor: aPermutation [
	
	| preview |	
	preview := self newRegisteredListenerFor: aPermutation.
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				 addAllMorphsBack: { 
					SBOwnTextMorph new contents: aPermutation asString.
					self newPermutationButtonRowFor: aPermutation showing: preview.
					preview}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).
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

	| return |
	errorIcon ifNotNil: #delete.  
	return := [self setUpMorph evaluate value asMorph] 
		on: Error do: [:err | self reportError: err. err asMorph].
	
	
	^ return
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

{ #category : #building }
SBLiveView >> newPermutationButtonRowFor: aPermutation showing: aPreview [

	^ SBRow new
		changeTableLayout;
		cellGap: 8 * self scalingFactor;
		addAllMorphsBack: {
			SBButton newApplyPermutationFor: aPermutation. 
			self rebuildButtonIn: aPreview applying: aPermutation. }
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

{ #category : #initialization }
SBLiveView >> newRegisteredListenerFor: aPermutation in: aContainer [ 

	| listener oldListener |
	listener := self evaluateSetUp.
	oldListener := aContainer valueOfProperty: #sbListener.
	oldListener owner
		ifNil: [broadcaster insertListener: listener into: aContainer] 
		ifNotNil: [broadcaster replaceListener: oldListener with: listener]. 
	
	listener allMorphsDo: [:aSubMorph | 
		SBExploriants objectToPermutation at: aSubMorph put: aPermutation].
	
]

{ #category : #building }
SBLiveView >> rebuildButton [

	^ SBButton new
		icon: SBIcon iconRotateRight
			label: 'Re-Build Setup'
			do: [self visualize];
		cornerStyle: #squared
]

{ #category : #building }
SBLiveView >> rebuildButtonIn: aContainer applying: aPermutation [

	^ SBButton new
		icon: (SBIcon iconRotateRight size: 8.0 sbScaled)
			label: 'Re-Build This'
			do: [self newRegisteredListenerFor: aPermutation in: aContainer];
		makeSmall;
		cornerStyle: #squared
]

{ #category : #actions }
SBLiveView >> reportError: anError [

	reportedError ifNotNil: [errorIcon delete. errorIcon := nil. reportedError := nil].

	reportedError := self multiverse sandblockEditor
			reportError: anError
			process: ((Process forContext: anError signalerContext copyStack priority: Processor activeProcess priority)
				shouldResumeFromDebugger: false;
				yourself)
			source: self.
			
	self block firstSubmorph addMorphBack: (errorIcon := SBIcon iconFlash).
	
	(SBSmallError findOpenContextFrom: anError signalerContext in: self multiverse sandblockEditor) 
		ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString; subtle: false; yourself)].
	
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
	self buildButtonRow.
	self block addMorphBack: gridContainer.
	self buildAllPossibleResults.
	
	broadcaster extent: self listeners last extent. 
	self updateContainerWidth.	
]
