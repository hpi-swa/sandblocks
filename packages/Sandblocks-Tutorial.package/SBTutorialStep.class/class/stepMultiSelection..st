as yet unclassified
stepMultiSelection: anEditor

	SBTutorialStep new
		title: 'Multi Selection';
		addIntroText: 'You can multiselect elements with a dedicated selection mode. Many commands will then act on all elements at once.';
		addAction: #addElement;
		addAction: #wrapInDynamicArray;
		addAction: #unpackList;
		addAction: #addElement;
		addAction: #promptAction;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [
					3 yourself.
					4 squared.
					5] in: anEditor.
				step
					addStep: 'Select the `3 yourself` and press v.'
					checkCondition: [:editor |
						editor mode = #selection and: [editor multiSelection first selector = 'yourself']].
				step
					addStep: 'Navigate to the `4 squared` and press v again to add it to your multi selection.'
					checkCondition: [:editor | editor multiSelection last selector = 'squared'].
				step
					addStep: 'Navigate to the 5 and press v.'
					checkCondition: [:editor | editor multiSelection last contents = '5'].
				step
					addStep: 'Press { to wrap your multi selection in an array.'
					checkCondition: [:editor | method statements first isArrayBlock].
				step
					addStep: 'Add a 6 to the array using .'
					checkCondition: [:editor |
						method statements first submorphCount = 4 and: [
							method statements first lastSubmorph contents = '6']].
				step
					addStep: 'Finally, you can unpack the array again using the unpackAsStatements command. It is not bound to a shortcut by default, so to access it select the array and press , (comma) to see all available commands and filter for unpack.'
					checkCondition: [:editor | method statements size = 4]]