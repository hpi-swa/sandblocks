Class {
	#name : #SBMetaSlotRepeat,
	#superclass : #SBMetaSlot,
	#instVars : [
		'required',
		'multiple',
		'element'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> = aSlot [

	^ super = aSlot and: [aSlot multiple = self multiple and: [self required = aSlot required]]
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> buildFor: aMorph [

	required ifTrue: [element buildFor: aMorph]
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> buildPartialFor: aMorph option: anOption with: aString [

	^ element buildPartialFor: aMorph option: anOption with: aString
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> canDeleteChild: aBlock in: aStream [

	self morphsIn: aStream do: [:slot :morphs | (morphs includes: aBlock) and: [slot = element]].
	^ false
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> cursorPositionsIn: aStream factory: aFactory do: aBlock [

	| count buildInsert previous |
	buildInsert := [:adjacent :before |
		aBlock value: (SBCursorInsert new
			command: (SBMetaRelInsertCommand new
				near: adjacent
				before: before
				in: aStream contents anyOne owner
				factory: aFactory
				slot: self);
			before: before;
			adjacent: adjacent;
			container: aStream contents anyOne owner)].
	
	count := 0.
	[aStream atEnd not and: [(count = 0 or: [self multiple]) and: [element checkValidIn: aStream]]] whileTrue: [
		multiple ifTrue: [buildInsert value: aStream peek value: true].
		element cursorPositionsIn: aStream factory: aFactory do: aBlock.
		count := count + 1].
	
	previous := aStream position > 0 ifTrue: [aStream last] ifFalse: [nil].
	count = 0
		ifTrue: [buildInsert value: previous value: false]
		ifFalse: [multiple ifTrue: [buildInsert value: previous value: false]].
	
	^ count > 0 or: [required not]
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> element: anElement [

	element := anElement.
	anElement parent: self
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> hash [

	^ multiple hash bitXor: required hash bitXor element hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> morphsIn: aStream do: aBlock [

	| count |
	count := 0.
	[aStream atEnd not and: [(count = 0 or: [self multiple]) and: [element checkValidIn: aStream]]] whileTrue: [
		element morphsIn: aStream do: aBlock.
		count := count + 1].
	
	^ count > 0 or: [required not]
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> multiple [

	^ multiple
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> multiple: aBoolean [

	multiple := aBoolean
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> printTitleOn: aStream [

	aStream print: element.
	aStream nextPut: ((required not and: [multiple not])
		ifTrue: [$?]
		ifFalse: [required ifTrue: [$+] ifFalse: [$*]])
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> required [

	^ required
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> required: aBoolean [

	required := aBoolean
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> takeFrom: aCursor for: aMorph [

	| count |
	count := 0.
	[aCursor atEnd not and: [(count = 0 or: [self multiple]) and: [element takeFrom: aCursor for: aMorph]]] whileTrue: [count := count + 1].
	
	^ count > 0 or: [required not]
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> triggersFor: aString matchFullToken: aBoolean do: aBlock [

	^ element triggersFor: aString matchFullToken: aBoolean do: aBlock
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> validIn: aStream [

	| count restore |
	count := 0.
	restore := aStream position.
	[aStream atEnd not and: [(count = 0 or: [self multiple]) and: [element validIn: aStream]]] whileTrue: [
		restore := aStream position.
		count := count + 1].
	
	aStream position: restore.
	
	^ count > 0 or: [self required not]
]
