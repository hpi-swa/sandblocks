Class {
	#name : #SBFormatterTest,
	#superclass : #TestCase,
	#category : 'Sandblocks-Format'
}

{ #category : #'as yet unclassified' }
SBFormatterTest >> canFormat: aString [

	self
		assert: (SBExampleWatch report: aString for: 533985937)
		equals: (SBExampleWatch report: (SBFormatter formatString: aString class: UndefinedObject noPattern: false) for: 158375538)
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testCommentAtStartOfBlock [

	self canFormat: 'helloWorld

	self halt.
	self do: [:a |
		" start comment "
		self halt.
		" end comment "].
	self halt'
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testCommentOrder [

	self canFormat: 'helloWorld

	3 + 4.
	" hi "
	5 + 6.
	6 + 7'
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testComments [

	self canFormat: 'helloWorld
	" Method Comment "

	self halt'
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testMultilineString [

	| string |
	string := 'test

	self equals: ''a
b
c
d'''.
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testMultilineStringWithIndent [

	| string |
	string := 'test

	true ifTrue: [self equals: ''a
b
c
d'']'.
	
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testNestedComments [

	self canFormat: 'helloWorld

	self halt.
	" line comment "
	self halt'
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testNestedKeywordSend [

	| node root formatter |
	root := Parser new
		parse: 'reportError (signalerContext findContextSuchThat: []) ifNotNil: [:context | ]'
		class: nil class
		noPattern: false
		notifying: nil
		ifFail: nil.
	node := root body statements first originalReceiver.
	formatter := SBFormatter new initForNode: root.
	self assert: (formatter needsParenthesisFor: node)
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testPragmas [

	| string |
	string := 'helloWorld
	<pragma: #(#value1 #value2)>
	<pragma2>
	<pragma: 3 hello: ''abc''>

	self test'.
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testSubexpressionComment [

	self
		assert: 'helloWorld

	3 + 4.
	" comment "'
		equals: (SBFormatter formatString: 'helloWorld

	3 + " comment " 4' class: UndefinedObject noPattern: false)
]

{ #category : #'as yet unclassified' }
SBFormatterTest >> testTrailingComment [

	self canFormat: 'helloWorld

	self halt.
	" start comment "
	self halt.
	" end comment "'
]
