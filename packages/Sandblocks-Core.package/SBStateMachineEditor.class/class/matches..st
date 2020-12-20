as yet unclassified
matches: aNode

	(super matches: aNode) ifFalse: [^ false].

	^ aNode isCascade and: [aNode receiver isMessageSend and: [aNode receiver receiver isName and: [aNode receiver receiver contents = 'SBStateMachine' and: [aNode receiver selector = 'new']]]]