Class {
	#name : #SBEditorTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBEditorTest >> testActionsWithConditional [

	| block |
	block := SBMockBlock new.
	self methodFor: block.
	self assert: ((block validActions collect: #selector) includes: #mockAction).
	self deny: ((block validActions collect: #selector) includes: #conditionalMockAction).
	block actionValid: true.
	self assert: ((block validActions collect: #selector) includes: #conditionalMockAction)
]

{ #category : #'as yet unclassified' }
SBEditorTest >> testPerformConditionalShortcutFor [

	| editor block |
	block := SBMockBlock new.
	editor := self methodFor: block.
	editor
		shortcutsOverride: {($a asSandblockShortcut -> #conditionalMockAction)};
		performShortcutFor: $a asSandblockShortcut.
	self deny: block mockActionTaken.
	block actionValid: true.
	editor performShortcutFor: $a asSandblockShortcut.
	self assert: block mockActionTaken
]

{ #category : #'as yet unclassified' }
SBEditorTest >> testPerformShortcutFor [

	| block |
	block := SBMockBlock new.
	(self methodFor: block)
		shortcutsOverride: {($a asSandblockShortcut -> #mockAction)};
		performShortcutFor: $a asSandblockShortcut.
	self assert: block mockActionTaken
]
