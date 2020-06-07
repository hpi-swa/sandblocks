Class {
	#name : #SBMessageSendTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBMessageSendTest >> testKeywordToUnary [

	| message |
	message := 'self assert: 5' parseAsSandblock.
	self editorFor: message.
	message select.
	message arguments first
		select;
		deleteBlock.
	self assert: message isUnary.
	self assert: 'assert' equals: message selector
]

{ #category : #'as yet unclassified' }
SBMessageSendTest >> testMergeWithParentSend [

	| message |
	message := 'self assert: (5 equals: 6 more: 7)' parseAsSandblock.
	self editorFor: message.
	message arguments first
		select;
		mergeWithParentSend.
	self assert: message selector = 'assert:equals:more:'
]
