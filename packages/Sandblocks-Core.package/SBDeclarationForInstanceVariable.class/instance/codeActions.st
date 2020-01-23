as yet unclassified
codeActions

	^ super codeActions, {
		(SBCodeAction
			labeled: 'Define getter/setter'
			for: self
			do: [:node | 
				node sandblockEditor openMethod: (SBMethod new
					 selector: node contents asSymbol arguments: #() class: node containingArtefact shownClass;
					 body: (SBBlockBody new statements: {(SBReturn new expression: (SBBinding new contents: node contents))})).
				node sandblockEditor openMethod: (SBMethod new
						selector: node contents asSymbol asSimpleSetter
						arguments: {(SBBinding new contents: 'anObject')}
						class: node containingArtefact shownClass;
					 body: (SBBlockBody new statements: {
						(SBAssignment new binding: (SBBinding new contents: node contents) value: (SBBinding new contents: 'anObject'))
					}))])
	}