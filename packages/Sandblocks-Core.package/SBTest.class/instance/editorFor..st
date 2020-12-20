as yet unclassified
editorFor: aBlock

	| editor |
	editor := SBEditor new useVimInput.
	editor openMorphInView: (SBMethod new
		selector: #test arguments: #() class: nil class;
		body: (SBBlockBody new statements: {aBlock})).
	aBlock select.
	^ editor