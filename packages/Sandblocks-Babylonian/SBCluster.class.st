Class {
	#name : #SBCluster,
	#superclass : #Morph,
	#instVars : [
		'morphResizer'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBCluster class >> newFromWatches: aCollectionOfSBExampleWatches havingSize: aSBMorphResizer [

	^ self new 
		morphResizer: aSBMorphResizer;
		buildFromWatches: aCollectionOfSBExampleWatches;
		yourself 
		
]

{ #category : #visualisation }
SBCluster >> buildFromWatches: aCollectionOfSBExampleWatches [

	| matrix |
	matrix := self watchesAsMatrix: aCollectionOfSBExampleWatches.
	matrix ifEmpty: [ ^ self].
	
	self addAllMorphsBack: {
		self newTopRowFrom: (matrix atRow: 1) allButFirst. "ignore placeholder morph"
		self newContainerMorph 
			listDirection: #leftToRight;
			cellInset: 0;
			addAllMorphsBack: {
				self newLeftColumnFrom: (matrix atColumn: 1) allButFirst. "ignore placeholder morph"
				SBGrid newDisplaying: 
					((matrix atRows: 2 to: matrix rowCount columns: 2 to: matrix columnCount)
						collect: [:aMorph | self wrapInCell: aMorph])}}
]

{ #category : #initialization }
SBCluster >> initialize [ 

	super initialize.
	
	self 
		color: Color transparent;
		changeTableLayout;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
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
		cellPositioning: #bottomCenter;
		hResizing: #spaceFill;
		addAllMorphsBack: (aCollectionOfMorphs collect: [:aMorph | 
			aMorph rotationDegrees: 90.
			(self wrapInCell: aMorph owner flexVertically: true flexHorizontally: false) borderWidth: 0])
]

{ #category : #converting }
SBCluster >> watchesAsMatrix: aCollectionOfSBExampleWatches [

	"Determine how watches are dissected to create a grid. We assume inclusion of headings per default"
	^ self subclassResponsibility. 
]

{ #category : #helper }
SBCluster >> wrapInCell: aMorph [

	^ self wrapInCell: aMorph flexVertically: false flexHorizontally: false 
	
]

{ #category : #helper }
SBCluster >> wrapInCell: aMorph flexVertically: aVBoolean flexHorizontally: aHBoolean [

	| cell targetExtent|
	cell := self newCellMorph.
	
	aVBoolean ifTrue: [cell vResizing: #shrinkWrap].
	aHBoolean ifTrue: [cell hResizing: #shrinkWrap].
	
	(((aMorph fullBounds extent <= cell extent) 
		or: [aVBoolean and: (aMorph fullBounds width <= cell width)]) 
		or: [aHBoolean and: (aMorph fullBounds height <= cell height)])
			ifTrue: [cell addMorph: aMorph. ^ cell].
	
	targetExtent := cell extent - (cell borderWidth@cell borderWidth).
	aVBoolean ifTrue: [targetExtent setX: targetExtent x setY: aMorph fullBounds height].
	aHBoolean ifTrue: [targetExtent setX: aMorph fullBounds width setY: targetExtent height].
	
	self flag: #todo. "Another way besides turning into an image to keep interactions.-jb"
	cell addMorph: (ImageMorph new 
		newForm: (aMorph iconOrThumbnailOfSize: targetExtent);
		when: #clicked send: #triggerEvent: to: aMorph with: #clicked).
	cell on: #click send: #value to: [cell submorphs first triggerEvent: #clicked].
	^ cell
]
