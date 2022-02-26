Class {
	#name : #SBDragContainer,
	#superclass : #SBSelection,
	#instVars : [
		'dragHint'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDragContainer >> abortDrag: anEvent [

	super abortDrag: anEvent.
	
	dragHint ifNotNil: #delete
]

{ #category : #'as yet unclassified' }
SBDragContainer >> applyDrag [

	dragHint ifNotNil: #delete.
	
	(self sourceBlock notNil and: [self sourceBlock copyOnDrag not]) ifTrue: [
		(self sourceBlock parentSandblock deleteCommandFor: self sourceBlock) ifNotNil: [:cmd |
			self sourceBlock sandblockEditor do: (cmd
				shouldMergeWithNext: true;
				selectAfter: #none;
				yourself)]]
]

{ #category : #'as yet unclassified' }
SBDragContainer >> sourceBlock: aBlock [

	super sourceBlock: aBlock.
	
	dragHint := SBDragPlaceholder new
		bounds: aBlock boundsInWorld;
		hintColor: (aBlock colorPolicy dropMarkerColorFor: aBlock);
		openInWorld
]
