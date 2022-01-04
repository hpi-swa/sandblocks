Class {
	#name : #SBBlockCursor,
	#superclass : #Morph,
	#instVars : [
		'cursorShown',
		'blinkCount',
		'editor',
		'cursorPosition',
		'selectLargerHistory',
		'horizontalOffsetInFloat',
		'multiSelection',
		'lastBlinkTime'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'vertical movement' }
SBBlockCursor >> adjacentVerticalCalcDistance: aDistBlock validBlock: aValidBlock [

	| allCandidates candidates candidatesBestDistance tolerance float |
	self selectedBlock ifNil: [^ nil].
	
	float := self selectedBlock containingFloat.
	tolerance := 10.
	allCandidates := Array streamContents: [:stream | float allVisibleMorphsDo: [:candidate | ((candidate isTextMorph or: [candidate isSandblock and: [candidate hasChildSandblocks not and: [candidate isSelectable]]]) and: [aValidBlock value: candidate]) ifTrue: [stream nextPut: candidate]]].
	candidates := OrderedCollection new.
	candidatesBestDistance := 900000000.
	allCandidates do: [:candidate | | distance |
		distance := aDistBlock value: candidate.
		distance < candidatesBestDistance
			ifTrue: [
				(candidatesBestDistance between: distance and: distance + tolerance)
					ifTrue: [candidates add: candidate]
					ifFalse: [candidates := OrderedCollection with: candidate].
				candidatesBestDistance := distance]
			ifFalse: [(distance between: candidatesBestDistance and: candidatesBestDistance + tolerance) ifTrue: [candidates add: candidate]]].
	^ (candidates detectMin: [:candidate | (candidate left - float left to: candidate right - float left) distanceTo: horizontalOffsetInFloat]) ifNotNil: #containingSandblock
]

