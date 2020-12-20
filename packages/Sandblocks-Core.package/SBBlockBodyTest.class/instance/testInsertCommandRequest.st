as yet unclassified
testInsertCommandRequest

	| editor block |
	block := SBBlockBody emptyWithDeclarations: {'a'. 'b'. 'c'}.
	editor := self editorFor: block.
	block statements: {SBNumber new. SBNumber new. SBNumber new}.
	editor do: (block insertCommandRequest: true near: block statements first).
	self assert: block statements second isUnknown