as yet unclassified
clearErrors

	errorDecorator ifNotNil: [
		errorDecorator detach.
		errorDecorator := nil].
	
	errorIcon ifNotNil: [
		errorIcon delete.
		errorIcon := nil]