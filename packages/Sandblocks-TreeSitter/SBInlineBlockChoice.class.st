Class {
	#name : #SBInlineBlockChoice,
	#superclass : #SBInlineBlock,
	#instVars : [
		'alternatives'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> alternatives [

	^ alternatives
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> alternatives: aCollection [

	alternatives := aCollection.
	self addMorphBack: (SBTSUnknown new template: self)
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	| index |
	index := anOptions optionAt: self ifAbsentPut: [1].
	^ ((alternatives at: index)
		buildFor: aStream
		matchFullToken: aBoolean
		options: anOptions) ifNotNil: [:result | self veryDeepCopy removeAllMorphs addMorphBack: result]
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildPartial: anOptions with: aString [

	^ (alternatives at: anOptions index)
		buildPartial: anOptions children first
		with: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> deleteTargetFor: aBlock [

	^ self owner deleteTargetFor: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> isUnambiguous [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> printTitleOn: aStream [

	alternatives do: [:m | m printTitleOn: aStream] separatedBy: [aStream nextPutAll: ' | ']
]
