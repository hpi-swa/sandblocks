Class {
	#name : #SBInputMessageCommand,
	#superclass : #SBCommand,
	#instVars : [
		'previousSelector',
		'previousArguments',
		'messageSend',
		'newSelector',
		'newArguments',
		'select',
		'editInputIndex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> affectedMorphs [

	^ {messageSend}
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> do [

	messageSend selector: newSelector arguments: newArguments.
	^ select ifNil: [messageSend containingSandblock]
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> editInputIndex: aNumber [

	editInputIndex := aNumber
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> hasChange [

	^ previousSelector ~= newSelector or: [(previousArguments hasEqualElements: newArguments) not]
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> messageSend: aBlock [

	messageSend := aBlock
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> newArguments: aCollection [

	newArguments := aCollection
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> newSelector: aString [

	newSelector := aString
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> postDo [

	select ifNil: [select := messageSend containingSandblock].
	
	" if we just changed from unary to keyword message, instead of editing the message edit the new argument "
	(previousSelector asSymbol isUnary and: [newSelector asSymbol isKeyword])
		ifTrue: [
			select sandblockEditor
				select: newArguments first;
				startInput: newArguments first at: 1 replacingContents: false]
		ifFalse: [
			editInputIndex ifNotNil: [
				select sandblockEditor startInput: select at: 1 replacingContents: false.
				select signature focusPartAt: editInputIndex]]
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> previousArguments: aCollection [

	previousArguments := aCollection
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> previousSelector: aString [

	previousSelector := aString
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> select: aMorph [

	select := aMorph
]

{ #category : #'as yet unclassified' }
SBInputMessageCommand >> undo [

	messageSend selector: previousSelector arguments: previousArguments.
	^ messageSend containingSandblock
]
