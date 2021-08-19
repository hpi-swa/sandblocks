Class {
	#name : #SBInlineBlockGroup,
	#superclass : #SBInlineBlock,
	#instVars : [
		'elements'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> buildPartial: anOptions with: aString [

	^ SBInlineBlockGroup new elements: {elements first buildPartial: anOptions with: aString}, (elements viewAllButFirst collect: [:element | element veryDeepCopy])
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> currentTextMorph [

	elements do: [:element | element currentTextMorph ifNotNil: [:m | ^ m]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> elements: aCollection [

	self addAllMorphsBack: (elements := aCollection)
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> printTitleOn: aStream [

	self submorphs do: [:m | m printTitleOn: aStream] separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #'as yet unclassified' }
SBInlineBlockGroup >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ self firstSubmorph triggersFor: aString matchFullToken: aBoolean options: anOptions
]
