as yet unclassified
codeActions

	^ super codeActions, (SBSubstitution allSubclasses
		select: [:substition | substition matchesCascades and: [substition matches: self]]
		thenCollect: [:substitution | 
			SBCodeAction
				labeled: 'Convert to ', substitution name
				for: self
				do: [:node | 
					node sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
						target: node;
						replacer: ((substitution newFrom: self) pc: self pc))]])