Class {
	#name : #SBTrace,
	#superclass : #Morph,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBTrace class >> newForExample: anExample watches: aCollectionOfWatches [

	^ self new visualizeFor: anExample withWatches: aCollectionOfWatches
		 
]

{ #category : #visualization }
SBTrace >> addSectionFor: aWatchValue [

	self addMorphBack: (
		self placeHolderMorph
			addMorphBack: (TextMorph new contents: (aWatchValue expressionString asText
									addAttribute: (TextColor color: Color gray);
									yourself));
			addMorphBack: aWatchValue asValueMorph;
			yourself)

]

{ #category : #initialization }
SBTrace >> initialize [

	super initialize.
	
	self changeTableLayout;
		color: Color white;
		listDirection: #topToBottom;
		cellPositioning: #topRight;
		layoutInset: 0@3;
		cellInset: 0@2;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #visualization }
SBTrace >> placeHolderMorph [

	^ Morph new 
		changeTableLayout;
		color: Color white;
		layoutInset: 3@0;
		cellInset: 2@0;
		listDirection: #leftToRight;
		cellPositioning: #bottomRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #visualization }
SBTrace >> sortedWatchValuesFor: anExample givenWatches: aCollectionOfWatches [

	| allValues |
	allValues := SortedCollection sortBlock: [:a :b | a tracePosition <= b tracePosition].
	aCollectionOfWatches do: [:aWatch | 
		aWatch exampleToDisplay at: anExample 
			ifPresent: [:aSBWatchView | allValues addAll: aSBWatchView display watchValues ]
			ifAbsent: [{}]].
	^ allValues
]

{ #category : #visualization }
SBTrace >> visualizeFor: anExample withWatches: aCollectionOfWatches [

	(self sortedWatchValuesFor: anExample givenWatches: aCollectionOfWatches)
		 do: [:aWatchValue | self addSectionFor: aWatchValue]
]
