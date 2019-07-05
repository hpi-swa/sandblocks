actions
compiledMethod: aMethod

	| methodNode |
	methodNode := aMethod methodNode"Parser new parse: aMethod getSource class: aMethod methodClass".
	" fill out pc "
	methodNode generateWithTempNames.
	
	self method: methodNode asSandblock.
	(self ownerThatIsA: SystemWindow) ifNotNil: [:w | w extent: 0 @ 0]