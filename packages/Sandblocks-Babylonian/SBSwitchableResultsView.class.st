"
Offer to switch between trace based and a grid based view
"
Class {
	#name : #SBSwitchableResultsView,
	#superclass : #SBResizableResultsView,
	#instVars : [
		'isDisplayingTrace'
	],
	#category : #'Sandblocks-Babylonian'
}

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
]

{ #category : #copying }
SBSwitchableResultsView >> snapshotSatisfying: aCollectionOfSBTags [

	^ gridContainer snapshotSatisfying: aCollectionOfSBTags
	
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
			label: 'Group By Probes <> In Execution Order'
			do: [self toggleView];
		cornerStyle: #squared
]

{ #category : #accessing }
SBSwitchableResultsView >> wantsReloadOnSaveWhenOpen [

	^ true
]
