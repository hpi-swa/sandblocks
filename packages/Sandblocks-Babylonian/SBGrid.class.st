Class {
	#name : #SBGrid,
	#superclass : #Morph,
	#instVars : [
		'columnCount'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #constants }
SBGrid class >> cellInsetValue [

	^ 0
]

{ #category : #'initialize-release' }
SBGrid class >> newDisplaying: aMatrixOfMorphs [

	^ self new
		buildFromMatrix: aMatrixOfMorphs;
		yourself
]

{ #category : #visualisation }
SBGrid >> buildFromMatrix: aMatrixOfMorphs [

	self submorphs copy do: #abandon.
	columnCount := aMatrixOfMorphs columnCount.
	
	aMatrixOfMorphs do: [:aMorph | self addMorphBack: aMorph].
	self updateWidthToPersistColumns.
]

{ #category : #initialization }
SBGrid >> initialize [ 

	super initialize.
	columnCount := 5.
		
	self 
		color: Color transparent;
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight;
		wrapDirection: #topToBottom;
		wrapCentering: #topLeft;
		cellInset: self class cellInsetValue;
		width: 500;
		vResizing: #shrinkWrap.
]

{ #category : #'as yet unclassified' }
SBGrid >> resizeContents: aSBMorphResizer [

	self submorphsDo: [:aSubmorph | aSBMorphResizer applyOn: aSubmorph].
	self updateWidthToPersistColumns.
]

{ #category : #visualisation }
SBGrid >> updateWidthToPersistColumns [

	 self width: (columnCount * (self submorphs first width + (2 * self cellInset)))
]
