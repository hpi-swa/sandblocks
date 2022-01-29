Class {
	#name : #SBBlockTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBBlockTest >> testDeepCopy [

	| myBlock editor copy |
	myBlock := SBBlock new.
	editor := self editorFor: myBlock.
	editor when: #selectionChanged send: #update to: myBlock.
	
	self assert: 1 equals: myBlock actionMap size.
	self assert: 1 equals: myBlock veryDeepCopy actionMap size.
	self assert: editor equals: myBlock actionMap anyOne receiver sandblockEditor.
	self assert: nil equals: myBlock veryDeepCopy actionMap anyOne receiver sandblockEditor.
	
	myBlock := SBBlock new.
	myBlock addMorphBack: SBBlock new.
	myBlock firstSubmorph when: #abc send: #test to: myBlock.
	self assert: 1 equals: myBlock firstSubmorph actionMap size.
	copy := myBlock veryDeepCopy.
	self assert: 1 equals: copy firstSubmorph actionMap size.
	self assert: copy equals: copy firstSubmorph actionMap anyOne receiver
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testLeftRotateBinaryMessages [

	| block selection editor |
	block := self parse: '[(a + b) * c]'.
	editor := self methodFor: block.
	selection := block statements first receiver.
	selection leftRotate.
	self assert: block statements first selector = '+'.
	self assert: block statements first receiver contents = 'a'.
	editor undo.
	self assert: block statements first selector = '*'.
	self assert: block statements first receiver receiver contents = 'a'
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testRotateBlock [

	| block selection editor |
	block := self parse: '[a or: [b]]'.
	editor := self methodFor: block.
	selection := block statements first arguments first.
	selection leftRotate.
	self assert: block statements first isBlockBody.
	self assert: 'or:' equals: block statements first statements first selector.
	editor undo.
	self assert: 'or:' equals: block statements first selector.
	self assert: block statements first arguments first isBlockBody
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testRotateKeywordMessage [

	| block selection editor |
	block := self parse: '[(a or: b) ifTrue: c]'.
	editor := self methodFor: block.
	selection := block statements first receiver.
	selection leftRotate.
	self assert: 'or:' equals: block statements first selector.
	self assert: 'a' equals: block statements first receiver contents.
	editor undo.
	self assert: 'ifTrue:' equals: block statements first selector.
	self assert: 'a' equals: block statements first receiver receiver contents
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testSwap [

	| block selection n5 n3 |
	block := self parse: '[5 squared: 3]'.
	self methodFor: block.
	selection := block statements first.
	n5 := selection receiver.
	n3 := selection arguments first.
	n5 swapRight.
	self assert: selection receiver = n3.
	n5 swapRight.
	self assert: selection receiver = n5.
	n5 swapLeft.
	self assert: selection receiver = n3
]
