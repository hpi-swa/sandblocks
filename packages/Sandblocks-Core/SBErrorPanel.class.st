Class {
	#name : #SBErrorPanel,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
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
SBErrorPanel >> focus [

	self hasSubmorphs ifTrue: [self firstSubmorph focus]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusPreviousFrame [

	self activeErrorDo: [:m | m focusPreviousFrame]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> focusedArtefact [

	self activeErrorDo: [:error | ^ self sandblockEditor openCompiledMethod: error currentStackFrame context method].
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
	self hasSubmorphs ifFalse: [self extent: 0 @ 0]
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> restart [

	self activeErrorDo: #restart
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> stepInto [

	self activeErrorDo: #stepInto
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> stepOver [

	self activeErrorDo: #stepOver
]

{ #category : #'as yet unclassified' }
SBErrorPanel >> stepThrough [

	self activeErrorDo: #stepThrough
]