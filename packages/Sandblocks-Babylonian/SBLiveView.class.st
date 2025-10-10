Class {
	#name : #SBLiveView,
	#superclass : #SBGridResultsView,
	#instVars : [
		'broadcaster',
		'errorDecorator',
		'errorIcon',
		'reportedError',
		'lastSave'
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
					TextMorph new contents: 'Event Broadcaster'.
					TextMorph new contents: 'Interact with to send events to all others'.
					broadcaster := SBInputBroadcaster new}}).

]

{ #category : #building }
SBLiveView >> buildPreviewFor: aPermutation [
	
	| preview |	
	preview := self newRegisteredListenerFor: aPermutation.
	gridContainer addMorphBack: (self containerRow 
		cellPositioning: #center;
		tag: (SBTag newFromPermutation: aPermutation);
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				 addAllMorphsBack: { 
					(SBPermutationLabel newDisplaying: aPermutation) wrapFlag: false.
					self newPermutationButtonRowFor: aPermutation showing: preview.
					preview}}).
]

{ #category : #building }
SBLiveView >> buildSetUpRow [ 

	self block addMorphBack: (SBRow new
			changeTableLayout;
			hResizing: #spaceFill;
			wrapCentering: #center;
			listCentering: #center;
			cellPositioning: #center;
			name: #setup;
			cellGap: 8 * self scalingFactor;
			addMorphBack: (SBIcon iconSpinner
				balloonText: 'Toggle stepping';
				on: #click send: #toggleStepping to: self);
			addMorphBack: (SBStringMorph new contents: 'Setup:');
			addMorphBack: ([Morph new] asSandblock width: 200))
]

{ #category : #building }
SBLiveView >> buttons [

	^ {self rebuildButton. self reloadLastSaveButton}
]

{ #category : #actions }
SBLiveView >> clean [

	(self block submorphs reject: [:aSubmorph| aSubmorph externalName = 'setup']) copy do: #delete.
	
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

{ #category : #initialization }
SBLiveView >> initialize [ 

	super initialize.
	
	self name: 'Playground'.
	self buildSetUpRow.
	
	
]

{ #category : #building }
SBLiveView >> jumpToLastSave [

	lastSave ifNil: [^ self].
	broadcaster containers do: [:otherContainer |
			self privateRegisterListener: lastSave veryDeepCopy 
				for: (SBExploriants objectToPermutation at: (otherContainer  valueOfProperty: #sbListener)) 
				in: otherContainer ]
]

{ #category : #accessing }
SBLiveView >> listeners [

	^ broadcaster listeners 
]

{ #category : #building }
SBLiveView >> newPermutationButtonRowFor: aPermutation showing: aPreview [

	^ self containerRow
		layoutInset: 0;
		cellInset: 0;
		addAllMorphsBack: {
			self rebuildButtonIn: aPreview applying: aPermutation. 
			self synchronizeButtonIn: aPreview}
]

{ #category : #initialization }
SBLiveView >> newRegisteredListenerFor: aPermutation [ 

	| listener container |
	SBActiveVariantPermutation value: aPermutation.
	listener := self evaluateSetUp.
	container := broadcaster addListener: listener.
	
	listener allMorphsDo: [:aSubMorph | 
		SBExploriants objectToPermutation at: aSubMorph put: aPermutation].
	
	SBActiveVariantPermutation value: nil.
	^ container
	
]

{ #category : #initialization }
SBLiveView >> privateRegisterListener: aNewListener for: aPermutation in: aContainer [ 

	| oldListener |
	oldListener := aContainer valueOfProperty: #sbListener.
	oldListener owner
		ifNil: [broadcaster insertListener: aNewListener into: aContainer] 
		ifNotNil: [broadcaster replaceListener: oldListener with: aNewListener]. 
	
	aNewListener allMorphsDo: [:aSubMorph | 
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
			do: [self rebuildRegisteredListenerFor: aPermutation in: aContainer];
		makeSmall;
		cornerStyle: #squared
]

{ #category : #initialization }
SBLiveView >> rebuildRegisteredListenerFor: aPermutation in: aContainer [ 

	self privateRegisterListener: self evaluateSetUp for: aPermutation in: aContainer 
	
]

{ #category : #building }
SBLiveView >> reloadLastSaveButton [

	^ SBButton new
		icon: SBIcon iconRotateRight
			label: 'Reset To Last Synch'
			do: [self jumpToLastSave ];
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

	^ (self block submorphNamed: 'setup') lastSubmorph 
]

{ #category : #copying }
SBLiveView >> snapshotSatisfying: aCollectionOfSBTags [
						
	^ self containerRow 
				listDirection: #topToBottom;
				addAllMorphsBack: {
					ImageMorph new newForm: (self block submorphNamed: 'setup') imageForm.
					gridContainer snapshotSatisfying: aCollectionOfSBTags}
]

{ #category : #building }
SBLiveView >> synchronizeButtonIn: aContainer [

	^ SBButton new
		icon: (SBIcon iconRecycle size: 8.0 sbScaled)
			label: 'Synchronize others'
			do: [self synchronizePreviewsWith: aContainer];
		makeSmall;
		cornerStyle: #squared
]

{ #category : #building }
SBLiveView >> synchronizePreviewsWith: aContainer [ 

	| replacingListener |
	replacingListener := (aContainer valueOfProperty: #sbListener).
	lastSave := replacingListener veryDeepCopy.
	(broadcaster containers reject: [:someContainer | aContainer == someContainer])
		do: [:otherContainer |
			self privateRegisterListener: replacingListener veryDeepCopy 
				for: (SBExploriants objectToPermutation at: (otherContainer  valueOfProperty: #sbListener)) 
				in: otherContainer ]
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
	self concludeContainerWidth.	
]
