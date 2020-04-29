as yet unclassified
codeActions

	^ super codeActions, {
		SBCodeAction labeled: 'Use as message send' for: self block do: [:node |
			node sandblockEditor do: ((SBReplaceCommand newFor: node containingArtefact)
				target: node;
				replacer: (SBMessageSend new receiver: (SBName contents: 'self') selector: node contents asSymbol);
				yourself)]
	}