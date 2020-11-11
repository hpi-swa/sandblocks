"
A SBErrorStackFrame is the representation of a stack frame in a suspended process as a block.
"
Class {
	#name : #SBErrorStackFrame,
	#superclass : #SBBlock,
	#instVars : [
		'context',
		'pcIndicator',
		'valueDecorators'
	],
	#category : #'Sandblocks-Debugger'
}

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> childSandblocksDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> closed [

	pcIndicator ifNotNil: #detach.
	valueDecorators do: #detach.
	self detachDecorators: SBErrorDecorator
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> context [

	^ context
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> context: aContext [

	context := aContext.
	self addMorph: (SBStringMorph new contents: (aContext asString truncateMiddleTo: 30))
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> currentBlock [

	^ self currentBlockIsActive: self isActiveFrame
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> currentBlockIsActive: aBoolean [

	^ self method blockForPC: (aBoolean ifTrue: [context pc] ifFalse: [context previousPc])
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> initialize [

	super initialize.
	
	valueDecorators := OrderedCollection new.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> isActiveFrame [

	^ context = self parentSandblock process suspendedContext
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> method [

	^ self sandblockEditor open: context method homeMethod
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> object [

	^ context
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> outOfWorld: aWorld [

	self closed.
	super outOfWorld: aWorld
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> printOn: aStream [

	aStream nextPutAll: 'error frame on '.
	context printOn: aStream
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> recordTopValueFor: aBlock [

	aBlock
		ifNotNil: [:b | b ensureDecorator: SBReportedValueDecorator do: [:d |
			valueDecorators add: d.
			d label: (aBlock isAssignment
				ifTrue: [Compiler new evaluate: aBlock binding contents for: context receiver]
				ifFalse: [context top]) asString.
			d flash]]
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> setActive [

	self isSelected
		ifTrue: [self updateSelection]
		ifFalse: [self select]
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> updateSelection [

	pcIndicator ifNotNil: #detach.
	self currentBlock ifNotNil: [:block | 
		block
			select;
			attachDecorator: (pcIndicator := SBErrorDecorator new)]
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> wasSelected [

	| method |
	method := self sandblockEditor open: self context method homeMethod.
	self detachDecorators: SBErrorDecorator; attachDecorator: SBErrorDecorator new.
	self updateSelection.
	super wasSelected
]
