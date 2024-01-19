Class {
	#name : #SBExploriantsView,
	#superclass : #SBNamedBlock,
	#instVars : [
		'multiverse'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'instance creation' }
SBExploriantsView class >> block: aSBBlock named: aString [

	"only calling new allowed to guarantee intented purpose"
	self shouldNotImplement 
]

{ #category : #'instance creation' }
SBExploriantsView class >> getTabsInMultiverse: aSBMultiverse [

	^ {SBPermutationGridsView. SBExampleGridsView. SBPlainResultsView. SBLiveView. SBVariantsView}
		collect: [:mySubclass | mySubclass newMultiverse: aSBMultiverse]
]

{ #category : #'instance creation' }
SBExploriantsView class >> newMultiverse: aSBMultiverse [

	^ self new
		multiverse: aSBMultiverse;
		yourself
]

{ #category : #building }
SBExploriantsView >> buildButtonRow [ 

	self block addMorphFront: (SBRow new
			changeTableLayout;
			cellGap: 8 * self scalingFactor;
			addAllMorphsBack: self buttons)
]

{ #category : #accessing }
SBExploriantsView >> buttons [

	^ {self updateButton. self resolveButton}
]

{ #category : #actions }
SBExploriantsView >> clean [

	self block submorphs copy do: #delete
]

{ #category : #building }
SBExploriantsView >> containerRow [

	^  SBRow new
		color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #leftToRight;
		layoutInset: 8;
		cellGap: 3;
		cellInset: 3;
		borderWidth: 0
]

{ #category : #accessing }
SBExploriantsView >> findExistingOrConvertToBlocks: aCollectionOfCompiledMethods [ 

	^ aCollectionOfCompiledMethods
		collect: [:aCompiledMethod | 
			self block sandblockEditor blockFor: aCompiledMethod withInterfaces: #(#isMethod) 
				ifOpen: [:existingMethodBlock | existingMethodBlock] 
				ifClosed: [aCompiledMethod asSandblock]]
]

{ #category : #initialization }
SBExploriantsView >> initialize [

	super initialize.
	
	self block: (SBBlock new
		changeTableLayout;
		color: Color white;
		listDirection: #topToBottom;
		layoutInset: 3;
		cellGap: 4;
		cellInset: 2;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap)
]

{ #category : #accessing }
SBExploriantsView >> multiverse [

	^ multiverse ifNil: [self multiverse: (SBMultiverse bigbangInEditor: SBEditor current)]
]

{ #category : #accessing }
SBExploriantsView >> multiverse: aSBMultiverse [

	multiverse := aSBMultiverse.
	multiverse when: #updated send: #visualize to: self.
]

{ #category : #building }
SBExploriantsView >> resolveButton [

	^ SBButton new
		icon: SBIcon iconTrash
			label: 'Resolve All From Code'
			do: [self multiverse resolve];
		cornerStyle: #squared
]

{ #category : #building }
SBExploriantsView >> updateButton [

	^ SBButton new
		icon: SBIcon iconRotateLeft
			label: 'Re-Generate Multiverse'
			do: [self multiverse gatherElements; asyncKaboom];
		cornerStyle: #squared
]

{ #category : #actions }
SBExploriantsView >> visualize [ 

	self clean.

	self buildButtonRow
]
