as yet unclassified
stepAdvancedMessageSends: anEditor

	SBTutorialStep new
		title: 'Advanced Message Sends';
		addIntroText: 'Let''s consider a complex example. Try to change the first expression to look like the second. Here, we will guide you through the steps once more. Maybe try resetting the tutorial after and try it again without following the steps exactly!';
		addAction: #addElement;
		addAction: #addElement;
		addAction: #promptAction;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [
						SBLabel text: ['Try to change this:'].
						{42. 12} do: [:num | Transcript showln: num].
						SBLabel text: ['Into this:'].
						{42. 12} with: {54. 32} do: [:num :num2 | Transcript showln: {num. num2}]]
					in: anEditor.
				step
					addStep: 'Select the message part do: and hit * to insert another part before it. Then type with: and hit tab to focus the next hole.'
					checkCondition: [:editor | method statements second selector = 'with:do:'].
				step
					addStep: 'Type { to create an array in the hole and add the numbers 54 and 32'
					checkCondition: [:editor |
						method statements second arguments first in: [:array |
							array isArrayBlock and: [
								(array submorphs collect: #contents) = {'54'. '32'}]]].
				step
					addStep: 'Move on to the block. Select the first statement and press O to create a new statement above. Then type :num2 to turn it into a block binding.'
					checkCondition: [:editor |
						method statements second arguments in: [:args | args size > 1 and: [args second bindings size = 2]]].
				step
					addStep: 'Finally, turn the number in the showln: to an array using { and add another element after it using +.'
					checkCondition: [:editor |
						method statements second arguments in: [:args |
							args size > 1 and: [
								args second statements first in: [:msg |
									msg isMessageSend and: [
										msg arguments first in: [:array |
											array isArrayBlock and: [
												(array submorphs collect: #contents) = {'num'. 'num2'}]]]]]]]]