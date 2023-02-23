Class {
	#name : #SBPCMapperTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBPCMapperTest >> example [

	| a i |
	a := [2 ifNotNil: [Transcript showln: 'hello']].
	3 to: 5 do: [i].
	^ a
]

{ #category : #'as yet unclassified' }
SBPCMapperTest >> exampleNestedSends [

	[true ifTrue: [1 yourself squared]]
]

{ #category : #'as yet unclassified' }
SBPCMapperTest >> expectedFailures [

	^ #(#testMapForNestedBlocks)
]

{ #category : #'as yet unclassified' }
SBPCMapperTest >> testMapFor [

	| ast generated generatedStmts stmts |
	ast := (self class >> #example) methodNode.
	generated := (self class >> #example) methodNode
		generate;
		yourself.
	generatedStmts := generated body statements.
	stmts := ast body statements.
	SBPCMapper new applyMappingFor: ast.
	
	self assert: generatedStmts first pc equals: stmts first pc description: 'assignment'.
	
	self assert: stmts first value closureCreationNode pc value ~= 0 description: 'outer block node has pc'.
	self
		assert: generatedStmts first value pc value
		equals: stmts first value pc value
		description: 'outer block node'.
	self
		assert: generatedStmts first value statements first pc value
		equals: stmts first value statements first pc value
		description: 'ifNotNil:'.
	
	self
		assert: generatedStmts first value statements first arguments first pc value
		equals: stmts first value statements first arguments first pc value
		description: 'inner block node'.
	self
		assert: generatedStmts first value statements first arguments first statements first pc value
		equals: stmts first value statements first arguments first statements first pc value
		description: 'showln:'.
	
	self assert: generatedStmts second pc value equals: stmts second pc value description: 'to:by:do:'.
	self
		assert: generatedStmts second arguments second pc value
		equals: stmts second arguments second pc value
		description: 'loop block'.
	
	self assert: generatedStmts third pc value equals: stmts third pc value description: 'return'
]

{ #category : #'as yet unclassified' }
SBPCMapperTest >> testMapForNestedBlocks [

	| ast stmts m |
	m := self class >> #exampleNestedSends.
	m encoderClass supportsFullBlocks ifFalse: [^ self].
	
	ast := m methodNode.
	stmts := ast body statements.
	
	SBPCMapper new applyMappingFor: ast.
	
	self assert: 33 equals: stmts first closureCreationNode pc.
	self assert: 56 equals: stmts first pc value
]
