as yet unclassified
runTest

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