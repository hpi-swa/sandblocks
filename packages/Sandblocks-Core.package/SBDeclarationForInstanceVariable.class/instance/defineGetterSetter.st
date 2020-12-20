as yet unclassified
defineGetterSetter
	<action>

	self block sandblockEditor
		openMorphInView: (SBMethod new
			hasUnsavedChanges: true;
			selector: self contents asSymbol arguments: #() class: self block containingArtefact shownClass;
			body: (SBBlockBody new statements: {
				(SBReturn new expression: (SBName contents: self contents))
			}));
		openMorphInView: (SBMethod new
			hasUnsavedChanges: true;
			selector: self contents asSymbol asSimpleSetter
				arguments: {(SBName contents: 'anObject')}
				class: self block containingArtefact shownClass;
			body: (SBBlockBody new statements: {
				(SBAssignment new binding: (SBName contents: self contents) value: (SBName contents: 'anObject'))
			}))