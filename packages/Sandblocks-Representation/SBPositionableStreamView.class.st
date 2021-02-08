Class {
	#name : #SBPositionableStreamView,
	#superclass : #SBBlock,
	#instVars : [
		'stream'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> canDeleteChild: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> childSandblocksDo: aBlock [

	self firstSubmorph submorphs do: [:morph | morph isSandblock ifTrue: [aBlock value: morph]].
	aBlock value: self submorphs second.
	aBlock value: self submorphs third
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> hasUnsavedChanges [

	^ false
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> hasUnsavedChanges: aBoolean [

	
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> initialize [

	super initialize.
	
	self
		attachDecorator: SBMoveDecorator new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		addMorphBack: SBRow new;
		addMorphBack: (SBNumberWithPrefix new prefix: 'Position: ');
		addMorphBack: (SBNumberWithPrefix new prefix: 'Limit: ')
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> next [
	<action>
	
	stream next.
	self stream: stream
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> object [

	^ stream
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> objectInterfaceAt: aNumber adding: aBoolean [

	^ aNumber < (self childSandblocks size - 2) ifTrue: [SBInterfaces block] ifFalse: [SBInterfaces never]
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> replace: anObject [

	self stream: anObject
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> reset [
	<action>
	
	stream reset.
	self stream: stream
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> saveTryFixing: aBoolean quick: anotherBoolean [

	stream position: self submorphs second parsedContents.
	self stream: stream.
	^ true
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> stream: aStream [

	| start stop |
	SBExample
		self: [SBPositionableStreamView new]
		args: [
			{
				({1. 2. 3. 4. 5. 8. 12. 2. 14} readStream
					next;
					yourself)
			}]
		label: 'example'.
	stream := aStream.
	self firstSubmorph removeAllMorphs.
	self submorphs second contents: aStream position asString.
	self submorphs third contents: aStream size asString.
	start := aStream position - 5 max: 1.
	stop := aStream position + 5 min: aStream size.
	
	start > 1 ifTrue: [
		self firstSubmorph addMorphBack: (SBStringMorph new contents: '...')].
	aStream originalContents
		from: start
		to: stop
		do: [:item |
			self firstSubmorph addMorphBack: (item anyRepresentationThat: #(#isSandblock))].
	stop < aStream size ifTrue: [
		self firstSubmorph addMorphBack: (SBStringMorph new contents: '...')].
	
	aStream position > 0 ifTrue: [
		((self firstSubmorph submorphs select: #isSandblock) at: (aStream position - start) + 1) attachDecorator: SBErrorDecorator new]
]

{ #category : #'as yet unclassified' }
SBPositionableStreamView >> update [

	self stream: stream
]
