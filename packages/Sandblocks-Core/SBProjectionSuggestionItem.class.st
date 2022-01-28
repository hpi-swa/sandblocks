Class {
	#name : #SBProjectionSuggestionItem,
	#superclass : #SBSuggestionItem,
	#instVars : [
		'editor'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBProjectionSuggestionItem class >> selector: aSymbol label: aString editor: anEditor [

	^ (super selector: aSymbol label: aString)
		editor: anEditor;
		yourself
]

{ #category : #accessing }
SBProjectionSuggestionItem >> editor [

	^ editor
]

{ #category : #accessing }
SBProjectionSuggestionItem >> editor: anEditor [

	editor := anEditor
]

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

{ #category : #initialization }
SBProjectionSuggestionItem >> instanceSuggestion: aFactoryClosure [

	| instance example |
	self removeAllButFirstSubmorph.
	aFactoryClosure ifNil: [^ self].
	
	example := aFactoryClosure value.
	example extent: example minExtent.
	
	" provides styling information to its children "
	editor newSelectionContainer
		addMorphBack: example;
		yourself.
	
	instance := example imageForm asMorph.
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
