Class {
	#name : #SBSuggestionItem,
	#superclass : #Morph,
	#instVars : [
		'selector',
		'active',
		'label',
		'completionAction'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSuggestionItem class >> selector: aSymbol label: aString [

	^ self new
		selector: aSymbol;
		label: aString;
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

{ #category : #private }
SBSuggestionItem >> activeColor [

	^ Color blue
]

{ #category : #accessing }
SBSuggestionItem >> completionAction [

	^ completionAction
]

{ #category : #accessing }
SBSuggestionItem >> completionAction: aBlock [

	completionAction := aBlock
]

{ #category : #drawing }
SBSuggestionItem >> drawOn: aCanvas [

	| font foreground |
	active ifTrue: [aCanvas fillRectangle: self bounds color: self activeColor].
	
	font := self fontToUse.
	foreground := active ifTrue: [Color white] ifFalse: [Color black].
	
	aCanvas
		drawString: selector
		at: self layoutBounds origin
		font: font
		color: foreground.
	
	aCanvas
		drawString: label
		at: self layoutBounds topRight - ((font widthOfString: label) @ 0)
		font: font
		color: (foreground alpha: 0.5)
]

{ #category : #'event handling' }
SBSuggestionItem >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #'event handling' }
SBSuggestionItem >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #initialization }
SBSuggestionItem >> initialize [

	super initialize.
	
	active := false.
	label := ''.
	
	self
		layoutInset: 10 @ 4 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		extent: 0 @ 0;
		cellGap: 4 * self scalingFactor
]

{ #category : #accessing }
SBSuggestionItem >> label [

	^ label
]

{ #category : #accessing }
SBSuggestionItem >> label: aString [

	label := aString
]

{ #category : #accessing }
SBSuggestionItem >> menu [

	^ self ownerThatIsA: SBSuggestionMenu
]

{ #category : #layout }
SBSuggestionItem >> minExtent [

	| font |
	font := self fontToUse.
	^ (font widthOfString: selector) @ font height + (self layoutInset * 2) + (self cellGap @ 0) + ((font widthOfString: label) @ 0)
]

{ #category : #'event handling' }
SBSuggestionItem >> mouseDown: anEvent [

	self menu activeItem: self; accept.
]

{ #category : #'event handling' }
SBSuggestionItem >> mouseEnter: anEvent [

	self menu activeItem: self.
]

{ #category : #accessing }
SBSuggestionItem >> selector [

	^ selector
]

{ #category : #accessing }
SBSuggestionItem >> selector: aSymbol [

	selector := aSymbol.
	self extent: self minExtent
]

{ #category : #private }
SBSuggestionItem >> selectorPercentage [

	^ 0.8
]

{ #category : #private }
SBSuggestionItem >> useSuggestionOn: aBlock [

	self completionAction ifNotNil: [self completionAction value: aBlock] ifNil: [aBlock useSuggestion: self selector]
]

{ #category : #private }
SBSuggestionItem >> wouldChange: aBlock [
	" indicate whether activating this item would cause any change in the current block"

	^ self completionAction notNil or: [self selector ~= aBlock contents]
]
