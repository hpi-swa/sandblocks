Class {
	#name : #SBDivider,
	#superclass : #Morph,
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBDivider >> fillStyle [

	| base |
	base := self containingSandblock
		ifNotNil: #foregroundColor
		ifNil: [Color r: 0.0 g: 0.0 b: 0.0].
	^ base alpha: 0.3
]

{ #category : #'as yet unclassified' }
SBDivider >> initialize [

	super initialize.
	
	self
		extent: 1 @ 1;
		hResizing: #spaceFill;
		vResizing: #rigid
]
