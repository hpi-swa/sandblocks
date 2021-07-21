Class {
	#name : #SBBlockCursor,
	#superclass : #Morph,
	#instVars : [
		'cursorShown',
		'blinkCount',
		'editor',
		'cursorPosition',
		'selectLargerHistory',
		'horizontalOffsetInFloat'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'vertical movement' }
SBBlockCursor >> adjacentVerticalCalcDistance: aDistBlock validBlock: aValidBlock [

	| allCandidates candidates candidatesBestDistance tolerance float |
	float := self selectedBlock containingFloat.
	tolerance := 10.
	allCandidates := Array streamContents: [:stream | float allMorphsDo: [:candidate | ((candidate isTextMorph or: [candidate isSandblock and: [candidate hasChildSandblocks not]]) and: [aValidBlock value: candidate]) ifTrue: [stream nextPut: candidate]]].
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

{ #category : #testing }
SBBlockCursor >> cursorAlwaysVisible [

	^ self editor hasKeyboardFocus not or: [blinkCount >= self maxBlickCount]
]

{ #category : #private }
SBBlockCursor >> cursorForBlock: aBlock at: aPoint [

	^ aBlock currentTextMorph
		ifNotNil: [SBCursorText new block: aBlock; pixelPosition: aPoint]
		ifNil: [SBCursorSelect new block: aBlock]
]

{ #category : #accessing }
SBBlockCursor >> cursorPosition [

	^ cursorPosition
]

{ #category : #private }
SBBlockCursor >> cursorPosition: aPosition explicitMove: aBoolean axis: aSymbol [

	aPosition = cursorPosition ifFalse: [
		cursorPosition ifNotNil: #leave.
		cursorPosition := aPosition.
		cursorPosition ifNotNil: [:position | position enter].
		self resetBlink].
	
	blinkCount := 0.
	cursorPosition ifNotNil: [:position | self bounds: position bounds].
	aSymbol ~= #z ifTrue: [selectLargerHistory removeAll].
	((#(#z #y) includes: aSymbol) not and: [aBoolean]) ifTrue: [self updateHorizontalOffset]
]

{ #category : #testing }
SBBlockCursor >> cursorVisible [

	^ cursorShown or: [self cursorAlwaysVisible]
]

{ #category : #drawing }
SBBlockCursor >> drawOn: aCanvas [

	self cursorVisible ifTrue: [self cursorPosition drawOn: aCanvas]
]

{ #category : #accessing }
SBBlockCursor >> editor [

	^ editor
]

{ #category : #accessing }
SBBlockCursor >> editor: anEditor [

	editor := anEditor
]

{ #category : #'vertical movement' }
SBBlockCursor >> idealPixelPositionEnterNear: aSymbol for: aBlock [

	aBlock currentTextMorph ifNil: [^ aBlock center].
	
	^ horizontalOffsetInFloat + (aBlock containingFloat ifNotNil: [:a | a left] ifNil: [0]) @ ((aBlock currentTextMorph perform: aSymbol) + (aSymbol = #top ifTrue: [4] ifFalse: [-4]))
]

{ #category : #initialization }
SBBlockCursor >> initialize [

	super initialize.
	
	selectLargerHistory := OrderedCollection new.
	cursorShown := false.
	blinkCount := 0.
	horizontalOffsetInFloat := 0.
	self disableLayout: true.
	cursorPosition := SBCursorNone new
]

{ #category : #actions }
SBBlockCursor >> lookupGlobalAction: aSymbol [

	^ (self class lookupSelector: aSymbol) ifNotNil: [:m | (m pragmaAt: #globalAction) ifNotNil: [m]]
]

{ #category : #blinking }
SBBlockCursor >> maxBlickCount [

	^ 20
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

	self nextVertical ifNotNil: [:next |
		self
			cursorPosition: (self cursorForBlock: next at: (self idealPixelPositionEnterNear: #top for: next))
			explicitMove: true
			axis: #y]
]

{ #category : #api }
SBBlockCursor >> moveCursorLarger [
	<globalAction>

	selectLargerHistory addLast: self cursorPosition.
	self cursorPosition: self cursorPosition selectLarger explicitMove: true axis: #z
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

	self previousVertical ifNotNil: [:previous |
		self
			cursorPosition: (self cursorForBlock: previous at: (self idealPixelPositionEnterNear: #bottom for: previous))
			explicitMove: true
			axis: #y]
]

{ #category : #private }
SBBlockCursor >> moveHorizontal: aNumber [

	self moveHorizontal: aNumber wordWise: false
]

{ #category : #private }
SBBlockCursor >> moveHorizontal: aNumber wordWise: aBoolean [

	| newPos |
	newPos := self cursorPosition.
	[newPos := newPos moveHorizontal: aNumber wordWise: aBoolean] doWhileTrue: [aBoolean and: [newPos class ~= SBCursorText]].
	
	newPos ~= self cursorPosition ifTrue: [newPos placeAtEnd: (aBoolean ifTrue: [aNumber > 0] ifFalse: [aNumber < 0])].
	
	self cursorPosition: newPos explicitMove: true axis: #x
]

{ #category : #'vertical movement' }
SBBlockCursor >> nextVertical [

	^ self
		adjacentVerticalCalcDistance: [:candidate | candidate top - self selectedBlock bottom]
		validBlock: [:candidate | candidate top >= self selectedBlock bottom]
]

{ #category : #'vertical movement' }
SBBlockCursor >> previousVertical [

	^ self
		adjacentVerticalCalcDistance: [:candidate | self selectedBlock top - candidate bottom]
		validBlock: [:candidate | self selectedBlock top >= candidate bottom]
]

{ #category : #'events-processing' }
SBBlockCursor >> rejectsEvent: anEvent [

	^ true
]

{ #category : #blinking }
SBBlockCursor >> resetBlink [

	blinkCount := 0.
	cursorShown := false.
	self editor ifNotNil: [:e |
		e world ifNotNil: [:w |
			w stopStepping: self.
			w startStepping: self at: Time millisecondClockValue selector: #step arguments: {} stepTime: self stepTime]]
]

{ #category : #api }
SBBlockCursor >> select: aBlock [

	aBlock
		ifNil: [self cursorPosition: SBCursorNone new explicitMove: false axis: #none]
		ifNotNil: [self cursorPosition: (self cursorForBlock: aBlock at: aBlock topLeft) explicitMove: false axis: #none]
]

{ #category : #accessing }
SBBlockCursor >> selectedBlock [

	^ self cursorPosition block
]

{ #category : #blinking }
SBBlockCursor >> step [

	cursorShown := cursorShown not.
	blinkCount := blinkCount + 1.
	self changed
]

{ #category : #blinking }
SBBlockCursor >> stepTime [

	^ 500
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
