Class {
	#name : #SBSmallError,
	#superclass : #SBBlock,
	#instVars : [
		'error',
		'process',
		'currentHighlight'
	],
	#category : #'Sandblocks-Debugger'
}

{ #category : #'as yet unclassified' }
SBSmallError >> click: anEvent [

	process debugWithTitle: error asString.
	self deleteBlock
]

{ #category : #'as yet unclassified' }
SBSmallError >> currentBlock [

	self flag: #todo. " breaks for processes that timed out and have a very deep stack "
	process suspendedContext findContextSuchThat: [:context |
		self sandblockEditor
			blockFor: context method homeMethod
			withInterfaces: #()
			ifOpen: [:method | | pc |
				pc := context = process suspendedContext
					ifTrue: [context pc]
					ifFalse: [context previousPc].
				^ method blockForPC: (context closure ifNotNil: [:c | c method -> pc] ifNil: [pc])]
			ifClosed: [false]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBSmallError >> drawOn: aCanvas [

	aCanvas fillOval: self bounds color: self color
]

{ #category : #'as yet unclassified' }
SBSmallError >> error: anError process: aProcess source: anExecutableEnvironment [

	error := anError.
	process := aProcess.
	self balloonText: anError asString.
	
	anExecutableEnvironment ifNotNil: [anExecutableEnvironment when: #outOfWorld send: #delete to: self]
]

{ #category : #'as yet unclassified' }
SBSmallError >> expanded [

	^ false
]

{ #category : #'as yet unclassified' }
SBSmallError >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBSmallError >> initialize [

	super initialize.
	
	self
		extent: 18 asPoint;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: SBIcon iconFlash
]

{ #category : #'as yet unclassified' }
SBSmallError >> mouseEnter: anEvent [

	self currentBlock ifNotNil: [:block | block attachDecorator: (currentHighlight := SBErrorDecorator new)]
]

{ #category : #'as yet unclassified' }
SBSmallError >> mouseLeave: anEvent [

	currentHighlight ifNotNil: #detach.
	currentHighlight := nil
]

{ #category : #'as yet unclassified' }
SBSmallError >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	currentHighlight ifNotNil: #detach.
	currentHighlight := nil
]

{ #category : #'as yet unclassified' }
SBSmallError >> preferredColorIn: aColorPolicy [

	^ aColorPolicy important
]

{ #category : #'as yet unclassified' }
SBSmallError >> veryDeepCopyWith: deepCopier [

	| copy oldProcess oldError |
	oldProcess := process.
	oldError := error.
	process := nil.
	error := nil.
	copy := super veryDeepCopyWith: deepCopier.
	process := oldProcess.
	error := oldError.
	^ copy
]
