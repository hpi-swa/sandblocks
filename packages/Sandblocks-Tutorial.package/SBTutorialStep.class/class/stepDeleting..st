as yet unclassified
stepDeleting: anEditor

	SBTutorialStep new
		title: 'Deleting';
		addAction: #deleteBlock;
		addAction: #pasteAbove;
		addAction: #pasteBelow;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [{1. 2. 6. 3. 4. 5}] in: anEditor.
				step
					addStep: 'Delete the 6 in the list by pressing x'
					checkCondition: [:editor |
						method body statements first submorphs noneSatisfy: [:el | el contents = '6']].
				step
					addStep: 'A deleted element is automatically copied. Paste it at the end of the list using p.'
					checkCondition: [:editor |
						method body statements first lastSubmorph contents = '6'].
				step
					addStep: 'Paste the 6 again at the start of the list using P'
					checkCondition: [:editor |
						method body statements first firstSubmorph contents = '6']]