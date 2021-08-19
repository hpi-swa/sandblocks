Class {
	#name : #SBMetaSlotArray,
	#superclass : #Object,
	#instVars : [
		'slots'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> cursorPositionsWith: aSubmorphCollection in: aParent do: aBlock [

	| buildInsert |
	buildInsert := [:adjacent :before :slot |
		aBlock value: (SBCursorInsert new
			command: (SBMetaRelInsertCommand new
				near: adjacent
				before: before
				in: aParent
				factory: aParent factory
				slot: slot);
			before: before;
			adjacent: adjacent;
			container: aParent)].
	
	self slotsIn: aParent do: [:slot :morphs :previousMorph |
		morphs do: [:morph |
			slot isBlockSlot ifTrue: [
				slot multiple ifTrue: [buildInsert value: morph value: true value: slot].
				morph cursorPositionsDo: aBlock.
				slot multiple ifTrue: [buildInsert value: morph value: false value: slot]].
			
			morph isTextMorph ifTrue: [
				morph containingSandblock startInputCommand ifNotNil: [:command |
					aBlock value: (SBCursorText new
						block: morph containingSandblock;
						currentCommand: command)]]].
		
		morphs ifEmpty: [
			previousMorph
				ifNotNil: [:m | buildInsert value: m value: false value: slot]
				ifNil: [buildInsert value: nil value: true value: slot]]]
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> do: aBlock [

	slots do: aBlock
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> named: aString [

	^ slots detect: [:slot | slot name = aString]
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> readStream [

	^ slots readStream
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slotOf: aMorph in: aParent do: aBlock [

	self
		slotsIn: aParent
		do: [:slot :morphs :p | (morphs includes: aMorph) ifTrue: [^ aBlock value: slot value: morphs]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slots [

	^ slots
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slots: aCollection [

	slots := aCollection
]