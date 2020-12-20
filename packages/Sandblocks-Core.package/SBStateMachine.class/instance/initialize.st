transitions
initialize
	super initialize.
	
	signalTransitions := Dictionary new.
	conditionalTransitions := Dictionary new.
	timeTransitions := Dictionary new.
	
	enterActions := Dictionary new.
	leaveActions := Dictionary new