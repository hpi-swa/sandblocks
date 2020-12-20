as yet unclassified
testMapForNestedBlocks

	| ast generated generatedStmts stmts |
	ast := (self class >> #exampleNestedSends) methodNode.
	stmts := ast body statements.
	
	SBPCMapper new applyMappingFor: ast.
	
	self assert: 33 equals: stmts first closureCreationNode pc.
	self assert: 56 equals: stmts first pc value