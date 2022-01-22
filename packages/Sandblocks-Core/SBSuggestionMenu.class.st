Class {
	#name : #SBSuggestionMenu,
	#superclass : #ScrollPane,
	#instVars : [
		'activeIndex',
		'editor',
		'container',
		'reference',
		'updateQueued'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #selecting }
SBSuggestionMenu >> accept [

	editor selection useSuggestion.
]

{ #category : #accessing }
SBSuggestionMenu >> activeIndex [

	^ activeIndex
]

{ #category : #accessing }
SBSuggestionMenu >> activeItem [

	^ self hasItems ifFalse: [nil] ifTrue: [self items at: activeIndex]
]

{ #category : #accessing }
SBSuggestionMenu >> activeItem: anItem [

	anItem = self activeItem ifTrue: [^ self].
	
	(self items at: activeIndex) active: false.
	activeIndex := self items indexOf: anItem.
	anItem active: true
]

{ #category : #accessing }
SBSuggestionMenu >> activeSelector [

	^ self activeItem ifNotNil: #selector
]

{ #category : #accessing }
SBSuggestionMenu >> addItem: anItem [

	container addMorphBack: anItem.
]

{ #category : #accessing }
SBSuggestionMenu >> editor: anEditor [

	editor := anEditor.
	
	anEditor when: #keyboardFocusChanged send: #editorFocused: to: self
]

{ #category : #'events-processing' }
SBSuggestionMenu >> editorFocused: aBoolean [

	aBoolean ifFalse: [self delete]
]

{ #category : #'events-processing' }
SBSuggestionMenu >> handleMouseEnter: anEvent [
	
	self activeHand newKeyboardFocus: editor.
	anEvent wasHandled: true
]

{ #category : #'accessing - items' }
SBSuggestionMenu >> hasItems [

	^ self items notEmpty
]

{ #category : #initialization }
SBSuggestionMenu >> initialize [

	super initialize.
	
	activeIndex := 1.
	
	self
		hResizing: #shrinkWrap;
		disableLayout: true.
	self scroller
		changeTableLayout;
		color: (Color r: 1 g: 1 b: 1).
	
	container := Morph new
		beTransparent;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellGap: 0;
		layoutInset: 0;
		yourself.
	self scroller addMorph: container
]

{ #category : #'accessing - items' }
SBSuggestionMenu >> itemCount [

	^ self items size
]

{ #category : #'accessing - items' }
SBSuggestionMenu >> items [

	^ container submorphs
]

{ #category : #layout }
SBSuggestionMenu >> minExtent [
	"Layout specific. Return the minimum size the receiver can be represented in.
	Implementation note: When this message is sent from an owner trying to lay out its children it will traverse down the morph tree and recompute the minimal arrangement of the morphs based on which the minimal extent is returned. When a morph with some layout strategy is encountered, the morph will ask its strategy to compute the new arrangement. However, since the final size given to the receiver is unknown at the point of the query, the assumption is made that the current bounds of the receiver are the base on which the layout should be computed. This scheme prevents strange layout changes when for instance, a table is contained in another table. Unless the inner table has been resized manually (which means its bounds are already enlarged) the arrangement of the inner table will not change here. Thus the entire layout computation is basically an iterative process which may have different results depending on the incremental changes applied."

	| layout minExtent extra hFit vFit |
	hFit := self hResizing.
	vFit := self vResizing.

	"An exception -- a receiver with #shrinkWrap constraints but no children is being treated #rigid (the equivalent to a #spaceFill receiver in a non-layouting owner)"
	self hasItems
		ifFalse: 
			[hFit == #shrinkWrap ifTrue: [hFit := #rigid].
			vFit == #shrinkWrap ifTrue: [vFit := #rigid]].
	layout := self layoutPolicy.
	layout isNil 
		ifTrue: [minExtent := 0@0]
		ifFalse: [minExtent := layout minExtentOf: self in: self layoutBounds].

	hFit == #rigid 
		ifTrue: [minExtent := self fullBounds extent x @ minExtent y]
		ifFalse: 
			[extra := self bounds width - self layoutBounds width.
			minExtent := (minExtent x + extra) @ minExtent y].
	vFit == #rigid 
		ifTrue: [minExtent := minExtent x @ self fullBounds extent y]
		ifFalse: 
			[extra := self bounds height - self layoutBounds height.
			minExtent := minExtent x @ (minExtent y + extra)].

	^ minExtent max: self minWidth @ self minHeight
]

{ #category : #layout }
SBSuggestionMenu >> morphicLayerNumber [

	^ 1
]

{ #category : #selecting }
SBSuggestionMenu >> moveActive: aNumber [

	self hasItems ifFalse: [^ self].
	
	(self items at: activeIndex) active: false.
	activeIndex := activeIndex + aNumber clampLow: 1 high: self itemCount.
	(self items at: activeIndex) active: true
]

{ #category : #selecting }
SBSuggestionMenu >> next [

	self moveActive: 1
]

{ #category : #layout }
SBSuggestionMenu >> openNear: aBlock [

	aBlock isInWorld ifTrue: [
		self
			editor: aBlock sandblockEditor;
			reference: aBlock;
			openInWorld: aBlock world;
			repositionSuggestionsMenu]
]

{ #category : #'submorphs - callbacks' }
SBSuggestionMenu >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	activeIndex := 1.
	self scrollToTop
]

{ #category : #selecting }
SBSuggestionMenu >> previous [

	self moveActive: -1
]

{ #category : #accessing }
SBSuggestionMenu >> reference [

	^ reference
]

{ #category : #accessing }
SBSuggestionMenu >> reference: aBlock [

	reference := aBlock
]

{ #category : #layout }
SBSuggestionMenu >> repositionSuggestionsMenu [

	reference ifNotNil: [self topLeft: reference positionInWorld + (0 @ reference height)].
	self resize
]

{ #category : #layout }
SBSuggestionMenu >> resize [

	self extent: (self hasItems ifFalse: [0 @ 0] ifTrue: [0 @ ((container height min: 330) + 2)])
]

{ #category : #'stepping and presenter' }
SBSuggestionMenu >> step [

	self repositionSuggestionsMenu
]

{ #category : #'stepping and presenter' }
SBSuggestionMenu >> stepTime [

	^ 0
]

{ #category : #accessing }
SBSuggestionMenu >> suggestions: aCollectionOfSymbols [

	self updateQueued: false.
	
	container removeAllMorphs.
	container extent: 0 @ 0.
	
	aCollectionOfSymbols do: [:item | self addItem: item].
	
	self hasItems ifTrue: [
		activeIndex := activeIndex min: self itemCount.
		(self items at: activeIndex) active: true]
]

{ #category : #accessing }
SBSuggestionMenu >> updateQueued [

	^ updateQueued
]

{ #category : #accessing }
SBSuggestionMenu >> updateQueued: aBoolean [

	updateQueued := aBoolean
]
