Class {
	#name : #SBSuggestionMenu,
	#superclass : #Morph,
	#instVars : [
		'activeIndex',
		'editor'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> activeSelector [

	^ self activeSuggestion ifNotNil: #selector
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> activeSuggestion [

	^ self hasSubmorphs ifFalse: [nil] ifTrue: [self submorphs at: activeIndex]
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> editor: anEditor [

	editor := anEditor
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> handleMouseEnter: anEvent [
	
	self activeHand newKeyboardFocus: editor.
	anEvent wasHandled: true
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> initialize [

	super initialize.
	
	activeIndex := 1.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 0;
		layoutInset: 0;
		color: Color white
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> minExtent [
	"Layout specific. Return the minimum size the receiver can be represented in.
	Implementation note: When this message is sent from an owner trying to lay out its children it will traverse down the morph tree and recompute the minimal arrangement of the morphs based on which the minimal extent is returned. When a morph with some layout strategy is encountered, the morph will ask its strategy to compute the new arrangement. However, since the final size given to the receiver is unknown at the point of the query, the assumption is made that the current bounds of the receiver are the base on which the layout should be computed. This scheme prevents strange layout changes when for instance, a table is contained in another table. Unless the inner table has been resized manually (which means its bounds are already enlarged) the arrangement of the inner table will not change here. Thus the entire layout computation is basically an iterative process which may have different results depending on the incremental changes applied."

	| layout minExtent extra hFit vFit |
	hFit := self hResizing.
	vFit := self vResizing.

	"An exception -- a receiver with #shrinkWrap constraints but no children is being treated #rigid (the equivalent to a #spaceFill receiver in a non-layouting owner)"
	self hasSubmorphs 
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

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> moveActive: aNumber [

	self hasSubmorphs ifFalse: [^ self].
	
	(self submorphs at: activeIndex) active: false.
	activeIndex := activeIndex + aNumber clampLow: 1 high: self submorphCount.
	(self submorphs at: activeIndex) active: true
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> next [

	self moveActive: 1
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> previous [

	self moveActive: -1
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> resize [

	self extent: (self hasSubmorphs ifFalse: [0 @ 0] ifTrue: [self minExtent])
]

{ #category : #'as yet unclassified' }
SBSuggestionMenu >> suggestions: aCollectionOfSymbol [

	self removeAllMorphs.
	
	aCollectionOfSymbol do: [:item |
		self addMorphBack: item].
	
	self hasSubmorphs ifTrue: [
		activeIndex := activeIndex min: self submorphCount.
		(self submorphs at: activeIndex) active: true]
]
