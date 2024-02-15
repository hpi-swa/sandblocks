"
Offer to switch between trace based and a grid based view
"
Class {
	#name : #SBSwitchableResultsView,
	#superclass : #SBGridResultsView,
	#instVars : [
		'isDisplayingTrace',
		'dimensionOptions'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #actions }
SBSwitchableResultsView >> applyResizer [

	self visualize.
	self multiverse sandblockEditor markSaved: SBExploriants uniqueInstance 
]

{ #category : #building }
SBSwitchableResultsView >> buildDimensionOptions [

	| options |
	options := SBMorphResizer standardOptions.

	^ SBComboBox new
		prefix: 'Morph Dimensions: ';
		labels: (options collect: #label);
		values: options;
		object: options third;
		when: #selectionChanged send: #applyResizer to: self
]

{ #category : #accessing }
SBSwitchableResultsView >> buttons [

	^ super buttons, {self toggleViewButton}
]

{ #category : #accessing }
SBSwitchableResultsView >> currentClusterClass [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBSwitchableResultsView >> initialize [ 

	super initialize.
	
	isDisplayingTrace := false.
	dimensionOptions := self buildDimensionOptions
]

{ #category : #accessing }
SBSwitchableResultsView >> selectedResizer [

	^ dimensionOptions object
]

{ #category : #building }
SBSwitchableResultsView >> toggleIcon [

	^ isDisplayingTrace 
		ifTrue: [SBIcon iconToggleOn]
		ifFalse: [SBIcon iconToggleOff]
]

{ #category : #accessing }
SBSwitchableResultsView >> toggleView [

	isDisplayingTrace := isDisplayingTrace not.
	
	self visualize
]

{ #category : #building }
SBSwitchableResultsView >> toggleViewButton [

	^ SBButton new
		icon: self toggleIcon
			label: 'Group By Watches <> In Execution Order'
			do: [self toggleView];
		cornerStyle: #squared
]

{ #category : #actions }
SBSwitchableResultsView >> visualize [ 

	self clean.

	self block addMorph: dimensionOptions.
	self buildButtonRow.
	
	self buildAllPossibleResults 
]
