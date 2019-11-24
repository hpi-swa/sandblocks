as yet unclassified
codeActions

	^ {
		SBCodeAction
			labeled: 'Change to regular text' for: self do: [:node | node changeHeadingLevel: 0].
		SBCodeAction
			labeled: 'Change to small heading' for: self do: [:node | node changeHeadingLevel: 1].
		SBCodeAction
			labeled: 'Change to medium heading' for: self do: [:node | node changeHeadingLevel: 2].
		SBCodeAction
			labeled: 'Change to large heading' for: self do: [:node | node changeHeadingLevel: 3].
	}, super codeActions