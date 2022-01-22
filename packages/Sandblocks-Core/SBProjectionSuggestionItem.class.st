Class {
	#name : #SBProjectionSuggestionItem,
	#superclass : #SBSuggestionItem,
	#category : #'Sandblocks-Core'
}

{ #category : #geometry }
SBProjectionSuggestionItem >> fontHeight [

	^ self fontToUse height
]

{ #category : #initialization }
SBProjectionSuggestionItem >> initialize [

	super initialize.
	self addMorph: self makeRoomForLabel
]

{ #category : #accessing }
SBProjectionSuggestionItem >> instance [

	^ self roomForLabel submorphAfter
]

{ #category : #accessing }
SBProjectionSuggestionItem >> instanceSuggestion: factory [

	| instance |
	self removeAllButFirstSubmorph.
	factory ifNil: [^ self].
	
	instance := (factory value
		in: [:block |
			block extent: block minExtent.
			
			];
		imageForm) asMorph.
	self addMorphBack: instance.
	instance position: self firstSubmorph bottomLeft
]

{ #category : #initialization }
SBProjectionSuggestionItem >> makeRoomForLabel [

	^ Morph new
		beTransparent;
		position: self layoutBounds origin;
		height: self fontHeight
]

{ #category : #layout }
SBProjectionSuggestionItem >> minExtent [

	self instance ifNil: [^ super minExtent].
	^ super minExtent + self instance height
]

{ #category : #accessing }
SBProjectionSuggestionItem >> roomForLabel [

	^ self firstSubmorph
]
