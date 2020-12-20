as yet unclassified
stepCascade: anEditor

	SBTutorialStep new
		title: 'Cascades';
		addIntroText: 'Let''s format this morph construction code in a cascade. Remember you can press u to undo when anything goes wrong (and U to redo).';
		addAction: #wrapInCascade;
		addAction: #deleteAround;
		addAction: #pasteElementBelow;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [ | m |
						m := Morph new.
						m changeTableLayout.
						m hResizing: #shrinkWrap.
						m vResizing: #shrinkWrap]
					in: anEditor.
				step
					addStep: 'First, multiselect the changeTableLayout, hResizing:, and vResizing: message sends by pressing v on each.'
					checkCondition: [:editor |
						editor mode = #selection and: [
							editor multiSelection size = 3 and: [
								editor multiSelection allSatisfy: [:m | m isMessageSend or: [m isMessagePart]]]]].
				step
					addStep: 'Create a cascade from your multiselection by pressing ;'
					checkCondition: [:editor | method statements second isCascade].
				step
					addStep: 'Let''s also move the cascade around our `Morph new` expression. The fastest way to do so is to select the receiver of the cascade `m` and press X, which deletes and copies the element around your selection.'
					checkCondition: [:editor |
						method statements second in: [:m | m isBinding and: [m contents = 'm']]].
				step
					addStep: 'Next, select the `Morph new` and press p to paste the just copied surronding element around our selection.'
					checkCondition: [:editor | method statements first expression isCascade]]