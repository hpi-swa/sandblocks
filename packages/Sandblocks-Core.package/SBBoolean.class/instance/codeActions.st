as yet unclassified
codeActions

	^ {(SBCodeAction labeled: 'Toggle' for: self block do: [:node | node behavior toggle])}