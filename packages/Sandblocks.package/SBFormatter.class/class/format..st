as yet unclassified
format: aMethodNode 
	| result formatter |
	SBExample
		self: [SBFormatter]
		args: [{(SBSignature >> #selectorAndEdit:) methodNode}]
		label: 'node test'.
	formatter := self new initForNode: aMethodNode.
	aMethodNode accept: formatter.
	SBExampleWatch report: (result := formatter contents) for: 971329700.
	SBLabel
		text: ['Sanity check to not produce invalid code'].
	self assert: aMethodNode asString = (Parser new parse: result class: aMethodNode methodClass) asString.
	^ result