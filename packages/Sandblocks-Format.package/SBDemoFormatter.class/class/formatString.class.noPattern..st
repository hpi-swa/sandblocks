as yet unclassified
formatString: aString class: aClass noPattern: aBoolean

	| formatter node methodNode |
	SBExample
		self: [SBDemoFormatter]
		args: [
			{'testMethod
  {$a.$b.$c.$d.$e.$f.$g.$h.$i.$j}'. UndefinedObject. false}]
		label: 'brace node long'.
	node := self nodeFrom: aString class: aClass noPattern: aBoolean.
	formatter := self new initForNode: node.
	node accept: formatter.
	^ formatter contents