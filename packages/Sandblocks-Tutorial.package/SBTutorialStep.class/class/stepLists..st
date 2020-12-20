as yet unclassified
stepLists: anEditor

	SBTutorialStep new
		title: 'Lists';
		addIntroText: 'Many elements act as lists, for example arrays, statements in blocks, or even message sends.';
		addAction: #addElement;
		addAction: #insertElementAfter;
		addAction: #insertElementBefore;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [{3. 4. 5}] in: anEditor.
				step
					addStep: 'Select the array element using shift+K'
					checkCondition: [:editor | editor selection isArrayBlock].
				step
					addStep: 'You can append an element to a list by pressing .
Append 6 to the array by pressing dot then typing 6.'
					checkCondition: [:editor |
						method statements first lastSubmorph contents = '6'].
				step
					addStep: 'Add a 1 at the start of the array by selecting the 3 and pressing *'
					checkCondition: [:editor |
						method statements first firstSubmorph contents = '1'].
				step
					addStep: 'Finally, to insert an element after the current, use + and type 2.'
					checkCondition: [:editor |
						method statements first submorphs second contents = '2'].
				step
					addStep: 'There is one special type of insert. Create an empty statement above the array using O.'
					checkCondition: [:editor |
						method statements size > 1 and: [method statements second isArrayBlock]].
				step
					addStep: 'Create an empty statement below the array by first moving the cursor to any number in the array and pressing o.'
					checkCondition: [:editor |
						method statements size > 2 and: [method statements second isArrayBlock]]]