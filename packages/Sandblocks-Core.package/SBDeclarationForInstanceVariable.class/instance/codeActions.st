as yet unclassified
codeActions

	^ super codeActions, {
		(SBCodeAction
			labeled: 'Define getter/setter'
			for: self block
			do: [:node | 
				node sandblockEditor openMorphInView: (SBMethod new
					 selector: node contents asSymbol arguments: #() class: node containingArtefact shownClass;
					 body: (SBBlockBody new statements: {(SBReturn new expression: (SBName contents: node contents))})).
				node sandblockEditor openMorphInView: (SBMethod new
						selector: node contents asSymbol asSimpleSetter
						arguments: {(SBName contents: 'anObject')}
						class: node containingArtefact shownClass;
					 body: (SBBlockBody new statements: {
						(SBAssignment new binding: (SBName contents: node contents) value: (SBName contents: 'anObject'))
					}))])
	}