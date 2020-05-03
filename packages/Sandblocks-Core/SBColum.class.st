Class {
	#name : #SBColum,
	#superclass : #Morph,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColum >> addedMorph: aMorph [

	super addedMorph: aMorph.
	self triggerEvent: #morphAdded with: aMorph
]

{ #category : #'as yet unclassified' }
SBColum >> initialize [

	super initialize.
	
	self
		extent: 0 @ 0;
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]
