Class {
	#name : #SBProfiler,
	#superclass : #SBBlock,
	#instVars : [
		'currentlyProfiling'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBProfiler >> canCopy [

	^ false
]

{ #category : #'as yet unclassified' }
SBProfiler >> initialize [

	super initialize.
	
	self
		hResizing: #rigid;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 4;
		attachDecorator: SBMoveDecorator new;
		extent: 300 @ self fontToUse height
]

{ #category : #'as yet unclassified' }
SBProfiler >> object [

	^ nil
]

{ #category : #'as yet unclassified' }
SBProfiler >> openFrame: aTally [

	" todo: handle idle process properly "
	self addMorphBack: (SBProfilerFrame new tally: aTally receivers second total: aTally receivers second tally totalTime: aTally time).
	self height: 0
]

{ #category : #'as yet unclassified' }
SBProfiler >> startProfiling [
	<action>

	| tally |
	
	currentlyProfiling := true.
	self removeAllMorphs.
	
	tally := MessageTally new.
	tally spyEvery: 1 on: [
		[currentlyProfiling] whileTrue: [self world doOneCycle]].
	
	self openFrame: tally
]

{ #category : #'as yet unclassified' }
SBProfiler >> stopProfiling [
	<action>

	currentlyProfiling := false
]
