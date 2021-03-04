Class {
	#name : #SBHelpShortcut,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHelpShortcut class >> label: aString shortcut: aShortcut [

	^ self new label: aString shortcut: aShortcut
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> above: aBlock [

	self position: aBlock positionInWorld - (0 @ self fullBounds height)
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> below: aBlock [

	self position: aBlock positionInWorld + (0 @ aBlock height)
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> drawnColor [

	^ self color
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> left: aBlock [

	self position: aBlock positionInWorld - (self fullBounds width @ 0)
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> rejectsEvent: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> right: aBlock [

	self position: aBlock positionInWorld + (aBlock width @ 0)
]

{ #category : #'as yet unclassified' }
SBHelpShortcut >> shortcuts: aCollection [

	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		color: Color white;
		borderStyle: (BorderStyle color: Color black width: 1 withScalingFactor).
	aCollection do: [:shortcutDescriptor |
		self addMorphBack: (SBRow new
			cellGap: 4 withScalingFactor;
			addMorphBack: (SBStringMorph new
				contents: shortcutDescriptor first displayString;
				bold;
				yourself);
			addMorphBack: (SBStringMorph new contents: shortcutDescriptor second))]
]
