Class {
	#name : #SBInlineBlockChoice,
	#superclass : #SBInlineBlock,
	#instVars : [
		'alternatives'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> alternatives: aCollection [

	alternatives := aCollection.
	self addMorphBack: (SBTSUnknown new template: self)
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

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> triggersFor: aStream matchFullToken: aBoolean options: anOptions [

	| anyMatch |
	anyMatch := false.
	alternatives withIndexDo: [:alternative :index |
		(anOptions add: index if: [:option | | restore ret |
			restore := aStream position.
			ret := alternative triggersFor: aStream matchFullToken: aBoolean options: option.
			aStream position: restore]) ifTrue: [anyMatch := true]].
	^ anyMatch
]
