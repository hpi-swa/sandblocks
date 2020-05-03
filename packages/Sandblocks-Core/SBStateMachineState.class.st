Class {
	#name : #SBStateMachineState,
	#superclass : #SBBlock,
	#instVars : [
		'name',
		'label'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStateMachineState >> addUponEnter: aBlock [

	self addMorphBack: (SBRow new
		 cellGap: 4 withScalingFactor;
		 addMorphBack: (SBStringMorph new contents: 'Enter:');
		 addMorphBack: aBlock)
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> addUponLeave: aBlock [

	self addMorphBack: (SBRow new
		 cellGap: 4 withScalingFactor;
		 addMorphBack: (SBStringMorph new contents: 'Leave:');
		 addMorphBack: aBlock)
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> childSandblocksDo: aBlock [

	aBlock value: label.
	self submorphs from: 2 to: self submorphCount do: [:m |
		aBlock value: m submorphs second]
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> codeActions [

	| states index |
	^ {
		(SBCodeAction
			labeled: 'Connect ...'
			for: self
			do: [:node | 
				states := self owner states collect: #name.
				index := UIManager default chooseFrom: states.
				index >= 0 ifTrue: [self owner connect: self name to: (states values at: index) if: SBBlockBody empty]]).
		(SBCodeAction labeled: 'Add Enter' for: self do: [:node | node addUponEnter: SBBlockBody empty]).
		(SBCodeAction labeled: 'Add Leave' for: self do: [:node | node addUponLeave: SBBlockBody empty]).
		(SBCodeAction labeled: 'Set Initial' for: self do: [:node | node owner initialState: self])
	}
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> initialize [

	super initialize.
	self addMorphBack: (label := SBTextBubble new).
	self
		 changeTableLayout;
		 vResizing: #shrinkWrap;
		 hResizing: #shrinkWrap;
		 layoutInset: 6 withScalingFactor;
		 attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> name [

	^ name
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> name: aString [

	name := aString.
	label contents: aString
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> prefix [

	^ self owner initialState = self ifTrue: ['* '] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> uponEnterBlocks [

	^ ((self submorphs copyFrom: 2) select: [:row | row submorphs first contents = 'Enter:']) collect: [:row | row submorphs second]
]

{ #category : #'as yet unclassified' }
SBStateMachineState >> uponLeaveBlocks [

	^ ((self submorphs copyFrom: 2) select: [:row | row submorphs first contents = 'Leave:']) collect: [:row | row submorphs second]
]
