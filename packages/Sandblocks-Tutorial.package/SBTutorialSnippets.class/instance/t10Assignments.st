as yet unclassified
t10Assignments

	SBLabel text: [
		'There are three way to create assignments.
1) Select this comment and press o to create new statement.
Type a name and press : while still in input mode.
When you save the method, it will ask you to declare it.'].
	SBLabel text: ['2) Select the below expression and press :'].
	42 squared.
	SBLabel text: [
		'3) Select the boolean expression 7>8 and press =

Note that when you change the resulting variable name using s or i, both will update.'].
	7 > 8 ifTrue: [Transcript showln: 'Hi']