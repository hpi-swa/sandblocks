Class {
	#name : #SBMailPrototype,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMailPrototype >> contextAcceptedRepresentationAt: aNumber [

	^ #isMIMEDocument
]

{ #category : #'as yet unclassified' }
SBMailPrototype >> initialize [

	super initialize.
	self
		changeTableLayout;
		hResizing: #rigid;
		vResizing: #rigid;
		extent: 50 @ 50;
		layoutInset: 8
]
