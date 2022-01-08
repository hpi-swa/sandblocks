"
A SBErrorPanel collects and displays errors that occured in the environment.
"
Class {
	#name : #SBErrorPanel,
	#superclass : #Morph,
	#instVars : [
		'commandBar'
	],
	#category : #'Sandblocks-Debugger'
}

{ #category : #accessing }
SBErrorPanel >> activeErrorDo: aBlock [

	self submorphs detect: [:m | m expanded] ifFound: aBlock
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> addError: anError process: aProcess source: anExecutableEnvironment [

	| error |
	error := (SBToggledCode comment: '' active: 1 do: {[SBSmallError new]. [SBError new]})
		error: anError
		process: aProcess
		source: anExecutableEnvironment.
	self addMorphFront: error.
	^ error
]

{ #category : #initialization }
SBErrorPanel >> buildDebugCommandBar [

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4;
		layoutInset: 4;
		addMorphBack: (SBButton new
			icon: SBIcon iconLongArrowRight shortcut: $> asSandblockShortcut do: [self stepOver];
			balloonText: 'Step over');
		addMorphBack: (SBButton new
			icon: SBIcon iconLevelDown shortcut: $< asSandblockShortcut do: [self stepInto];
			balloonText: 'Step into');
		addMorphBack: (SBButton new
			icon: SBIcon iconForward shortcut: nil do: [self stepThrough];
			balloonText: 'Step through');
		addMorphBack: (SBButton new
			icon: SBIcon iconFastBackward shortcut: $R command do: [self restartFrame];
			balloonText: 'Restart frame')
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> deleteCommandFor: aMorph [

	^ SBDeleteCommand new target: aMorph
]

{ #category : #colors }
SBErrorPanel >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusError: anError [

	anError focus.
	commandBar ifNil: [self sandblockEditor addMorph: (commandBar := self buildDebugCommandBar) asElementNumber: 4]
]

{ #category : #actions }
SBErrorPanel >> focusErrors [
	<action>
	<globalAction>

	self hasSubmorphs ifTrue: [self focusError: self firstSubmorph]
]

{ #category : #actions }
SBErrorPanel >> focusPreviousErrorFrame [
	<action>
	<globalAction>

	self activeErrorDo: [:m | m focusPreviousFrame]
]

{ #category : #accessing }
SBErrorPanel >> focusedArtefact [

	self activeErrorDo: [:error | ^ self sandblockEditor open: error currentStackFrame context method].
	^ nil
]

{ #category : #accessing }
SBErrorPanel >> focusedContext [

	self activeErrorDo: [:error | ^ error currentStackFrame context].
	^ nil
]

{ #category : #initialization }
SBErrorPanel >> initialize [

	super initialize.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		extent: 0 @ 0;
		color: Color transparent
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> lookupGlobalAction: aSymbol [

	^ (self class lookupSelector: aSymbol) ifNotNil: [:m |
		((m pragmaAt: #globalAction) notNil and: [
			(m pragmaAt: #actionValidIf:)
				ifNotNil: [:p | self perform: p arguments first]
				ifNil: [true]])
			ifTrue: [m]
			ifFalse: [nil]]
]

{ #category : #hierarchy }
SBErrorPanel >> removedMorph: aMorph [

	super removedMorph: aMorph.
	self hasSubmorphs ifFalse: [
		self extent: 0 @ 0.
		commandBar ifNotNil: [
			commandBar delete.
			commandBar := nil]]
]

{ #category : #actions }
SBErrorPanel >> restartFrame [
	<action>
	<globalAction>

	self activeErrorDo: #restart
]

{ #category : #actions }
SBErrorPanel >> stepInto [
	<action>
	<globalAction>

	self activeErrorDo: #stepInto
]

{ #category : #actions }
SBErrorPanel >> stepOver [
	<action>
	<globalAction>

	self activeErrorDo: #stepOver
]

{ #category : #actions }
SBErrorPanel >> stepThrough [
	<action>
	<globalAction>

	self activeErrorDo: #stepThrough
]
