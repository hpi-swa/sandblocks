as yet unclassified
codeActions

	^super codeActions, {SBCodeAction
		labeled: 'Show as Message Send'
		for: self
		do: #replaceWithMessageSend}