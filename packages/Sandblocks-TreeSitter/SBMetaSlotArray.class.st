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
				objectInterface: slot objectInterface);
			before: before;
			adjacent: adjacent;
			container: aParent)].
	
	self slotsIn: aParent do: [:slot :morphs :previousMorph |
		morphs do: [:morph |
			slot objectInterface ifNotNil: [
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
SBMetaSlotArray >> named: aString [

	^ slots detect: [:slot | slot name = aString]
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slotOf: aMorph in: aParent do: aBlock [

	self
		slotsIn: aParent
		do: [:slot :morphs :p | (morphs includes: aMorph) ifTrue: [^ aBlock value: slot value: morphs]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slots: aCollection [

	slots := aCollection
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slotsIn: aMorph do: aBlock [

	| stream previousMorph factory |
	stream := aMorph submorphs readStream.
	factory := aMorph factory.
	previousMorph := nil.
	slots do: [:slot | | morphs |
		morphs := OrderedCollection new.
		
		slot multiple
			ifTrue: [[stream atEnd not and: [factory type: stream peek objectInterface compatibleWith: slot objectInterface]] whileTrue: [morphs add: stream next]]
			ifFalse: [(stream atEnd not and: [factory type: stream peek objectInterface compatibleWith: slot objectInterface]) ifTrue: [morphs add: stream next]].
		
		slot required ifTrue: [self assert: morphs notEmpty].
		aBlock value: slot value: morphs value: previousMorph.
		morphs ifNotEmpty: [previousMorph := morphs last]]
]
