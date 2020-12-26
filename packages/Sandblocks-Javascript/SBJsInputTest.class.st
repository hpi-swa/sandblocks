Class {
	#name : #SBJsInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Javascript-Tests'
}

{ #category : #'as yet unclassified' }
SBJsInputTest >> editorFor: aBlock [

	| editor |
	editor := SBEditor new useVimInput.
	editor openMorphInView: (SBJsMethod new
		body: aBlock).
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testDeleteDereferenceWithParenthesis [

	| deref unknown editor closure methodCall |
	unknown := SBJsMethodCall new newNullBlock.
	methodCall := SBJsMethodCall new method: (SBJsDereference new lhs: (SBJsVariable new contents: 'a') rhs: 'b') arguments: {unknown}.
	deref := methodCall method.
	editor := self editorFor: methodCall.
	closure := methodCall parentSandblock.
	
	editor startInput: unknown at: 0 replacingContents: true.
	
	editor performForSelection: #deleteBeforeCursor.
	self assert: deref equals: closure statements first.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: (closure statements first contents = 'a').
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testIfKeyword [

	| editor closure var |
	var := SBJsVariable new contents: 'if'.
	editor := self editorFor: var.
	closure := var parentSandblock.
	
	editor startInput: var at: 9e8 replacingContents: false.
	
	editor filterEvent: (self keyboardEvent: Character space) for: nil.
	self assert: ((closure statements first isKindOf: SBJsKeywordBlock) and: [closure statements first contents = 'if']).
	
	editor filterEvent: (self keyboardEvent: $5) for: nil.
	self assert: (closure statements first condition contents = '5')
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testLetKeyword [

	| editor closure var |
	var := SBJsVariable new contents: 'let'.
	editor := self editorFor: var.
	closure := var parentSandblock.
	
	editor startInput: var at: 9e8 replacingContents: false.
	
	editor filterEvent: (self keyboardEvent: Character space) for: nil.
	self assert: (closure statements first isKindOf: SBJsDeclaration).
	
	editor filterEvent: (self keyboardEvent: $a) for: nil.
	editor filterEvent: (self keyboardEvent: $b) for: nil.
	self assert: 'ab' equals: closure statements first binding contents
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testTypeBinaryExpression [

	| editor number closure |
	number := SBJsNumber new contents: '2'.
	editor := self editorFor: number.
	closure := number parentSandblock.
	
	editor startInput: number at: 9e8 replacingContents: false.
	
	editor filterEvent: (self keyboardEvent: $+) for: nil.
	self assert: '+' equals: closure statements first contents.
	
	editor filterEvent: (self keyboardEvent: $3) for: nil.
	self assert: '3' equals: closure statements first rhs contents.
	
	editor filterEvent: (self keyboardEvent: $4) for: nil.
	self assert: '34' equals: closure statements first rhs contents
]
