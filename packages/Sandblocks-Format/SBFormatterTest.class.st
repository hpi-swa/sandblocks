Class {
	#name : #SBFormatterTest,
	#superclass : #TestCase,
	#category : 'Sandblocks-Format'
}

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
