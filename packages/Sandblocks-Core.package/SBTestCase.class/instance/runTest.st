as yet unclassified
runTest

	(self saveTryFixing: true quick: false) ifFalse: [^ self].
	self clearErrors.
	[(self methodClass selector: self currentSelector) runCase]
		on: TestResult failure
		do: [:err | 
			self reportError: err.
			err return: false]
		on: TestResult error
		do: [:err | 
			self reportError: err.
			err return: false]