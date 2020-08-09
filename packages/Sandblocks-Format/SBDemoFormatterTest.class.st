Class {
	#name : #SBDemoFormatterTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Format'
}

{ #category : #'as yet unclassified' }
SBDemoFormatterTest >> testMultilineString [

	| string |
	string := 'test

	self equals: ''a
b
c
d'''.
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)
]

{ #category : #'as yet unclassified' }
SBDemoFormatterTest >> testMultilineStringWithIndent [

	| string |
	string := 'test

	true ifTrue: [self equals: ''a
b
c
d'']'.
	
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)
]

{ #category : #'as yet unclassified' }
SBDemoFormatterTest >> testNestedKeywordSend [

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
SBDemoFormatterTest >> testPragmas [

	| string |
	string := 'helloWorld
	<pragma: #(#value1 #value2)>
	<pragma2>
	<pragma: 3 hello: ''abc''>

	self test'.
	self assert: string equals: (SBFormatter formatString: string class: UndefinedObject noPattern: false)
]
