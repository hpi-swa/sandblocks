Class {
	#name : #SBRow,
	#superclass : #Morph,
	#instVars : [
		'softWrap'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBRow >> initialize [

	super initialize.
	
	softWrap := true.
	
	self
		extent: 0 @ 0;
		color: Color transparent;
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight;
		cellPositioning: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBRow >> layoutCommands [

	^ self layoutPolicy class = SBAlgebraLayout
		ifTrue: [
			SBAlgebraCommand container
				morph: self;
				data: ((self submorphs select: #visible) collect: #layoutCommands separatedBy: [self softWrap ifTrue: [SBAlgebraCommand softLineOrGap] ifFalse: [SBAlgebraCommand gap]])]
		ifFalse: [super layoutCommands]
]

{ #category : #'as yet unclassified' }
SBRow >> removedMorph: aMorph [

	super removedMorph: aMorph.
	
	aMorph removeActionsWithReceiver: self
]

{ #category : #'as yet unclassified' }
SBRow >> softWrap [

	^ softWrap ifNil: [true]
]

{ #category : #'as yet unclassified' }
SBRow >> softWrap: aBoolean [
	" if using layout commands softwrap indicates whether items are allowed to wrap "

	softWrap := aBoolean
]

{ #category : #'as yet unclassified' }
SBRow >> useAlgebraLayout [

	self layoutPolicy: SBAlgebraLayout new
]

{ #category : #'as yet unclassified' }
SBRow >> wantsMetaMenu [

	^ false
]
