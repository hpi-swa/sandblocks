as yet unclassified
codeActions

	^ super codeActions, {
		SBCodeAction labeled: 'Add initialize' for: self do: [:node |
			node sandblockEditor openMorphInView:(SBMethod new
				selector: 'initialize' arguments: #() class: node shownClass;
				hasUnsavedChanges: true;
				body: (SBBlockBody new
					statements: {
						SBMessageSend new
							receiver: (SBKeywordBinding new contents: 'super') selector: 'initialize' arguments: #()}))]
	}