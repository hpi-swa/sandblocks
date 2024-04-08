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
	
	self multiverse watches ifEmpty: [^ self].
	self multiverse universes do: [:aUniverse | self buildPreviewFor: aUniverse]
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
SBLiveView >> buildPreviewFor: aUniverse [
	
	| preview |	
	preview := self newRegisteredListenerFor: aUniverse.
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				 addAllMorphsBack: { 
					(SBPermutationLabel newDisplaying: aUniverse activePermutation) wrapFlag: false.
					self newPermutationButtonRowFor: aUniverse showing: preview.
					preview}}).
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
SBLiveView >> newPermutationButtonRowFor: aUniverse showing: aPreview [

	^ self containerRow
		layoutInset: 0;
		cellInset: 0;
		addAllMorphsBack: {
			SBButton newApplyPermutationFor: aUniverse activePermutation. 
			self rebuildButtonIn: aPreview applying: aUniverse. 
			self synchronizeButtonIn: aPreview}
]

{ #category : #initialization }
SBLiveView >> newRegisteredListenerFor: aUniverse [ 

	| listener value container watch |
	self flag: #todo. "for multiple watch values"
	watch := aUniverse watches first.
	value := watch exampleToValues values first first watchedValue.
	listener := value veryDeepCopy asMorph.
	container := broadcaster addListener: listener.
	
	listener allMorphsDo: [:aSubMorph | 
		SBExploriants objectToPermutation at: aSubMorph put: watch createdWithPermutation].
	
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
SBLiveView >> rebuildButtonIn: aContainer applying: aUniverse [

	^ SBButton new
		icon: (SBIcon iconRotateRight size: 8.0 sbScaled)
			label: 'Re-Build This'
			do: [self rebuildRegisteredListenerFor: aUniverse in: aContainer];
		makeSmall;
		cornerStyle: #squared
]

{ #category : #initialization }
SBLiveView >> rebuildRegisteredListenerFor: aUniverse in: aContainer [ 

	self privateRegisterListener: (aUniverse watches first exampleToValues values first first watchedValue veryDeepCopy) for: aUniverse activePermutation in: aContainer 
	
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
SBLiveView >> snapshot [
						
	^ self containerRow 
				listDirection: #topToBottom;
				addAllMorphsBack: {
					ImageMorph new newForm: gridContainer imageForm}
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

	^ self.
	"self clean.
	
	self buildBrodcaster.
	self buildButtonRow.
	self block addMorphBack: gridContainer.
	self buildAllPossibleResults.
	
	self listeners ifNotEmpty: [broadcaster extent: self listeners last extent. ].
	self concludeContainerWidth.	"
]
