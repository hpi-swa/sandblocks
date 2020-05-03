Class {
	#name : #JCTile,
	#superclass : #Morph,
	#instVars : [
		'label',
		'value',
		'tilePosition',
		'neighbors',
		'splitAE',
		'valueAE'
	],
	#category : 'JumpingCubes'
}

{ #category : #'as yet unclassified' }
JCTile >> findNeighbors [

	neighbors := {(0 @ 1). (-1 @ 0). (0 @ -1). (1 @ 0)} collect: [:offset | self owner tileAt: self tilePosition + offset] thenSelect: #notNil.
	splitAE := SBWatch report: (SBSynchronousActiveExpression on: [value > self neighborCount]) for: 158140665.
	splitAE onChangeDo: [:shouldSplit | shouldSplit ifTrue: [self splitValue]].
	valueAE := SBWatch report: (SBSynchronousActiveExpression on: [value]) for: 331582167.
	valueAE onChangeDo: [:val | label contents: val asString]
]

{ #category : #'as yet unclassified' }
JCTile >> handlesMouseDown: anEvent [ 
	^ true
]

{ #category : #'as yet unclassified' }
JCTile >> incrementValue [

	value := value + 1
]

{ #category : #'as yet unclassified' }
JCTile >> initialize [

	super initialize.
	value := 2.
	self
		 extent: self tileSize;
		 changeTableLayout;
		 cellPositioning: #center;
		 listCentering: #center;
		 wrapCentering: #center;
		 borderStyle: BorderStyle simple;
		 borderColor: Color black;
		 borderWidth: 1;
		 addMorphBack: (label := StringMorph new contents: value asString);
		 color: Color white
]

{ #category : #'as yet unclassified' }
JCTile >> mouseDown: anEvent [

	self incrementValue
]

{ #category : #'as yet unclassified' }
JCTile >> neighborCount [

	^ self neighboringTiles size
]

{ #category : #'as yet unclassified' }
JCTile >> neighboringTiles [

	^ neighbors
]

{ #category : #'as yet unclassified' }
JCTile >> splitValue [

	self neighboringTiles do: [:tile | tile incrementValue].
	value := value - self neighboringTiles size
]

{ #category : #'as yet unclassified' }
JCTile >> tilePosition [
	^ tilePosition
]

{ #category : #'as yet unclassified' }
JCTile >> tilePosition: aPoint [

	self position: (aPoint - 1) * self extent.
	tilePosition := aPoint
]

{ #category : #'as yet unclassified' }
JCTile >> tileSize [

	^ 20 asPoint
]

{ #category : #'as yet unclassified' }
JCTile >> value [
	^ value
]

{ #category : #'as yet unclassified' }
JCTile >> value: aNumber [

	value := aNumber
]
