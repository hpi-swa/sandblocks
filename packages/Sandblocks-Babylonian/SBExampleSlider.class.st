Class {
	#name : #SBExampleSlider,
	#superclass : #SBASTNode,
	#instVars : [
		'example',
		'contextIdentityHashes',
		'selectedIndex'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExampleSlider >> allSlidersDo: aBlock [

	self sandblockEditor allBlocksDo: [:block |
		(block isKindOf: SBExampleBlockDecoration) ifTrue: [aBlock value: block]]
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> allWatchesDo: aBlock [

	self sandblockEditor allBlocksDo: [:block | block isExampleWatch ifTrue: [aBlock value: block]]
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> example: anExample watch: aWatch [

	| newHashes |
	example := anExample.
	
	newHashes := aWatch probedValues
		select: [:probedValue |
			probedValue hadMethodOnStack: self containingArtefact object block: self owner firstSubmorph startPC key]
		thenCollect: [:probedValue |
			probedValue contextIdentityHashFor: self owner firstSubmorph startPC key].
	
	contextIdentityHashes := (contextIdentityHashes, newHashes) withoutDuplicates.
	self lastSubmorph maximumValue: contextIdentityHashes size
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> exampleFinished: anExample [

	contextIdentityHashes := {}
	"self allWatchesDo: [:watch |
		(watch valuesForExample: anExample) ifNotNil: [:display | | snapshots |
			 (examples at: anExample ifAbsentPut: [ | slider |
				slider := SBExampleSlider new.
				self addMorphBack: slider.
				slider]).
			
			snapshots := display stackTrace select: [:assoc |
				assoc key anySatisfy: [:tuple |
					tuple first = self containingArtefact object identityHash]].
			
			contexts := snapshots collect: [:assoc | assoc key second].
			self lastSubmorph firstSubmorph contents: snapshots size asString.
			self lastSubmorph submorphs second maximumValue: snapshots size]]"
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> filterForContextId: aNumber [
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 8;
		addMorphBack: (SBStringMorph new contents: '0');
		addMorphBack: (SimpleSliderMorph new
			hResizing: #spaceFill;
			target: self;
			truncate: true;
			actionSelector: #selectIteration:;
			yourself)
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> listensToExamples [

	^ true
]

{ #category : #'as yet unclassified' }
SBExampleSlider >> selectIteration: aNumber [

	selectedIndex = aNumber ifTrue: [^ self].
	selectedIndex := aNumber.
	
	self firstSubmorph contents: (aNumber asString, '/'), contextIdentityHashes size asString.
	
	(aNumber > 0 and: [contextIdentityHashes notEmpty]) ifTrue: [
		self allWatchesDo: [:watch |
			watch filterForContextId: (contextIdentityHashes at: aNumber) example: example].
		self allSlidersDo: [:slider |
			slider filterForContextId: (contextIdentityHashes at: aNumber) example: example]]
]
