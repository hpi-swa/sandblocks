as yet unclassified
matches: aNode

	^ aNode isCascade and: [aNode receiver isMessageSend and: [aNode receiver receiver isName and: [aNode receiver receiver contents = 'TOMStateMachine' and: [aNode receiver selector = 'new']]]]