as yet unclassified
reportValue: anObject

	| subject expr |
	anObject ~~ expression ifTrue: [
		self flag: #fixme. " more robust option to find original context? "
		subject := thisContext sender sender sender sender receiver.
		expr := anObject.
		
		self flag: #todo. "breaks things because we can have many different pass throug here"
		"callback ifNotNil: [expression removeCallback: callback]."
		
		expression := anObject.
		expression onChangeDo: (callback := [:newValue |
			marbles addMarble: subject value: newValue sideEffects: expr lastSideEffects.
			invocations addInvocation: thisContext value: newValue from: subject])]