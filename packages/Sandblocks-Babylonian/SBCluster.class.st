Class {
	#name : #SBCluster,
	#superclass : #Morph,
	#instVars : [
		'morphResizer'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #visualisation }
SBCluster >> compressedMorphsForDisplay: aSBWatchView [

	| displayedMorphs |
	displayedMorphs  := self gatherMorphsToCompressFrom: aSBWatchView.
	^ (displayedMorphs size = 1) 
		ifTrue: [displayedMorphs first]
		ifFalse: [self newCellMorph 
					borderWidth: 0;
					when: #clicked send: #exploreValues to: aSBWatchView;
					listDirection: #leftToRight;
					wrapDirection: #topToBottom;
					addAllMorphsBack: displayedMorphs]
]

{ #category : #visualisation }
SBCluster >> gatherMorphsToCompressFrom: aSBWatchView [

	^ aSBWatchView isDisplayingWatchValues 
		ifTrue: [aSBWatchView watchValues collect: [:aWatchValue | 
					aWatchValue morphResizer: self morphResizer. 
					aWatchValue asValueMorph]]
		ifFalse: [{self morphResizer applyOn: aSBWatchView selectedDisplay sbSnapshot }]
]

{ #category : #initialization }
SBCluster >> initialize [ 

	super initialize.
	
	self 
		color: Color transparent;
		changeTableLayout;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellInset: 0@2
]

{ #category : #accessing }
SBCluster >> morphResizer [

	^ morphResizer
]

{ #category : #accessing }
SBCluster >> morphResizer: aSBMorphResizer [

	morphResizer := aSBMorphResizer
]

{ #category : #helper }
SBCluster >> newCellMorph [

	^ self morphResizer applyOn: (
		Morph new
			color: Color transparent ;
			changeTableLayout;
			borderWidth: 1;
			borderStyle: (BorderStyle width: 1 color: (Color gray alpha: 0.3));
			listDirection: #topToBottom;
			listCentering: #center;
			wrapCentering: #center;
			hResizing: #rigid;
			vResizing: #rigid)
]

{ #category : #helper }
SBCluster >> newContainerMorph [

	^ Morph new
		color: Color transparent ;
		changeTableLayout;
		listDirection: #topToBottom;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellInset: SBGrid cellInsetValue
]

{ #category : #visualisation }
SBCluster >> newLeftColumnFrom: aCollectionOfMorphs [
	
	"Height should be set, but width can vary"
	^ self newContainerMorph 
		cellPositioning: #rightCenter;
		addAllMorphsBack: (aCollectionOfMorphs collect: [:aMorph | 
			(self wrapInCell: aMorph flexVertically: false flexHorizontally: true)
				listDirection: #rightToLeft;
				borderWidth: 0])
]

{ #category : #visualisation }
SBCluster >> newTopLeftCornerPlaceholder [

	^ self newCellMorph
]

{ #category : #visualisation }
SBCluster >> newTopRowFrom: aCollectionOfMorphs [
	
	"Width should be set, but height can vary"
	^ self newContainerMorph 
		listDirection: #leftToRight;
		listCentering: #bottomRight;
		cellPositioning: #topCenter;
		hResizing: #spaceFill;
		addAllMorphsBack: (aCollectionOfMorphs collect: [:aMorph | 
			self newContainerMorph addMorphBack: (self morphResizer applyOn: aMorph)])
]

{ #category : #visualisation }
SBCluster >> sortedWatchValuesFor: anExample givenWatches: aCollectionOfWatches [

	| allValues |
	allValues := SortedCollection sortBlock: [:a :b | a chronologicalPosition <= b chronologicalPosition].
	aCollectionOfWatches exampleToDisplay at: anExample 
		ifPresent: [:aSBWatchView | allValues addAll: aSBWatchView watchValues ]
		ifAbsent: [{}].
	^ allValues
]

{ #category : #visualisation }
SBCluster >> visualize [

	| matrix |
	self submorphs copy do: #delete.
	
	matrix := self buildDisplayMatrix.
	(matrix rowCount < 2 or: [matrix columnCount < 2]) 
		ifTrue:[self visualizeNothingToDisplay. ^ self].
	
	self addMorphBack: (
		self newContainerMorph 
			cellInset: 0@0;
			addAllMorphsBack:  {
				self newTopRowFrom: (matrix atRow: 1) allButFirst. "ignore placeholder morph"
				self newContainerMorph 
					listDirection: #leftToRight;
					cellInset: 3@3;
					addAllMorphsBack: {
						self newLeftColumnFrom: (matrix atColumn: 1) allButFirst. "ignore placeholder morph"
						SBGrid newDisplaying: 
							((matrix atRows: 2 to: matrix rowCount columns: 2 to: matrix columnCount)
								collect: [:aMorph | self wrapInCell: aMorph])}})
]

{ #category : #visualisation }
SBCluster >> visualizeNothingToDisplay [

	self addMorph: (SBOwnTextMorph new contents: 'No watches to display')
	
]

{ #category : #helper }
SBCluster >> wrapInCell: aMorph [

	^ self morphResizer label = SBMorphResizer newIdentity label
		ifTrue: [self wrapInCell: aMorph flexVertically: true flexHorizontally: true] 
		ifFalse: [self wrapInCell: aMorph flexVertically: false flexHorizontally: false]
	
]

{ #category : #helper }
SBCluster >> wrapInCell: aMorph flexVertically: aVBoolean flexHorizontally: aHBoolean [

	| cell targetExtent |
	cell := self newCellMorph.
	cell on: #click send: #value to: [aMorph triggerEvent: #clicked].
	
	aVBoolean ifTrue: [cell vResizing: #shrinkWrap].
	aHBoolean ifTrue: [cell hResizing: #shrinkWrap].
	
	(((aMorph fullBounds extent <= cell extent) 
		or: [aVBoolean and: (aMorph fullBounds width <= cell width)]) 
		or: [aHBoolean and: (aMorph fullBounds height <= cell height)]
		or: [aVBoolean and: aHBoolean])
			ifTrue: [cell addMorph: aMorph. ^ cell].
	
	targetExtent := cell extent - (cell borderWidth@cell borderWidth).
	aVBoolean ifTrue: [targetExtent setX: targetExtent x setY: aMorph fullBounds height].
	aHBoolean ifTrue: [targetExtent setX: aMorph fullBounds width setY: targetExtent y].
	
	self flag: #todo. "Another way besides turning into an image to keep interactions.-jb"
	cell addMorph: (ImageMorph new 
		newForm: (aMorph imageForm scaledIntoFormOfSize: targetExtent);
		when: #clicked send: #triggerEvent: to: aMorph with: #clicked;
		tag: aMorph tag).
    
	^ cell
]
