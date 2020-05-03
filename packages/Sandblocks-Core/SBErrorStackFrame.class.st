Class {
	#name : #SBErrorStackFrame,
	#superclass : #SBBlock,
	#instVars : [
		'context',
		'pcIndicator',
		'valueDecorators'
	],
	#category : #'Sandblocks-Core'
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

	^ self method blockForPC: context pc
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

	^ (self owner submorphIndexOf: self) = 1
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> method [

	^ self sandblockEditor openCompiledMethod: context method
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
			d label: context top asString.
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
	((self sandblockEditor openCompiledMethod: self context method) blockForPC: (self isActiveFrame ifTrue: [self context pc] ifFalse: [self context previousPc])) ifNotNil: [:block | 
		block
			select;
			attachDecorator: (pcIndicator := SBErrorDecorator new)]
]

{ #category : #'as yet unclassified' }
SBErrorStackFrame >> wasSelected [

	| method |
	super wasSelected.
	method := self sandblockEditor openCompiledMethod: self context method.
	self detachDecorators: SBErrorDecorator; attachDecorator: SBErrorDecorator new.
	self updateSelection.
	self triggerEvent: #selected with: self
]
