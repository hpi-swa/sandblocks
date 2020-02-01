as yet unclassified
reportValue: anObject

	| callback subject expr |
	self flag: #fixme. " more robust option to find original context? "
	subject := thisContext sender sender sender sender receiver.
	expr := anObject.
	anObject subject: subject.
	
	expressions at: anObject put: (callback := [:newValue :sideEffects |
		marbles addMarble: subject value: newValue expression: expr.
		invocations addInvocation: thisContext value: newValue from: subject expression: expr]).
	
	"anObject onChangeDo: callback."
	anObject afterInvokeDo: callback.
	invocations addExpression: anObject