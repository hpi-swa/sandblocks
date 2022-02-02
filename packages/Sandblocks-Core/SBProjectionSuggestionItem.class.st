Class {
	#name : #SBProjectionSuggestionItem,
	#superclass : #SBSuggestionItem,
	#category : #'Sandblocks-Core'
}

{ #category : #initialization }
SBProjectionSuggestionItem >> initialize [

	super initialize.
	self
		addMorphBack: (SBRow new hResizing: #spaceFill);
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellGap: 2
]

{ #category : #initialization }
SBProjectionSuggestionItem >> instanceSuggestion: aFactoryClosure editor: anEditor [

	| instance example |
	aFactoryClosure ifNil: [^ self].
	
	example := aFactoryClosure value.
	example extent: example minExtent.
	
	" provides styling information to its children "
	anEditor newSelectionContainer
		addMorphBack: example;
		yourself.
	
	instance := example imageForm asMorph.
	self addMorphBack: instance.
	instance position: self firstSubmorph bottomLeft
]

{ #category : #accessing }
SBProjectionSuggestionItem >> labelContainer [

	^ self firstSubmorph
]
