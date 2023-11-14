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
	(matrix rowCount < 2 or: [matrix columnCount < 2]) ifTrue: [ ^ self].
	
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
		color: Color white;
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
			color: Color blue;
			changeTableLayout;
			listDirection: #topToBottom;
			listCentering: #center;
			wrapCentering: #center;
			hResizing: #rigid;
			vResizing: #rigid)
]

{ #category : #helper }
SBCluster >> newContainerMorph [

	^ Morph new
		color: Color banana;
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
				listDirection: #rightToLeft])
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
			self wrapInCell: aMorph owner flexVertically: true flexHorizontally: false])
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

	| cell |
	cell := self newCellMorph.
	
	aVBoolean ifTrue: [cell vResizing: #shrinkWrap].
	aHBoolean ifTrue: [cell hResizing: #shrinkWrap].
	
	cell addMorph: aMorph.
	
	^ cell
]
