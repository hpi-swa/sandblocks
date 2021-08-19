Class {
	#name : #SBInlineBlockRepeat,
	#superclass : #SBInlineBlock,
	#instVars : [
		'multiple',
		'required',
		'element'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildFor: aString matchFullToken: aBoolean options: anOptions [
	" FIXME: consider actually repeating "

	^ element buildFor: aString matchFullToken: aBoolean options: anOptions
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildPartial: anOptions with: aString [

	^ element buildPartial: anOptions with: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> cursorPositionsDo: aBlock [

	| buildInsert |
	buildInsert := [:adjacent :before |
		aBlock value: (SBCursorInsert new
			command: (SBTSRelInsertCommand new near: adjacent before: before in: self morph: element);
			before: before;
			adjacent: adjacent;
			container: self)].
	
	self inline not ifTrue: [aBlock value: (SBCursorSelect new block: self)].
	(multiple or: [self hasSubmorphs not]) ifTrue: [buildInsert value: nil value: true].
	
	self submorphsDo: [:morph |
		multiple ifTrue: [buildInsert value: morph value: true].
		morph cursorPositionsDo: aBlock.
		multiple ifTrue: [buildInsert value: morph value: false]].
	
	(multiple or: [self hasSubmorphs not]) ifTrue: [buildInsert value: nil value: false]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> deleteTargetFor: aBlock [

	^ (required not or: [self submorphCount > 1])
		ifTrue: [aBlock]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> multiple: aBoolean required: anotherBoolean element: aMorph [

	multiple := aBoolean.
	required := anotherBoolean.
	element := aMorph.
	
	required ifTrue: [self addMorphBack: aMorph veryDeepCopy]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> nonInlinedChildren [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> printTitleOn: aStream [

	element printTitleOn: aStream
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ element triggersFor: aString matchFullToken: aBoolean options: anOptions
]
