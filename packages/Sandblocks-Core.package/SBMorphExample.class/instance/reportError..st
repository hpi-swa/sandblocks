as yet unclassified
reportError: anError

	| editor |
	self clearErrors.
	
	editor := self sandblockEditor.
	anError signalerContext findContextSuchThat: [:ctx |
		editor
			methodForContext: ctx
			ifOpen: [:method |
				(method blockForPC: ctx previousPc) ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)].
				^ self]
			ifClosed: [false]]