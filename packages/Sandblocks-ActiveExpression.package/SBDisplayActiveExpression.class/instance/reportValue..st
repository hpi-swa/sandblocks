as yet unclassified
reportValue: anObject

	| subject |
	anObject ~~ expression ifTrue: [
		self flag: #fixme. " more robust option to find original context? "
		subject := thisContext sender sender sender sender receiver.
		
		self flag: #todo. "break things"
		"callback ifNotNil: [expression removeCallback: callback]."
		
		expression := anObject.
		expression onChangeDo: (callback := [:newValue |  
			marbles addMarble: subject value: newValue.
			invocations addInvocation: thisContext value: newValue from: subject])]