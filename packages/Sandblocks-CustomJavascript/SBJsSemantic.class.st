Class {
	#name : #SBJsSemantic,
	#superclass : #OhmSemanticAction,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsSemantic >> ArrowFunction: aNode open: x parameters: aCollection close: xx arrow: xxx body: body [

	| statements |
	statements := self value: body.
	^ SBJsClosure new
		arguments: (self value: aCollection)
		statements: (statements isCollection ifTrue: [statements] ifFalse: [statements ifNil: [#()] ifNotNil: [{statements}]])
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> Declaration: aNode type: type name: name eq: eq expr: expression [

	^ SBJsDeclaration new
		binding: (self value: name) value: (self value: expression) declarationType: type interval contents
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> DirectMemberAccess: aNode lhs: lhs dot: x rhs: rhs [

	^ SBJsInfixOperator new lhs: (self value: lhs) operator: '.' rhs: (self value: rhs)
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> Expression: aNode expression: expression [

	^ self value: expression
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> ExpressionWithBraces: aNode open: x expression: expression close: xx [

	^ self value: expression
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> File: aNode with: statements [

	^ SBJsModule new
		statements: (statements children collect: [:statement |
			self value: statement] thenSelect: #notNil);
		yourself
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> Function: aNode keyword: keyword open: x parameters: aCollection close: xx body: body [

	^ SBJsClosure new
		arguments: (self value: aCollection)
		statements: (self value: body)
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> InfixOp: aNode lhs: lhs operator: operator rhs: rhs [

	^ SBJsInfixOperator new lhs: (self value: lhs) operator: operator interval contents rhs: (self value: rhs)
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> KeywordBlock: aNode keyword: keyword par: x expressions: expressions par: xx body: body [

	| statements |
	statements := self value: body.
	^ SBJsKeywordBlock new
		keyword: keyword interval contents;
		header: ((self value: expressions) select: #isSandblock);
		statements: (statements isCollection ifTrue: [statements] ifFalse: [statements ifNil: [#()] ifNotNil: [{statements}]])
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> KeywordBody: aNode body: body [

	^ self value: body
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> KeywordBodyWithBraces: aNode open: x statements: aCollection close: xx [

	^ aCollection children collect: [:c | self value: c] thenSelect: #notNil
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> ListOf: aNode collection: aCollection [

	^ (aCollection children collect: [:o | self value: o]) flatten select: #isSandblock
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> MemberAccess: aNode access: access [

	^ self value: access
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> MethodCall: aNode method: method open: x parameters: parameters close: xx [

	^ SBJsInfixOperator new lhs: (self value: method) operator: '(' rhs: (self value: parameters)
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> PrefixOp: aNode operator: operator expression: expression [

	^ SBJsPrefixOperator new
		operator: operator interval contents rhs: (self value: expression)
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> SimpleExpression: aNode expression: expression [

	^ self value: expression
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> SimpleStatement: aNode statement: statement term: x [

	^ self value: statement
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> Statement: aNode statement: statement [

	^ self value: statement
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> emptyStatement: aNode statement: statement [

	^ nil
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> lineGap: aNode gap: x [

	^ SBUnknown new grammarHandler: SBJsGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> literal: aNode literal: literal [

	^ self value: literal
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> name: aNode name: name [

	^ SBJsVariable new contents: name interval contents
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> number: aNode negative: x prefix: prefix sep: sep decimal: decimal [

	^ SBJsNumber new contents: aNode interval contents
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> simpleExpression: aNode expression: expression terminate: x [

	^ self value: expression
]

{ #category : #'as yet unclassified' }
SBJsSemantic >> string: aNode open: x content: content close: xx [

	^ SBJsString new contents: content interval contents
]
