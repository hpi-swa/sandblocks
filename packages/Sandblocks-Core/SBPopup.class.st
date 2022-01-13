Class {
	#name : #SBPopup,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPopup >> initialize [

	super initialize.
	self
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		color: (Color r: 1 g: 1 b: 1);
		layoutInset: 4;
		disableLayout: true;
		addDropShadow
]

{ #category : #'as yet unclassified' }
SBPopup >> morphicLayerNumber [

	^ 99
]

{ #category : #'as yet unclassified' }
SBPopup >> preventOcclusion [

	^ false
]

{ #category : #'as yet unclassified' }
SBPopup >> showBelow: aBlock [

	self assert: aBlock sandblockEditor notNil.
	aBlock ensureLayouted.
	self position: aBlock bottomLeft.
	aBlock sandblockEditor openMorph: self
]
