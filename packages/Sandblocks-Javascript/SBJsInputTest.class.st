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
SBJsInputTest >> testAddMemberAccess [

	| editor closure access |
	access := SBJsInfixOperator new lhs: (SBJsVariable new contents: 'abc') operator: '.' rhs: (SBJsVariable new contents: 'def').
	editor := self editorFor: access.
	closure := access parentSandblock.
	
	editor startInput: access lhs at: 9e8 replacingContents: false.
	
	editor filterEvent: (self keyboardEvent: $.) for: nil.
	
	self assert: closure statements first contents = '.'
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testAddMemberAccessViaSpace [

	| editor closure access |
	access := SBJsInfixOperator new lhs: (SBJsVariable new contents: 'abc') operator: '.' rhs: (SBJsVariable new contents: 'def').
	editor := self editorFor: access.
	closure := access parentSandblock.
	
	access rhs select.
	
	editor filterEvent: (self keyboardEvent: $ ) for: nil.
	editor filterEvent: (self keyboardEvent: $.) for: nil.
	editor filterEvent: (self keyboardEvent: Character escape) for: nil.
	
	self assert: closure statements first contents = '.'.
	self assert: closure statements first ~= access.
	
	editor undo.
	self assert: closure statements first = access.
	self assert: (closure parentSandblock isKindOf: SBJsMethod)
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testBinaryExprPrecedence [

	| editor number closure |
	number := SBJsNumber new contents: '2'.
	editor := self editorFor: number.
	closure := number parentSandblock.
	
	editor startInput: number at: 900000000 replacingContents: false.
	
	editor filterEvent: (self keyboardEvent: $*) for: nil.
	self assert: '*' equals: closure statements first contents.
	
	editor filterEvent: (self keyboardEvent: $3) for: nil.
	self assert: '3' equals: closure statements first rhs contents.
	
	editor filterEvent: (self keyboardEvent: $+) for: nil.
	self assert: '+' equals: closure statements first contents.
	self assert: '*' equals: closure statements first lhs contents
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testDeleteDereferenceWithParenthesis [

	| deref unknown editor closure methodCall |
	unknown := SBJsMethodCall new newNullBlock.
	methodCall := SBJsMethodCall new
		method: (SBJsInfixOperator new lhs: (SBJsVariable new contents: 'a') operator: '.' rhs: (SBJsVariable new contents: 'b'))
		arguments: {unknown}.
	deref := methodCall method.
	editor := self editorFor: methodCall.
	closure := methodCall parentSandblock.
	
	editor startInput: unknown at: 0 replacingContents: true.
	
	editor performForSelection: #deleteBeforeCursor.
	self assert: deref equals: closure statements first.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: closure statements first contents = 'a'
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testDeleteWithinClosure [

	| deref editor closure unknown innerClosure |
	innerClosure := SBJsClosure new.
	unknown := innerClosure newNullBlock.
	innerClosure arguments: {unknown} statements: {}.
	editor := self editorFor: innerClosure.
	closure := innerClosure parentSandblock.
	
	editor startInput: unknown at: 0 replacingContents: true.
	
	self assert: 1 equals: closure statements size.
	unknown select.
	editor performForSelection: #deleteBeforeCursor.
	self assert: 0 equals: closure statements size
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
