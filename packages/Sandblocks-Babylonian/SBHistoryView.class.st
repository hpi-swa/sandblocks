Class {
	#name : #SBHistoryView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBHistoryView >> addEpoche [

	self submorphs size - 1 "buttonRow" > self maxEpoches ifTrue: [self lastSubmorph delete]. 
	
	self block addMorph: self buildEpoche atIndex: 2
]

{ #category : #building }
SBHistoryView >> buildEpoche [

	| row |
	row := self containerRow.
	^ row
		cellGap: 0@10; 
		listDirection: #topToBottom;
		addMorphBack: (self containerRow
							cellGap: 5@0;
							addMorphBack: (self deleteEpocheButton: row); 
							addMorphBack: TimeStamp current asMorph);
		addMorphBack: (self containerRow
							layoutInset: 0;
							cellGap: 0;
							cellInset: 0; 
							addAllMorphsBack:  self collectSnapshots)
	
	
]

{ #category : #building }
SBHistoryView >> buttons [

	^ super buttons, {self clearButton}
]

{ #category : #building }
SBHistoryView >> clearButton [

	^ SBButton new
		icon: SBIcon iconClockO
			label: 'Clear History'
			do: [self clean. self block addMorphBack: self buildButtonRow];
		cornerStyle: #squared
]

{ #category : #building }
SBHistoryView >> collectSnapshots [

	^ (SBExploriants uniqueInstance namedBlocks collect: [:aView | aView snapshot]) flatten
]

{ #category : #building }
SBHistoryView >> deleteEpocheButton: theRow [

	^ SBButton new
		icon: SBIcon iconTrash
			do: [theRow delete];
		balloonText: 'Delete this row';
		cornerStyle: #squared;
		makeSmall
	
	
]

{ #category : #initialization }
SBHistoryView >> initialize [ 

	super initialize.
	
	self name: 'History'.
	self buildButtonRow.
]

{ #category : #accessing }
SBHistoryView >> maxEpoches [

	^ 100
]

{ #category : #copying }
SBHistoryView >> snapshot [ 

	^ {}
]

{ #category : #actions }
SBHistoryView >> visualize [ 

	self addEpoche
]
