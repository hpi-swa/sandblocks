Class {
	#name : #SBStringView,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStringView >> initialize [

	super initialize.
	
	self
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		layoutInset: 8;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBMultilineOwnTextMorph new
			hResizing: #spaceFill;
			when: #selectionChanged send: #updateSelectionLabels to: self;
			yourself);
		addMorphBack: (SBRow new
			cellGap: 4;
			addMorphBack: (SBStNumberWithPrefix new prefix: 'Start: ');
			addMorphBack: (SBStNumberWithPrefix new prefix: 'Stop: ');
			addMorphBack: (SBStNumberWithPrefix new prefix: 'Length: '));
		updateSelectionLabels;
		attachDecorator: SBForceMoveDecorator newConfigured.
	
	self firstSubmorph cursor: 1
]

{ #category : #'as yet unclassified' }
SBStringView >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringView >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBStringView >> object [

	^ self textContents
]

{ #category : #'as yet unclassified' }
SBStringView >> replace: anObject [

	self string: anObject
]

{ #category : #'as yet unclassified' }
SBStringView >> string: aString [

	self firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBStringView >> textContents [

	^ self firstSubmorph hasSelection ifTrue: [self firstSubmorph selection] ifFalse: [self firstSubmorph contents]
]

{ #category : #'as yet unclassified' }
SBStringView >> updateSelectionLabels [

	| row range |
	row := self submorphs second.
	range := self firstSubmorph selectionBounds.
	row submorphs first contents: range first asString.
	row submorphs second contents: range second asString.
	row submorphs third contents: (self firstSubmorph hasSelection ifTrue: [range second - range first] ifFalse: [self firstSubmorph contents size]) asString
]
