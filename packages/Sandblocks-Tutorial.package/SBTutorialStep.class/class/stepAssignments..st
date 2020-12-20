as yet unclassified
stepAssignments: anEditor

	SBTutorialStep new
		title: 'Assignments';
		addAction: #wrapInAssignment;
		addAction: #extractVariable;
		addAction: #insertStatementBelow;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [
					42 squared.
					7 > 8 ifTrue: [Transcript showln: 'hi']] in: anEditor.
				step
					addStep: 'To wrap an expression in an assignment, select the expression and press :'
					checkCondition: [:editor | method statements first isAssignment].
				step
					addStep: 'Hit save (Ctrl+s) and declare the method as temporary.'
					checkCondition: [:editor | method body temporaries notEmpty].
				step
					addStep: 'Next, create a new statement by pressing o. Type the name var and press : again while still in input mode. Assign 5 to this variable.'
					checkCondition: [:editor |
						method statements second isAssignment and: [method statements second binding contents = 'var']].
				step
					addStep: 'The last way to create an assignment is to extract an expression. Select the 7>8 and press =. Name the new variable comp.'
					checkCondition: [:editor |
						method statements last receiver in: [:r | r isName and: [r contents = 'comp']]]]