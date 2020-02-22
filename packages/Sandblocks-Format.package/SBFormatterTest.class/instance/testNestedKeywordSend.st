as yet unclassified
testNestedKeywordSend

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