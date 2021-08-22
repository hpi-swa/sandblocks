Class {
	#name : #SBInlineBlockSequence,
	#superclass : #SBInlineBlock,
	#instVars : [
		'elements'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

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
SBInlineBlockSequence >> buildIn: aMorph info: anObject [

	| copy |
	aMorph addMorphBack: (copy := self veryDeepCopy removeAllMorphs).
	self elements withIndexDo: [:element :index |
		element buildIn: copy info: anObject.
		anObject atEnd ifTrue: [
			index + 1
				to: self submorphCount
				do: [:next | copy addMorphBack: (elements at: next) veryDeepCopy].
			anObject success]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildPartial: anOptions with: aString [

	^ SBInlineBlockSequence new elements: {elements first buildPartial: anOptions with: aString}, (elements viewAllButFirst collect: [:element | element veryDeepCopy])
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> elements [

	^ elements
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> elements: aCollection [

	self addAllMorphsBack: (elements := aCollection)
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> printTitleOn: aStream [

	self submorphs do: [:m | m printTitleOn: aStream] separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> triggersFor: aStream matchFullToken: aBoolean options: anOptions [

	elements do: [:element |
		(element triggersFor: aStream matchFullToken: aBoolean options: anOptions) ifFalse: [^ false].
		aStream atEnd ifTrue: [^ true]].
	^ true
]
