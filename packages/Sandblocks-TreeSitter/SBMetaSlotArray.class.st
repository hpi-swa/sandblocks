Class {
	#name : #SBMetaSlotArray,
	#superclass : #Object,
	#instVars : [
		'slots'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> at: aNumber [

	| index |
	index := 1.
	slots do: [:slot |
		index = aNumber ifTrue: [^ slot].
		index := index + slot count].
	^ self errorSubscriptBounds: aNumber
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> cursorPositionsWith: aSubmorphCollection in: aParent do: aBlock [

	| index buildInsert |
	index := 1.
	
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
	
	slots do: [:slot |
		slot count timesRepeat: [ | morph |
			morph := aSubmorphCollection at: index.
			slot objectInterface ifNotNil: [
				slot multiple ifTrue: [buildInsert value: morph value: true value: slot].
				Transcript showln: morph.
				morph cursorPositionsDo: aBlock.
				slot multiple ifTrue: [buildInsert value: morph value: false value: slot]].
			index := index + 1].
		
		slot count = 0 ifTrue: [
			aSubmorphCollection
				at: index - 1
				ifPresent: [:m | buildInsert value: m value: false value: slot]
				ifAbsent: [buildInsert value: nil value: true value: slot]]]
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> named: aString [

	^ slots detect: [:slot | slot name = aString]
]

{ #category : #'as yet unclassified' }
SBMetaSlotArray >> slots: aCollection [

	aCollection do: [:slot | slot setInitialCount].
	slots := aCollection
]
