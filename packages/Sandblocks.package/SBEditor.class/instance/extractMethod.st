actions
extractMethod

	| selector localBindings |
	selector := (SBRequestSelector openForSnippet: self selection) ifNil: [^ self].
	localBindings := self selection resolveLocalBindings.
	self do: (SBReplaceCommand new
		target: self selection;
		replacer: (SBMessageSend new
			receiver: (SBKeywordBinding new name: 'self')
			selector: selector
			arguments: localBindings veryDeepCopy))