"
A SBErrorPanel collects and displays errors that occured in the environment.
"
Class {
	#name : #SBErrorPanel,
	#superclass : #SBBlock,
	#instVars : [
		'commandBar'
	],
	#category : #'Sandblocks-Debugger'
}

{ #category : #'as yet unclassified' }
SBErrorPanel >> activeErrorDo: aBlock [

	self submorphs detect: [:m | m expanded] ifFound: aBlock
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> addError: anError process: aProcess [

	| error |
	error := SBError new error: anError process: aProcess.
	self addMorphFront: error.
	^ error
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> buildDebugCommandBar [

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		addMorphBack: (SBButton new
			icon: SBIcon iconLong_arrow_right shortcut: $> asSandblockShortcut do: [self stepOver];
			balloonText: 'Step over');
		addMorphBack: (SBButton new
			icon: SBIcon iconLevel_down shortcut: $< asSandblockShortcut do: [self stepInto];
			balloonText: 'Step into');
		addMorphBack: (SBButton new
			icon: SBIcon iconForward shortcut: nil do: [self stepThrough];
			balloonText: 'Step through');
		addMorphBack: (SBButton new
			icon: SBIcon iconFast_backward shortcut: $R command do: [self restartFrame];
			balloonText: 'Restart frame')
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> deleteCommandFor: aMorph [

	^ SBDeleteCommand newNonEdit target: aMorph
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusError: anError [

	anError focus.
	commandBar ifNil: [self sandblockEditor addMorph: (commandBar := self buildDebugCommandBar) asElementNumber: 4]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusErrors [
	<action>

	self hasSubmorphs ifTrue: [self focusError: self firstSubmorph]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusPreviousErrorFrame [
	<action>

	self activeErrorDo: [:m | m focusPreviousFrame]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusedArtefact [

	self activeErrorDo: [:error | ^ self sandblockEditor open: error currentStackFrame context method].
	^ nil
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusedContext [

	self activeErrorDo: [:error | ^ error currentStackFrame context].
	^ nil
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> initialize [

	super initialize.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> removedMorph: aMorph [

	super removedMorph: aMorph.
	self hasSubmorphs ifFalse: [
		self extent: 0 @ 0.
		commandBar ifNotNil: [
			commandBar delete.
			commandBar := nil]]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> restartFrame [
	<action>

	self activeErrorDo: #restart
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> stepInto [
	<action>

	self activeErrorDo: #stepInto
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> stepOver [
	<action>

	self activeErrorDo: #stepOver
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> stepThrough [
	<action>

	self activeErrorDo: #stepThrough
]
