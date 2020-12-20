Class {
	#name : #SBExampleBlockDecoration,
	#superclass : #SBASTNode,
	#instVars : [
		'contexts',
		'examples'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> allWatchesDo: aBlock [

	self sandblockEditor allBlocksDo: [:block |
		block isExampleWatch ifTrue: [aBlock value: block]]
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> childSandblocksDo: aBlock [

	self hasSubmorphs ifTrue: [
		self firstSubmorph childSandblocksDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> exampleFinished: anExample [

	| slider |
	slider := examples at: anExample ifAbsentPut: [ | s |
		s := SBExampleSlider new.
		self addMorphBack: s.
		s].
	slider exampleFinished: anExample.
	self allWatchesDo: [:watch |
		(watch valuesForExample: anExample) ifNotNil: [:display | slider example: anExample watch: display]]
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> filterForContextId: aNumber example: anExample [

	examples at: anExample ifPresent: [:slider | slider filterForContextId: aNumber]
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> initialize [

	super initialize.
	
	examples := Dictionary new.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #topToBottom
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> listensToExamples [

	^ true
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> wrapAround: aBlock [

	aBlock replaceBy: self.
	self addMorphFront: aBlock
]

{ #category : #'as yet unclassified' }
SBExampleBlockDecoration >> writeSourceOn: aStream [

	self firstSubmorph writeSourceOn: aStream
]
