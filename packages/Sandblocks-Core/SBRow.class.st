Class {
	#name : #SBRow,
	#superclass : #Morph,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRow >> initialize [

	super initialize.
	
	self
		extent: 0 @ 0;
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBRow >> wantsMetaMenu [

	^ false
]
