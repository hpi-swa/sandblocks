as yet unclassified
runTest
	<action>

	SBExecutionEnvironment value: self.
	
	self sendStartNotification.
	
	self clearErrors.
	passIcon
		changeIconName: #'iconClock_o';
		color: Color yellow.
	([(self methodClass selector: self currentSelector) runCase. true]
		on: TestResult failure
		do: [:err |
			self reportError: err.
			err return: false]
		on: TestResult error
		do: [:err |
			self reportError: err.
			err return: false]) ifTrue: [
		passIcon
			changeIconName: #iconCheck;
			color: Color lightGreen.
		reportedError ifNotNil: #delete.
		reportedError := nil].
	
	self sendFinishNotification.
	SBExecutionEnvironment value: nil