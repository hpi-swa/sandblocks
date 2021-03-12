Class {
	#name : #SBTextInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTextInputTest >> editorFor: aBlock [

	^ (super editorFor: aBlock) useTextInput
]

{ #category : #'as yet unclassified' }
SBTextInputTest >> testMultiSelection [

	| editor block |
	block := '[3. 3]' parseAsSandblock.
	editor := self editorFor: block.
	
	block statements first startOrAddToMultiSelection.
	block statements second click: (self class mouseEventAt: block statements second center).
	
	self assert: #selection equals: editor mode
]
