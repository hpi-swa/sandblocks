Class {
	#name : #SBRow,
	#superclass : #Morph,
	#category : #'Sandblocks-Morphs'
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
SBRow >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: ((self submorphs select: #visible) collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap])
]

{ #category : #'as yet unclassified' }
SBRow >> removedMorph: aMorph [

	super removedMorph: aMorph.
	
	aMorph removeActionsWithReceiver: self
]

{ #category : #'as yet unclassified' }
SBRow >> wantsMetaMenu [

	^ false
]
