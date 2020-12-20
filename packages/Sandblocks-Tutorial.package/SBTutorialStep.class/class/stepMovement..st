as yet unclassified
stepMovement: anEditor

	SBTutorialStep new
		title: 'Movement';
		addIntroText: 'Hey! First we''ll look at moving your cursor. You can click on things, but try to only use your keyboard to get used to it. Like in vim, hjlk moves your cursor around.

Note that you always undo accidental changes with u (and redo with U).';
		addAction: #selectNext;
		addAction: #selectPreviousGroup;
		addAction: #selectUp;
		addAction: #selectNextGroup;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [ | y x |
						(true & false not) & nil isNil ifFalse: [52 squared].
						y := self size + super size.
						#($a #a 1 1.0) do: [:each |
							Transcript
								show: each class name;
								show: ' '].
						^ x < y]
					in: anEditor.
				step
					addStep: 'Select the empty string in the Transcript show cascade'
					checkCondition: [:editor |
						editor selection = method body statements third arguments first statements first messages second arguments first].
				step
					addStep: 'Select the 52 in the ifFalse: block'
					checkCondition: [:editor |
						editor selection = method body statements first arguments first statements first receiver].
				step
					addStep: 'Select the character $a'
					checkCondition: [:editor |
						editor selection = method body statements third receiver submorphs first]]