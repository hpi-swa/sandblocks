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
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBColumn >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (Array streamContents: [:stream | | first |
			first := true.
			self visibleSubmorphsDo: [:s |
				stream nextPut: s layoutCommands.
				first
					ifTrue: [stream nextPut: (SBAlgebraCommand hardLine withGap: self cellGap > 0)]
					ifFalse: [first := false]]])
]

{ #category : #'as yet unclassified' }
SBColumn >> useAlgebraLayout [

	self layoutPolicy: SBAlgebraLayout new
]

{ #category : #'as yet unclassified' }
SBColumn >> wantsMetaMenu [

	^ false
]
