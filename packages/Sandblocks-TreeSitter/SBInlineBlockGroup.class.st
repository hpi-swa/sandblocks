Class {
	#name : #SBInlineBlockGroup,
	#superclass : #SBInlineBlock,
	#instVars : [
		'elements'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	| copy |
	copy := self veryDeepCopy removeAllMorphs.
	elements withIndexDo: [:element :index |
		(element buildFor: aStream matchFullToken: aBoolean options: anOptions)
			ifNotNil: [:morph | copy addMorphBack: morph]
			ifNil: [^ nil].
		aStream atEnd ifTrue: [
			index + 1
				to: self submorphCount
				do: [:next | copy addMorphBack: (elements at: next) veryDeepCopy].
			^ copy]].
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> buildPartial: anOptions with: aString [

	^ SBInlineBlockGroup new elements: {elements first buildPartial: anOptions with: aString}, (elements viewAllButFirst collect: [:element | element veryDeepCopy])
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> elements: aCollection [

	self addAllMorphsBack: (elements := aCollection)
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> printTitleOn: aStream [

	self submorphs do: [:m | m printTitleOn: aStream] separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> triggersFor: aStream matchFullToken: aBoolean options: anOptions [

	elements do: [:element |
		(element triggersFor: aStream matchFullToken: aBoolean options: anOptions) ifFalse: [^ false].
		aStream atEnd ifTrue: [^ true]].
	^ true
]
