as yet unclassified
stepInputMode: anEditor

	SBTutorialStep new
		title: 'Input mode';
		addIntroText: 'The input mode is used to edit any leaf node''s data.';
		addAction: #startInputAtStart;
		addAction: #startInputAtEnd;
		addAction: #startInputSubstituting;
		addAction: #endInput;
		addAction: #changeToUnknown;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [
						self assert: 1234 = 234.
						self assert: 'This is a rather long string where it would be annoying to have the cursor at the '.
						self assert: (9 + 9) = 7.
						self assert: (9 + 9) = Morph new]
					in: anEditor.
				step
					addStep: 'To enter input mode at the start of a node, press i. Change the 234 to a 1234 by pressing i, then 1, then escape.'
					checkCondition: [:editor |
						method statements first arguments first arguments first contents = '1234'].
				step
					addStep: 'You can enter input mode at the end of a long text, too. Press a on the long string and add the missing word "start".'
					checkCondition: [:editor |
						method statements second arguments first contents includesSubstring: 'start'].
				step
					addStep: 'You can also replace the contents of an element and start editing right away.
Press s on the 7 and change it to an 18.'
					checkCondition: [:editor |
						method statements third arguments first arguments first contents = '18'].
				step
					addStep: 'Finally, you can change a selection of elements in one go with c.
Select the `Morph new` message send using shift+k and press c.
Then change it to 18.'
					checkCondition: [:editor |
						method statements fourth arguments first arguments first contents = '18']]