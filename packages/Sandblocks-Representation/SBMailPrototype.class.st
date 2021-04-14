Class {
	#name : #SBMailPrototype,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Representation'
}

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

{ #category : #'as yet unclassified' }
SBMailPrototype >> objectInterfaceNear: aBlock at: aSymbol [

	^ #(#isMIMEDocument)
]
