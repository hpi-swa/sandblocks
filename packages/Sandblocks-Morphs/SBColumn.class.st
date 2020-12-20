Class {
	#name : #SBColumn,
	#superclass : #Morph,
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBColumn >> addedMorph: aMorph [

	super addedMorph: aMorph.
	self triggerEvent: #morphAdded with: aMorph
]

{ #category : #'as yet unclassified' }
SBColumn >> initialize [

	super initialize.
	
	self
		extent: 0 @ 0;
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBColumn >> wantsMetaMenu [

	^ false
]
