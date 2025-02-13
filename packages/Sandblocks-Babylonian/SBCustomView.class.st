Class {
	#name : #SBCustomView,
	#superclass : #SBExploriantsView,
	#instVars : [
		'viewOptions'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #accessing }
SBCustomView >> activeIndex [

	^ self viewClasses indexOf: self selectedView class
]

{ #category : #building }
SBCustomView >> buildViewOptions [

	| options |
	options := self viewClasses collect: [:aClass | aClass new hasBeenRenamed: true].

	^ SBComboBox new
		prefix: 'Current Grid View: ';
		labels: (options collect: #name);
		values: options ;
		object: options third;
		when: #selectionChanged send: #switchView to: self
]

{ #category : #accessing }
SBCustomView >> buttons [

	^ {viewOptions}, super buttons
]

{ #category : #initialization }
SBCustomView >> initialize [ 

	super initialize.
	
	viewOptions := self buildViewOptions.
	self name: 'Results'.
	
	self buildButtonRow.
	self block addMorphBack: self selectedView block.
]

{ #category : #accessing }
SBCustomView >> isOverview [

	^ true
]

{ #category : #accessing }
SBCustomView >> multiverse: aSBMultiverse [

	super multiverse: aSBMultiverse.
	viewOptions values do: [:aSBNamedBlock | aSBNamedBlock multiverse: aSBMultiverse]
]

{ #category : #accessing }
SBCustomView >> selectedView [

	^ viewOptions object
]

{ #category : #updating }
SBCustomView >> switchView [

	self selectedView block = self block lastSubmorph ifTrue: [^ self].

	self block lastSubmorph delete.
	self block addMorphBack: self selectedView block.
]

{ #category : #accessing }
SBCustomView >> viewClasses [

	^ {SBPermutationGridsView. 
		SBExampleGridsView. 
		SBCorrelationView.
		SBLiveView.}
]

{ #category : #accessing }
SBCustomView >> views [

	^ viewOptions values
]

{ #category : #updating }
SBCustomView >> visualize [ 

	self block addMorphBack: self selectedView block.
]

{ #category : #accessing }
SBCustomView >> wantsReloadOnSaveWhenOpen [

	^ self selectedView wantsReloadOnSaveWhenOpen
]
