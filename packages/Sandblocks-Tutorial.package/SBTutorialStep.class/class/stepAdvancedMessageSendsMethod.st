as yet unclassified
stepAdvancedMessageSendsMethod SBLabel
		text: ['Try to change this:'].
	{42. 12}
		do: [:num | Transcript showln: num].
	SBLabel
		text: ['Into this:'].
	{42. 12}
		with: {54. 32}
		do: [:num :num2 | Transcript showln: {num. num2}]