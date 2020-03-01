errors
reportError: anError

	| editor ctx i |
	self
		clearErrors;
		displayError: anError.
	
	editor := self sandblockEditor.
	i := 1.
	ctx := anError signalerContext.
	[ctx] whileNotNil: [
		" error was during our example case setup, locate the correct expression from the DoIt "
		ctx method = (SBMorphExampleCase >> #evaluateFor:in:) ifTrue: [ | caseBlock doItCtx |
			caseBlock := self cases first caseBlock.
			doItCtx := anError signalerContext stack at: i - 3.
			" this 73 currently is a mystery, but maybe it's caseBlock pc - doItCtx method initialPC ? further investigation needed "
			(caseBlock containingArtefact blockForPC: doItCtx pc + 73)  ifNotNil: [:b |
				b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
			^ self].
		
		" error was elsewhere, see if we have an open artefact with this context "
		editor
			methodForContext: ctx
			ifOpen: [:method |
				(method blockForPC: ctx previousPc) ifNotNil: [:b |
					b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
				^ self]
			ifClosed: [false].
		ctx := ctx sender.
		i := i + 1]