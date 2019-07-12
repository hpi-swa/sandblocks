actions
promptCodeAction

	self selection codeActions ifNotEmpty: [:actions | self method proposeCodeActions: actions for: self selection]