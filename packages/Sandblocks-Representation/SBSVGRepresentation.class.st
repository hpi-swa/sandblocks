Class {
	#name : #SBSVGRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBSVGRepresentation class >> isMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBSVGRepresentation class >> matches: anObject [

	^ (anObject isKindOf: XMLDocument) and: [(anObject root attributeAt: 'xmlns') = 'http://www.w3.org/2000/svg']
]

{ #category : #'as yet unclassified' }
SBSVGRepresentation class >> newFor: anObject [

	^ SBTransparentSvgMorph new
		createFromSVGDocument: anObject;
		color: Color transparent;
		yourself
]
