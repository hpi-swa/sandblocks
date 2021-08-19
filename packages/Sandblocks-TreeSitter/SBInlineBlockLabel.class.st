Class {
	#name : #SBInlineBlockLabel,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildPartial: anOptions with: aString [

	^ self veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> initialize [

	super initialize.
	
	self addMorphBack: (SBStringMorph new contents: '')
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> isUnambiguous [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> label [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> label: aString [

	self firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> printTitleOn: aStream [

	aStream nextPutAll: self label
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ anOptions
		addLeaf: self
		if: [:option | aBoolean ifTrue: [self label = aString] ifFalse: [self label beginsWith: aString]]
]
