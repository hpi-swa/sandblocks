Class {
	#name : #SBResizableResultsView,
	#superclass : #SBGridResultsView,
	#instVars : [
		'dimensionOptions'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #actions }
SBResizableResultsView >> applyResizer [

	self visualize.
	self multiverse sandblockEditor markSaved: SBExploriants uniqueInstance 
]

{ #category : #building }
SBResizableResultsView >> buildDimensionOptions [

	| options |
	options := SBMorphResizer standardOptions.

	^ SBComboBox new
		prefix: 'Preview size: ';
		labels: (options collect: #label);
		values: options;
		object: options third;
		when: #selectionChanged send: #applyResizer to: self
]

{ #category : #accessing }
SBResizableResultsView >> buttons [

	^ {dimensionOptions}
]

{ #category : #initialization }
SBResizableResultsView >> initialize [ 

	super initialize.
	
	dimensionOptions := self buildDimensionOptions
]

{ #category : #accessing }
SBResizableResultsView >> selectedResizer [

	^ dimensionOptions object
]
