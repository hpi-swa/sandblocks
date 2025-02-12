Class {
	#name : #SBTrace,
	#superclass : #Morph,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBTrace class >> newForSize: aMorphResizer example: anExample watches: aCollectionOfWatches [

	^ self new visualizeFor: anExample withWatches: aCollectionOfWatches resizer: aMorphResizer
		
]

{ #category : #visualization }
SBTrace >> addSectionFor: aWatchValue resizer: aMorphResizer example: anExample [

	self addMorphBack: (
		self placeHolderMorph
			tag: ((SBTag 
				newFromWatch: aWatchValue occuringWatch)
				addFromExample: anExample);
			addMorphBack: (TextMorph new contents: (aWatchValue expressionString asText
									addAttribute: (TextColor color: Color gray);
									yourself));
			addMorphBack: ([aWatchValue morphResizer: aMorphResizer.
							 aWatchValue asValueMorph] value);
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
		aWatch exampleToValues at: anExample 
			ifPresent: [:aCollectionOfWatchValues | allValues addAll: aCollectionOfWatchValues ]
			ifAbsent: [{}]].
	^ allValues
]

{ #category : #visualization }
SBTrace >> visualizeFor: anExample withWatches: aCollectionOfWatches resizer: aMorphResizer [

	(self sortedWatchValuesFor: anExample givenWatches: aCollectionOfWatches)
		 do: [:aWatchValue | 
			self 
				addSectionFor: aWatchValue 
				resizer: aMorphResizer 
				example: anExample]
]
