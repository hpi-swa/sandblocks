as yet unclassified
stepBasicMessageSend: anEditor

	SBTutorialStep new
		title: 'Basic Message Send';
		addIntroText: 'The editor has a separate input mode that allows typing on the keyboard as normal. Let''s see how to use it for message sends.';
		addAction: #wrapInMessageSend;
		addAction: #endInput;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [self assert: 1024 = 2] in: anEditor.
				step addStep: 'Select the 2' checkCondition: [:editor | editor selection contents = '2'].
				step
					addStep: 'Press space to send a message to your selection, then type raisedTo:. Press enter to accept an autocompletion.'
					checkCondition: [:editor |
						method statements first arguments first arguments first selector = 'raisedTo:'].
				step
					addStep: 'Finally, type 10 in the now opened field and press escape to exit the input mode.'
					checkCondition: [:editor |
						method statements first arguments first arguments first arguments first contents = '10']]