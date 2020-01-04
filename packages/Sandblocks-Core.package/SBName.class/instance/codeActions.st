as yet unclassified
codeActions

	^ super codeActions, {
		SBCodeAction labeled: 'Use as message send' for: self do: [:node |
			node sandblockEditor do: ((SBReplaceCommand newFor: node containingMethod)
				target: node;
				replacer: (SBMessageSend new receiver: (SBKeywordBinding new contents: 'self') selector: node contents asSymbol);
				yourself)]
	}