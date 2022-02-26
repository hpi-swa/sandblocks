Class {
	#name : #SBDragPlaceholder,
	#superclass : #Morph,
	#instVars : [
		'hintColor'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDragPlaceholder >> handlesMouseOverDragging: evt [

	^ true
]

{ #category : #'as yet unclassified' }
SBDragPlaceholder >> hintColor: aColor [

	hintColor := aColor
]

{ #category : #'as yet unclassified' }
SBDragPlaceholder >> initialize [

	super initialize.
	
	self
		borderStyle: (DashedBorder new
			width: 2;
			baseColor: (Color r: 0.0 g: 0.0 b: 0.0);
			yourself);
		color: ((Color r: 1 g: 1 b: 1) alpha: 0.6)
]

{ #category : #'as yet unclassified' }
SBDragPlaceholder >> mouseEnterDragging: evt [

	super mouseEnterDragging: evt.
	self borderColor: hintColor
]

{ #category : #'as yet unclassified' }
SBDragPlaceholder >> mouseLeaveDragging: evt [

	super mouseLeaveDragging: evt.
	self borderColor: Color black
]

{ #category : #'as yet unclassified' }
SBDragPlaceholder >> outerBounds [

	^ self bounds expandBy: 2
]
