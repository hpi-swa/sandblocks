Extension { #name : #Morph }

{ #category : #'*Sandblocks-Core' }
Morph >> allMorphsDoBreadthFirst: aBlock [

	aBlock value: self.
	self submorphsDo: [:m | m allMorphsDoBreadthFirst: aBlock]
]

{ #category : #'*Sandblocks-Core' }
Morph >> centerRight: aPoint [

	self position: ((aPoint x - bounds width) @ (aPoint y - (self height / 2) rounded))
]

{ #category : #'*Sandblocks-Core' }
Morph >> containingSandblock [

	^ self owner ifNotNil: #containingSandblock
]

{ #category : #'*Sandblocks-Core-override' }
Morph >> extent: aPoint [

	(bounds extent closeTo: aPoint) ifTrue: [^ self].
	self changed.
	bounds := (bounds topLeft extent: aPoint) rounded.
	self removeProperty: #dropShadow.
	self layoutChanged.
	self changed.

	self triggerEvent: #extentChanged.
]

{ #category : #'*Sandblocks-Core' }
Morph >> firstMorphThat: aBlock [

	self allMorphsDoBreadthFirst: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil
]

{ #category : #'*Sandblocks-Core' }
Morph >> focusPreviousMorph: anEvent [

	anEvent hand newKeyboardFocus: (self previousMorphThat: [:m | m wantsKeyboardFocus])
]

{ #category : #'*Sandblocks-Core' }
Morph >> fontToUse [

	^ TextStyle defaultFont
]

{ #category : #'*Sandblocks-Core' }
Morph >> isArrayBlock [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> isAssignment [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> isBlockBindings [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> isBlockBody [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> isMethod [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> isStatement [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> isTemporaries [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> lastMorphThat: aBlock [

	self reverseAllMorphsDo: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil
]

{ #category : #'*Sandblocks-Core' }
Morph >> morphAfterThat: aBlock [

	| next |
	next  := self.
	[
	next := next submorphAfter.
	next  ifNil: [^ nil].
	(aBlock value: next) ifTrue: [^ next]] repeat
]

{ #category : #'*Sandblocks-Core' }
Morph >> morphBeforeThat: aBlock [

	| next |
	next  := self.
	[
	next := next submorphBefore.
	next  ifNil: [^ nil].
	(aBlock value: next) ifTrue: [^ next]] repeat
]

{ #category : #'*Sandblocks-Core' }
Morph >> mouseEnterHighlight [

	| indicatorBorderWidth subject |
	indicatorBorderWidth := 4 withScalingFactor.
	subject := self valueOfProperty: #highlightMorphSubject.
	self valueOfProperty: #morphHighlightPopup ifPresentDo: #delete.
	self setProperty: #morphHighlightPopup toValue: (Morph new
		 addMorphBack: (Morph new
			 color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			 borderStyle: (BorderStyle width: indicatorBorderWidth color: Color red);
			 extent: subject extent + (indicatorBorderWidth * 2);
			 yourself);
		 addMorphBack: (Morph new
			 addMorph: (StringMorph new contents: self balloonText);
			 vResizing: #shrinkWrap;
			 hResizing: #shrinkWrap;
			 color: Color white;
			 layoutInset: 4 withScalingFactor;
			 borderStyle: (BorderStyle width: 2 color: Color black));
		 bounds: (subject boundsInWorld outsetBy: indicatorBorderWidth);
		 openInWorld;
		 color: Color transparent;
		 cellPositioning: #topLeft;
		 changeTableLayout;
		 listDirection: #topToBottom;
		yourself)
]

{ #category : #'*Sandblocks-Core' }
Morph >> mouseLeaveHighlight [

	self valueOfProperty: #morphHighlightPopup ifPresentDo: [:popup |
		popup delete.
		self removeProperty: #morphHighlightPopup]
]

{ #category : #'*Sandblocks-Core' }
Morph >> nextAdjacentMorphThat: aBlock [

	| next |
	next  := self.
	[
	next := next submorphAfter.
	next  ifNil: [^ nil].
	(next firstMorphThat: aBlock) ifNotNil: [:m | ^ m]] repeat
]

{ #category : #'*Sandblocks-Core' }
Morph >> onHoverHighlight: aMorph labeled: aString [

	aMorph isMorph ifFalse: [^ self].
	
	self balloonText: aString.
	self setProperty: #highlightMorphSubject toValue: aMorph.
	self on: #mouseEnter send: #mouseEnterHighlight to: self.
	self on: #mouseLeave send: #mouseLeaveHighlight to: self
]

{ #category : #'*Sandblocks-Core' }
Morph >> parentSandblock [

	^ self owner ifNotNil: #containingSandblock
]

{ #category : #'*Sandblocks-Core-override' }
Morph >> position: aPoint [ 
	"Change the position of this morph, which is the top left corner of its bounds."
	
	| delta box |
	delta := (aPoint - self bounds topLeft) rounded.
	
	"Skip drawing and layout updates for null changes."
	(delta x = 0 and: [delta y = 0])
		ifTrue: [^ self].

	"Optimize drawing. Record one damage rectangle for short distance and two damage rectangles for large distances."
	box := self fullBounds.	
	(delta dotProduct: delta) > 100 "More than 10 pixels?"
		ifTrue: [self
					invalidRect: box;
					invalidRect: (box translateBy: delta)]
		ifFalse: [self
					invalidRect: (box merge: (box translateBy: delta))].
	
	"Move this morph and *all* of its submorphs."
	self privateFullMoveBy: delta.
	
	self triggerEvent: #positionChanged.
	
	"For all known layout policies, my layout and the layout of my children is fine. Only the layout of my owner might be affected. So, tell about it."
	self owner ifNotNil: [:o | 
		self flag: #todo. "mt: Maybe we can save a lot of effort and troubles by only calling #layoutChanged if the owner has a layout policy installed? Take the thumbs of scroll-bars as an example..."
		o layoutChanged].
]

{ #category : #'*Sandblocks-Core' }
Morph >> preventOcclusion [

	^ false
]

{ #category : #'*Sandblocks-Core' }
Morph >> previousAdjacentMorphThat: aBlock [

	| next |
	next := self.
	[
	next := next submorphBefore.
	next ifNil: [^ nil].
	(next lastMorphThat: aBlock) ifNotNil: [:m | ^ m]] repeat
]

{ #category : #'*Sandblocks-Core' }
Morph >> previousMorphThat: aBlock [

	^ (self previousAdjacentMorphThat: aBlock) ifNil: [(self owner ifNil: [^ nil]) previousMorphThat: aBlock]
]

{ #category : #'*Sandblocks-Core' }
Morph >> replaceBy: aMorph [

	| currentOwner index |
	currentOwner := self owner.
	index := currentOwner submorphIndexOf: self.
	self delete.
	currentOwner addMorph: aMorph asElementNumber: index.
	^ aMorph
]

{ #category : #'*Sandblocks-Core' }
Morph >> reverseAllMorphsDo: aBlock [

	submorphs reverseDo: [:m | m reverseAllMorphsDo: aBlock].
	aBlock value: self
]

{ #category : #'*Sandblocks-Core' }
Morph >> sandblockEditor [

	^ self owner ifNotNil: #sandblockEditor
]

{ #category : #'*Sandblocks-Core' }
Morph >> sandblockForegroundColor [

	^ self containingSandblock ifNotNil: [:b | b foregroundColor] ifNil: [color]
]

{ #category : #'*Sandblocks-Core' }
Morph >> scalingFactor [

	^ (self fontToUse height / 16) ceiling
]

{ #category : #'*Sandblocks-Core-Simulate' }
Morph >> simulateClick [

	| hand |
	hand := self activeHand.
	hand newMouseFocus: self.
	self click: (MouseButtonEvent new setType: #mouseUp position: self center which: 0 buttons: MouseEvent redButton hand: hand stamp: nil)
]

{ #category : #'*Sandblocks-Core-Simulate' }
Morph >> simulateMouseDown [

	| hand |
	hand := self activeHand.
	hand newMouseFocus: self.
	self mouseDown: (MouseButtonEvent new setType: #mouseDown position: self center which: 0 buttons: MouseEvent redButton hand: hand stamp: nil).
	self world ifNotNil: #doOneCycleNow
]

{ #category : #'*Sandblocks-Core-Simulate' }
Morph >> simulateMouseDownUp [

	self
		simulateMouseDown;
		simulateMouseUp
]

{ #category : #'*Sandblocks-Core-Simulate' }
Morph >> simulateMouseUp [

	| hand |
	hand := self activeHand.
	self mouseUp: (MouseButtonEvent new setType: #mouseUp position: self center which: 0 buttons: MouseEvent redButton hand: hand stamp: nil).
	hand releaseMouseFocus: self.
	self world ifNotNil: #doOneCycleNow
]

{ #category : #'*Sandblocks-Core' }
Morph >> storeOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' basicNew'.
	
	1 to: self class instSize do: [:i |
		" ignore submorphs, owner and fullBounds "
		(i ~= 2 and: [i ~= 3 and: [i ~= 4]]) ifTrue: [
		aStream nextPutAll: ' instVarAt: ';
			store: i;
			nextPutAll: ' put: ';
			store: (self instVarAt: i);
			nextPut: $;]].
	
	aStream nextPutAll: ' instVarAt: 3 put: Array empty; '.
	self submorphsDo: [:morph |
		aStream nextPutAll: 'addMorphBack: '.
		morph storeOn: aStream.
		aStream nextPut: $;].
	
	aStream nextPutAll: ' yourself)'

]

{ #category : #'*Sandblocks-Core' }
Morph >> topCenter: aPoint [

	self position: aPoint x - (self width // 2) @ aPoint y
]

{ #category : #'*Sandblocks-Core' }
Morph >> topFirstMorphThat: aBlock [

	self allMorphsDoBreadthFirst: [:m | (aBlock value: m) ifTrue: [^ m]].
	^ nil
]
