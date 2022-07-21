Class {
	#name : #SBSuggestionItem,
	#superclass : #Morph,
	#instVars : [
		'selector',
		'active',
		'label',
		'completionAction',
		'preview'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'instance creation' }
SBSuggestionItem class >> selector: aSymbol label: aString [

	^ self new
		selector: aSymbol label: aString;
		yourself
]

{ #category : #accessing }
SBSuggestionItem >> active [

	^ active
]

{ #category : #accessing }
SBSuggestionItem >> active: aBoolean [

	active := aBoolean.
	self changed
]

{ #category : #drawing }
SBSuggestionItem >> activeColor [

	^ Color blue
]

{ #category : #drawing }
SBSuggestionItem >> color [

	^ self active ifTrue: [self activeColor] ifFalse: [Color r: 1 g: 1 b: 1]
]

{ #category : #accessing }
SBSuggestionItem >> completionAction [

	^ completionAction
]

{ #category : #accessing }
SBSuggestionItem >> completionAction: aBlock [

	completionAction := aBlock
]

{ #category : #accessing }
SBSuggestionItem >> contents [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> drawOn: aCanvas [

	aCanvas fillRectangle: self bounds color: self color
]

{ #category : #drawing }
SBSuggestionItem >> foregroundColor [

	^ self active ifTrue: [Color r: 1 g: 1 b: 1] ifFalse: [Color r: 0.0 g: 0.0 b: 0.0]
]

{ #category : #'event handling' }
SBSuggestionItem >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #'event handling' }
SBSuggestionItem >> handlesMouseMove: anEvent [

	^ true
]

{ #category : #initialization }
SBSuggestionItem >> initialize [

	super initialize.
	
	active := false.
	label := ''.
	
	self
		layoutInset: 10 @ 4 * self scalingFactor;
		cellPositioning: #topLeft;
		addMorphBack: (SBRow new
			hResizing: #spaceFill;
			cellGap: 8 * self scalingFactor);
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		changeTableLayout;
		listDirection: #topToBottom;
		extent: 0 @ 0;
		cellGap: 2
]

{ #category : #accessing }
SBSuggestionItem >> label [

	^ label
]

{ #category : #accessing }
SBSuggestionItem >> labelContainer [
	"overwrite in your subclass if you want selector/label to be added to a different morph"

	^ self hasSubmorphs ifTrue: [self firstSubmorph] ifFalse: [self]
]

{ #category : #accessing }
SBSuggestionItem >> menu [

	^ self ownerThatIsA: SBSuggestionMenu
]

{ #category : #'event handling' }
SBSuggestionItem >> mouseDown: anEvent [

	self menu
		activeItem: self;
		useSuggestion
]

{ #category : #'event handling' }
SBSuggestionItem >> mouseMove: anEvent [

	self menu activeItem: self
]

{ #category : #accessing }
SBSuggestionItem >> ownerWithColor [

	^ self
]

{ #category : #accessing }
SBSuggestionItem >> preview [

	^ preview
]

{ #category : #accessing }
SBSuggestionItem >> preview: aForm previewOnly: aBoolean [

	self addMorphBack: (preview := aForm asMorph).
	aBoolean ifTrue: [self firstSubmorph delete]
]

{ #category : #printing }
SBSuggestionItem >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream nextPutAll: self selector.
	aStream nextPut: $)
]

{ #category : #'string suggestion protocol' }
SBSuggestionItem >> sandblockBeginsWith: aString [

	^ selector sandblockBeginsWith: aString
]

{ #category : #'string suggestion protocol' }
SBSuggestionItem >> sandblockMatch: aString [

	^ selector sandblockMatch: aString
]

{ #category : #accessing }
SBSuggestionItem >> selector [

	^ selector
]

{ #category : #accessing }
SBSuggestionItem >> selector: aString label: anotherString [

	| container |
	container := self firstSubmorph.
	selector := aString.
	label := anotherString.
	container addMorphBack: (SBStringMorph new
		contents: aString;
		hResizing: #spaceFill).
	container addMorphBack: (SBStringMorph new
		contents: anotherString;
		opacity: 0.5)
]

{ #category : #accessing }
SBSuggestionItem >> selectorSize [

	^ self selector size
]

{ #category : #'string suggestion protocol' }
SBSuggestionItem >> size [

	^ self selector size
]

{ #category : #suggestions }
SBSuggestionItem >> useSuggestionOn: aBlock in: anEditor [

	self completionAction
		ifNotNil: [self completionAction cull: aBlock cull: self]
		ifNil: [
			aBlock useSuggestion: self.
			anEditor selection ifNotNil: #startInputAtEnd]
]

{ #category : #suggestions }
SBSuggestionItem >> wouldChange: aBlock [
	" indicate whether activating this item would cause any change in the current block"

	^ self completionAction notNil or: [self selector ~= aBlock contents]
]
