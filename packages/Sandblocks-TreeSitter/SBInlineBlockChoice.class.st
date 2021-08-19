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
SBInlineBlockChoice >> ambiguitiesOn: aStream [

	self submorphCount > 1 ifTrue: [aStream nextPut: self].
	super ambiguitiesOn: aStream
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	| copy |
	copy := nil.
	alternatives do: [:alternative | | restore |
		" FIXME: we have to continue with different streams here,
 as each option could take a different number of chars "
		restore := aStream position.
		(alternative buildFor: aStream matchFullToken: aBoolean options: anOptions) ifNotNil: [:result | ^ (copy ifNil: [copy := self veryDeepCopy removeAllMorphs]) addMorphBack: result].
		SBToggledCode comment: '' active: 0 do: {[aStream position: restore]}].
	^ copy
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
