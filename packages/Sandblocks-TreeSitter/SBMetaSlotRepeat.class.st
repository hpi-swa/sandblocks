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
SBMetaSlotRepeat >> element: anElement [

	element := anElement
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> hash [

	^ multiple hash bitXor: required hash bitXor element hash
]

{ #category : #'as yet unclassified' }
SBMetaSlotRepeat >> morphsIn: aStream do: aBlock [

	| count restore |
	count := 0.
	restore := aStream position.
	[aStream atEnd not and: [(count = 0 or: [self multiple]) and: [element morphsIn: aStream do: [:slot :block | ]]]] whileTrue: [
		aStream position: restore.
		element morphsIn: aStream do: aBlock.
		restore := aStream position.
		aStream next.
		count := count + 1].
	
	aStream position: restore.
	
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
