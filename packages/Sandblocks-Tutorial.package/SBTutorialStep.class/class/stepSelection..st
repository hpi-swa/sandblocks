as yet unclassified
stepSelection: anEditor

	SBTutorialStep new
		title: 'Selection';
		addIntroText: 'So far, we''ve only selected leaf nodes (i.e. nodes without children). Let''s try selecting larger groups.';
		addAction: #selectUp;
		addAction: #selectDown;
		addAction: #deleteBlock;
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
					addStep: 'First, select the block argument :each in the 2nd to last line.'
					checkCondition: [:editor |
						editor selection = method body statements third arguments first bindings first].
				step
					addStep: 'Then use Shift+K to enlargen your selection to select the fuil do: message send. You can use Shift+J to go down again.'
					checkCondition: [:editor | editor selection = method body statements third].
				step
					addStep: 'Finally, as an example use x to delete the full block.'
					checkCondition: [:editor |
						method body statements noneSatisfy: [:s | s selector = 'do:']]]