{ #category : #api }
SBBlockCursor >> color [

	^ cursorPosition color
]

{ #category : #api }
SBBlockCursor >> currentCommand [

	^ cursorPosition currentCommand
]

{ #category : #testing }
SBBlockCursor >> cursorAlwaysVisible [

	^ self editor hasKeyboardFocus not or: [blinkCount >= self maxBlickCount]
]

{ #category : #private }
SBBlockCursor >> cursorForBlock: aBlock at: aPoint [

	^ aBlock startInputCommand
		ifNotNil: [:command | SBCursorText new block: aBlock; pixelPosition: aPoint; currentCommand: command]
		ifNil: [SBCursorSelect new block: aBlock]
]

{ #category : #accessing }
SBBlockCursor >> cursorPosition [

	^ cursorPosition
]

{ #category : #private }
SBBlockCursor >> cursorPosition: aPosition explicitMove: aBoolean axis: aSymbol [

	| previousBlock previousCursor |
	previousBlock := self selectedBlock.
	previousCursor := cursorPosition.
	
	(aPosition hasDifferentEffect: previousCursor)
		ifTrue: [
			cursorPosition := SBCursorNone new.
			previousCursor ifNotNil: [:c |
				c leaveIn: self editor.
				c removeActionsWithReceiver: self].
			cursorPosition := aPosition.
			cursorPosition when: #showLabel send: #showLabel: to: self.
			cursorPosition ifNotNil: [:position | position enter]]
		ifFalse: [previousCursor maybeUpdateFor: aPosition].
	
	self resetBlink.
	blinkCount := 0.
	self updateBounds.
	Project current addDeferredUIMessage: [self updateBounds].
	aSymbol ~= #z ifTrue: [selectLargerHistory removeAll].
	self editor
		triggerEvent: #selectionChanged with: self selectedBlock;
		updateSelectionLabel.
	((#(#z #y) includes: aSymbol) not and: [aBoolean]) ifTrue: [self updateHorizontalOffset].
	
	self selectedBlock ~= previousBlock ifTrue: [
		previousBlock removeActionsWithReceiver: self.
		previousBlock ifNotNil: #wasDeselected.
		lastBlinkTime := DateAndTime current.
		self selectedBlock ifNotNil: [:b |
			b
				wasSelected;
				ensureVisible]]
]

{ #category : #testing }
SBBlockCursor >> cursorVisible [

	^ cursorShown or: [self cursorAlwaysVisible]
]

{ #category : #drawing }
SBBlockCursor >> drawOn: aCanvas [

	self cursorVisible ifTrue: [self cursorPosition drawOn: aCanvas in: self bounds]
]

{ #category : #accessing }
SBBlockCursor >> editor [

	^ editor
]

{ #category : #accessing }
SBBlockCursor >> editor: anEditor [

	editor := anEditor
]

{ #category : #layout }
SBBlockCursor >> flushLayoutCache [

	
]

{ #category : #'vertical movement' }
SBBlockCursor >> globalHorizontalOffset [

	^ horizontalOffsetInFloat + self selectedBlock containingFloat left
]

{ #category : #'vertical movement' }
SBBlockCursor >> idealPixelPositionEnterNear: aSymbol for: aBlock [

	aBlock currentTextMorph ifNil: [^ aBlock center].
	
	^ horizontalOffsetInFloat + (aBlock containingFloat ifNotNil: [:a | a left] ifNil: [0]) @ ((aBlock currentTextMorph perform: aSymbol) + (aSymbol = #top ifTrue: [4] ifFalse: [-4]))
]

{ #category : #initialization }
SBBlockCursor >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		disableLayout: true;
		layoutPolicy: self.
	
	selectLargerHistory := OrderedCollection new.
	cursorShown := false.
	blinkCount := 0.
	horizontalOffsetInFloat := 0.
	cursorPosition := SBCursorNone new
]

{ #category : #layout }
SBBlockCursor >> layout: aMorph in: aRectangle [

	| extent label |
	aMorph hasSubmorphs ifFalse: [^ self].
	
	label := aMorph firstSubmorph.
	extent := label minExtent.
	label layoutInBounds: (self topRight - (0 @ extent y) extent: extent) positioning: #center
]

{ #category : #actions }
SBBlockCursor >> lookupGlobalAction: aSymbol [

	^ (self class lookupSelector: aSymbol) ifNotNil: [:m | (m pragmaAt: #globalAction) ifNotNil: [m]]
]

{ #category : #blinking }
SBBlockCursor >> maxBlickCount [

	^ 20
]

{ #category : #layout }
SBBlockCursor >> minExtentOf: aMorph in: aRectangle [

	^ aRectangle
]

{ #category : #accessing }
SBBlockCursor >> mode [

	^ self cursorPosition mode
]

{ #category : #accessing }
SBBlockCursor >> morphicLayerNumber [

	^ 0
]

{ #category : #api }
SBBlockCursor >> moveCursorClick: aBlock at: aPoint [

	self cursorPosition: (self cursorForBlock: aBlock at: aPoint) explicitMove: true axis: #none
]

{ #category : #api }
SBBlockCursor >> moveCursorDown [
	<globalAction>

	cursorPosition moveCursorDown: self
]

{ #category : #api }
SBBlockCursor >> moveCursorLarger [
	<globalAction>

	| newPosition previousPosition |
	previousPosition := self cursorPosition.
	newPosition := self cursorPosition selectLarger.
	
	self cursorPosition: newPosition explicitMove: true axis: #z.
	
	previousPosition ~= newPosition ifTrue: [selectLargerHistory addLast: previousPosition]
]

{ #category : #api }
SBBlockCursor >> moveCursorLeft [
	<globalAction>

	self moveHorizontal: -1
]

{ #category : #api }
SBBlockCursor >> moveCursorLeftWordwise [
	<globalAction>

	self moveHorizontal: -1 wordWise: true
]

{ #category : #api }
SBBlockCursor >> moveCursorRight [
	<globalAction>

	self moveHorizontal: 1
]

{ #category : #api }
SBBlockCursor >> moveCursorRightWordwise [
	<globalAction>

	self moveHorizontal: 1 wordWise: true
]

{ #category : #api }
SBBlockCursor >> moveCursorSmaller [
	<globalAction>

	self
		cursorPosition: (selectLargerHistory
			ifNotEmpty: [selectLargerHistory removeLast]
			ifEmpty: [self cursorPosition selectSmaller])
		explicitMove: true
		axis: #z
]

{ #category : #api }
SBBlockCursor >> moveCursorUp [
	<globalAction>

	cursorPosition moveCursorUp: self
]

{ #category : #private }
SBBlockCursor >> moveHorizontal: aNumber [

	self moveHorizontal: aNumber wordWise: false
]

{ #category : #private }
SBBlockCursor >> moveHorizontal: aNumber wordWise: aBoolean [

	| newPos |
	newPos := self cursorPosition.
	[newPos := newPos moveHorizontal: aNumber wordWise: aBoolean] doWhileTrue: [aBoolean and: [newPos class ~= SBCursorText and: [newPos notNil]]].
	newPos ifNil: [^ self].
	
	newPos ~= self cursorPosition ifTrue: [newPos placeAtEnd: (aBoolean ifTrue: [aNumber > 0] ifFalse: [aNumber < 0])].
	
	self cursorPosition: newPos explicitMove: true axis: #x
]

{ #category : #multiselection }
SBBlockCursor >> multiSelection [

	^ cursorPosition multiSelection
]

{ #category : #multiselection }
SBBlockCursor >> multiSelection: aCollection [

	self cursorPosition: (SBCursorMultiSelect new selected: aCollection) explicitMove: true axis: #none
]

{ #category : #'vertical movement' }
SBBlockCursor >> nextVertical [

	^ self
		adjacentVerticalCalcDistance: [:candidate | candidate top - cursorPosition selectionBounds bottom]
		validBlock: [:candidate | candidate top >= cursorPosition selectionBounds bottom]
]

{ #category : #api }
SBBlockCursor >> prepareForNextCommand [
	" if we have a pending input command, make sure it is finished "
	
	cursorPosition mode = #input ifTrue: [self selectNoInput: self selectedBlock]
]

{ #category : #'vertical movement' }
SBBlockCursor >> previousVertical [

	^ self
		adjacentVerticalCalcDistance: [:candidate | cursorPosition selectionBounds top - candidate bottom]
		validBlock: [:candidate | cursorPosition selectionBounds top >= candidate bottom]
]

{ #category : #'events-processing' }
SBBlockCursor >> rejectsEvent: anEvent [

	^ true
]

{ #category : #api }
SBBlockCursor >> replaceSelected: aBlock [

	cursorPosition replaceSelected: aBlock
]

{ #category : #blinking }
SBBlockCursor >> resetBlink [

	blinkCount := 0.
	cursorShown := true.
	lastBlinkTime := DateAndTime now.
	self editor ifNotNil: [:e |
		e world ifNotNil: [:w |
			w stopStepping: self.
			w
				startStepping: self
				at: Time millisecondClockValue + self stepTime
				selector: #step
				arguments: {}
				stepTime: self stepTime]]
]

{ #category : #drawing }
SBBlockCursor >> resetState [

	selectLargerHistory := OrderedCollection new.
	cursorShown := false.
	blinkCount := 0.
	horizontalOffsetInFloat := 0.
]

{ #category : #api }
SBBlockCursor >> select: aBlock [

	aBlock
		ifNil: [self cursorPosition: SBCursorNone new explicitMove: false axis: #none]
		ifNotNil: [self cursorPosition: (self cursorForBlock: aBlock at: aBlock topLeft) explicitMove: false axis: #none]
]

{ #category : #api }
SBBlockCursor >> selectNoInput: aBlock [

	self cursorPosition: (SBCursorSelect new block: aBlock) explicitMove: false axis: #none
]

{ #category : #accessing }
SBBlockCursor >> selectedBlock [

	^ self cursorPosition block
]

{ #category : #'events-processing' }
SBBlockCursor >> showLabel: aString [

	self removeAllMorphs.
	aString ifNotNil: [
		self addMorphBack: (Morph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addDropShadow;
			cornerStyle: #rounded;
			cornerRadius: 4;
			color: (Color r: 1 g: 1 b: 1);
			layoutInset: 4;
			addMorphBack: (SBStringMorph new
				contents: aString;
				opacity: 0.8))]
]

{ #category : #api }
SBBlockCursor >> startInput: aBlock at: aNumber replacingContents: aBoolean [

	self cursorPosition: (aBlock startInputCommand ifNotNil: [:command | SBCursorText new block: aBlock; cursorIndex: aNumber; currentCommand: aBlock startInputCommand; replacingContents: aBoolean] ifNil: [SBCursorSelect new block: aBlock]) explicitMove: aBoolean axis: #none
]

{ #category : #multiselection }
SBBlockCursor >> startOrAddToMultiSelection: aBlock [

	self cursorPosition: (cursorPosition startOrAddToMultiSelection: aBlock) explicitMove: true axis: #none
]

{ #category : #blinking }
SBBlockCursor >> step [

	| oldVisible now |
	oldVisible := self cursorVisible.
	
	now := DateAndTime current.
	" crude upgrade helper "
	lastBlinkTime class = Time ifTrue: [lastBlinkTime := now].
	
	(lastBlinkTime isNil or: [(lastBlinkTime + 0.5 seconds) < now]) ifTrue: [
		lastBlinkTime := now.
		cursorShown := cursorShown not.
		blinkCount := blinkCount + 1].
	
	cursorPosition valid ifFalse: [^ self cursorPosition: SBCursorNone new explicitMove: false axis: #none].
	
	self updateBounds.
	
	oldVisible ~= self cursorVisible ifTrue: [
		self changed.
		self selectedBlock ifNotNil: #changed]
]

{ #category : #blinking }
SBBlockCursor >> stepTime [

	^ 0
]

{ #category : #api }
SBBlockCursor >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	(anEvent commandKeyPressed not and: [anEvent optionKeyPressed not and: [anEvent controlKeyPressed not]]) ifTrue: [
		cursorPosition unhandledEvent: anEvent in: anEditor didHandle: aBlock]
]

{ #category : #'as yet unclassified' }
SBBlockCursor >> updateBounds [

	| b |
	b := cursorPosition bounds.
	^ self bounds: (cursorPosition block
		ifNotNil: [:block | | referenceMorph |
			block = self sandblockEditor
				ifTrue: [self owner offset extent: self owner extent]
				ifFalse: [
					referenceMorph := block ownerSatisfying: [:o | o owner = self owner].
					referenceMorph ifNil: [b] ifNotNil: [block bounds: b in: referenceMorph]]]
		ifNil: [b])
]

{ #category : #'vertical movement' }
SBBlockCursor >> updateHorizontalOffset [

	Project current addDeferredUIMessage: [
		horizontalOffsetInFloat := cursorPosition horizontalOffsetInFloat.
		
		SBToggledCode comment: 'debug vis of horizontal offset' active: 0 do: {
			[
				Display getCanvas
					fillRectangle: (self selectedBlock containingFloat positionInWorld + (0 @ -10) extent: 10 @ 10)
					color: Color random.
				Display getCanvas
					fillRectangle: (self selectedBlock containingFloat positionInWorld + (horizontalOffsetInFloat @ -10) extent: 10 @ 10)
					color: Color random]}]
]

{ #category : #'halos and balloon help' }
SBBlockCursor >> wantsHaloFromClick [

	^ false
]
