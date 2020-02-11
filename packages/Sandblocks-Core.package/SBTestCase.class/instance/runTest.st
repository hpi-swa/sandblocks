as yet unclassified
runTest

	[(self methodClass selector: self currentSelector) runCase]
		on: TestResult failure do: [:err |
			err return: false]
		on: TestResult error do: [:err |
			err return: false]