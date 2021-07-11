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

{ #category : #'as yet unclassified' }
SBSuggestionItem >> active [

	^ active
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> active: aBoolean [

	active := aBoolean.
	self changed
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> activeColor [

	^ Color blue
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> completionAction [

	^ completionAction
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> completionAction: aBlock [

	completionAction := aBlock
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBSuggestionItem >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBSuggestionItem >> label [

	^ label
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> label: aString [

	label := aString
]

{ #category : #accessing }
SBSuggestionItem >> menu [

	^ self ownerThatIsA: SBSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> minExtent [

	| font |
	font := self fontToUse.
	^ (font widthOfString: selector) @ font height + (self layoutInset * 2) + (self cellGap @ 0) + ((font widthOfString: label) @ 0)
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> mouseDown: anEvent [

	self menu activeItem: self; accept.
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> mouseEnter: anEvent [

	self menu activeItem: self.
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> selector [

	^ selector
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> selector: aSymbol [

	selector := aSymbol.
	self extent: self minExtent
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> selectorPercentage [

	^ 0.8
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> useSuggestionOn: aBlock [

	self completionAction ifNotNil: [self completionAction value: aBlock] ifNil: [aBlock useSuggestion: self selector]
]

{ #category : #'as yet unclassified' }
SBSuggestionItem >> wouldChange: aBlock [
	" indicate whether activating this item would cause any change in the current block"

	^ self completionAction notNil or: [self selector ~= aBlock contents]
]
