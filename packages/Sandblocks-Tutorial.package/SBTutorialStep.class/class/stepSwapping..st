as yet unclassified
stepSwapping: anEditor

	SBTutorialStep new
		title: 'Swapping';
		addIntroText: 'In a text editor, you usually move code by copy-pasting. Here, you can also use swap commands directly.';
		addAction: #swapLeft;
		addAction: #swapRight;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [
					{1. 2. 3. 6. 4. 5}.
					self assert: (10 raisedTo: 2) = 1024] in: anEditor.
				step addStep: 'Select the 6 in the array' checkCondition: [:editor | editor selection contents = '6'].
				step
					addStep: 'Using L, move it to the end of the array.'
					checkCondition: [:editor |
						method body statements first lastSubmorph contents = '6'].
				step
					addStep: 'Select the 2 in the message send below the array.'
					checkCondition: [:editor |
						editor selection contents = '2' and: [
							editor selection containingStatement = method body statements second]].
				step
					addStep: 'Using H, swap it with the number 10.'
					checkCondition: [:editor |
						method body statements second arguments first receiver receiver contents = '2']]