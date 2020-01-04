as yet unclassified
restart

	| ctx |
	ctx := process popTo: context.
	process restartTop; stepToSendOrReturn.
	self context: ctx