actions
compiledMethod: aMethod

	self method: (Parser new parse: aMethod getSource class: aMethod methodClass) asSandblock