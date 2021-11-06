Class {
	#name : #SBJsInputTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-CustomJavascript-Tests'
}

{ #category : #'as yet unclassified' }
SBJsInputTest >> methodFor: aBlock [

	| editor |
	editor := SBEditor new useVimInput.
	editor openMorphInView: (SBJsModule new
		body: aBlock).
	aBlock select.
	^ editor
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testAddMemberAccess [

	| editor closure access |
	access := SBJsInfixOperator new lhs: (SBJsVariable new contents: 'abc') operator: '.' rhs: (SBJsVariable new contents: 'def').
	editor := self methodFor: access.
	closure := access parentSandblock.
	
	editor startInput: access lhs at: 9e8 replacingContents: false.
	
	self send: (self keyboardEvent: $.) to: editor.
	
	self assert: closure statements first contents = '.'
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testAddMemberAccessViaSpace [

	| editor closure access |
	access := SBJsInfixOperator new lhs: (SBJsVariable new contents: 'abc') operator: '.' rhs: (SBJsVariable new contents: 'def').
	editor := self methodFor: access.
	closure := access parentSandblock.
	
	access rhs select.
	
	self send: (self keyboardEvent: $ ) to: editor.
	self send: (self keyboardEvent: $.) to: editor.
	self send: (self keyboardEvent: Character escape) to: editor.
	
	self assert: '.' equals: closure statements first contents.
	self assert: closure statements first ~= access.
	
	editor undo.
	self assert: closure statements first = access
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testBinaryExprPrecedence [

	| editor number closure |
	number := SBJsNumber new contents: '2'.
	editor := self methodFor: number.
	closure := number parentSandblock.
	
	editor startInput: number at: 900000000 replacingContents: false.
	
	self send: (self keyboardEvent: $*) to: editor.
	self assert: '*' equals: closure statements first contents.
	
	self send: (self keyboardEvent: $3) to: editor.
	self assert: '3' equals: closure statements first rhs contents.
	
	self send: (self keyboardEvent: $+) to: editor.
	self assert: '+' equals: closure statements first contents.
	self assert: '*' equals: closure statements first lhs contents
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testDeleteDereferenceWithParenthesis [

	| deref unknown editor closure methodCall |
	unknown := SBJsASTNode new newNullBlock.
	methodCall := SBJsInfixOperator new
		lhs: (SBJsInfixOperator new lhs: (SBJsVariable new contents: 'a') operator: '.' rhs: (SBJsVariable new contents: 'b'))
		operator: '('
		rhs: unknown.
	deref := methodCall lhs.
	editor := self methodFor: methodCall.
	closure := methodCall parentSandblock.
	
	editor startInput: unknown at: 0 replacingContents: true.
	
	editor performForSelection: #deleteBeforeCursor.
	self assert: methodCall equals: editor selection.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: deref equals: closure statements first.
	self assert: 'b' equals: editor selection contents.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: 'a' equals: closure statements first contents.
	self assert: closure statements first isSelected
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testDeleteWithinClosure [

	| editor closure unknown innerClosure |
	innerClosure := SBJsClosure new.
	unknown := innerClosure newNullBlock.
	innerClosure arguments: {unknown} statements: {}.
	editor := self methodFor: innerClosure.
	closure := innerClosure parentSandblock.
	
	editor startInput: unknown at: 0 replacingContents: true.
	
	self assert: 1 equals: closure statements size.
	editor performForSelection: #deleteBeforeCursor.
	self assert: closure statements first isUnknown
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testIfKeyword [

	| editor closure var |
	var := SBJsVariable new contents: 'if'.
	editor := self methodFor: var.
	closure := var parentSandblock.
	
	editor startInput: var at: 9e8 replacingContents: false.
	
	self send: (self keyboardEvent: $ ) to: editor.
	self assert: ((closure statements first isKindOf: SBJsKeywordBlock) and: [closure statements first contents = 'if']).
	
	self send: (self keyboardEvent: $5) to: editor.
	self assert: (closure statements first condition contents = '5')
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testLetKeyword [

	| editor closure var |
	var := SBJsVariable new contents: 'let'.
	editor := self methodFor: var.
	closure := var parentSandblock.
	
	editor startInput: var at: 9e8 replacingContents: false.
	
	self send: (self keyboardEvent: $ ) to: editor.
	self assert: (closure statements first isKindOf: SBJsDeclaration).
	
	self send: (self keyboardEvent: $a) to: editor.
	self send: (self keyboardEvent: $b) to: editor.
	self assert: 'ab' equals: closure statements first binding contents
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testMoveCursorInInfixOp [

	| editor op closure |
	op := SBJsInfixOperator new
		lhs: (SBJsNumber new contents: '2')
		operator: '+'
		rhs: (SBJsNumber new contents: '2').
	editor := (self methodFor: op) useTextInput.
	closure := op parentSandblock.
	
	editor startInput: op rhs at: 1 replacingContents: false.
	self assert: op rhs isSelected.
	
	self send: (self keyboardEvent: Character arrowLeft) to: editor.
	self send: (self keyboardEvent: Character arrowLeft) to: editor.
	self assert: op isSelected.
	
	self send: (self keyboardEvent: Character arrowLeft) to: editor.
	self assert: op lhs isSelected
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testPrecedenceAdaptAfterFunctionCall [

	| call editor |
	call := SBJsInfixOperator new lhs: (SBJsVariable new contents: 'abc') operator: '(' rhs: (SBJsVariable new contents: 'a').
	editor := self methodFor: call.
	
	editor startInput: call rhs at: 900000000 replacingContents: false.
	self send: (self keyboardEvent: $.) to: editor.
	self assert: (call rhs isKindOf: SBJsInfixOperator)
]

{ #category : #'as yet unclassified' }
SBJsInputTest >> testTypeBinaryExpression [

	| editor number closure |
	number := SBJsNumber new contents: '2'.
	editor := self methodFor: number.
	closure := number parentSandblock.
	
	editor startInput: number at: 9e8 replacingContents: false.
	
	self send: (self keyboardEvent: $+) to: editor.
	self assert: '+' equals: closure statements first contents.
	
	self send: (self keyboardEvent: $3) to: editor.
	self assert: '3' equals: closure statements first rhs contents.
	
	self send: (self keyboardEvent: $4) to: editor.
	self assert: '34' equals: closure statements first rhs contents
]
