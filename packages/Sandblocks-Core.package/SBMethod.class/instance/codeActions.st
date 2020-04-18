as yet unclassified
codeActions

	^ super codeActions, {
		SBCodeAction
			labeled: 'Reload Method'
			for: self
			do: [:node | self sandblockEditor select: (self replaceBy: (self compiledMethod asSandblock position: self position))]
	}