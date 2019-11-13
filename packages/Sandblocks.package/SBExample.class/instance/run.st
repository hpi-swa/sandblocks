as yet unclassified
run

	self containingMethod valid ifFalse: [^ self].
	processRunning ifTrue: [^ self].
	currentProcess ifNotNil: #terminate.
	
	self sendStartNotification.
	
	processRunning := true.
	currentProcess := [
		[ | arguments |
			currentSelf := Compiler evaluate: (SBMessageSend new receiver: self selfBlock veryDeepCopy selector: #value) sourceString.
			arguments := self argumentsBlock childSandblocks collect: [:block | Compiler evaluate: block sourceString].
			currentSelf perform: self containingMethod selector asSymbol withArguments: arguments
		] on: Error do: [:e |
			processRunning := false.
			self scheduleLastError: e.
			Processor activeProcess suspend].
		self scheduleLastError: nil.
		currentProcess := nil.
		processRunning := false
	] fork