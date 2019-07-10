as yet unclassified
run

	| eval |
	self containingMethod valid ifFalse: [^ self].
	processRunning ifTrue: [^ self].
	currentProcess ifNotNil: #terminate.
	
	eval :=  (SBMessageSend new
		receiver: (SBMessageSend new receiver: self selfBlock veryDeepCopy selector: #value)
		selector: self containingMethod selector
		arguments: self argumentsBlock childSandblocks veryDeepCopy) sourceString.
	
	processRunning := true.
	currentProcess := [
		[Compiler evaluate: eval] on: Error do: [:e |
			processRunning := false.
			self scheduleLastError: e.
			Processor activeProcess suspend].
		self scheduleLastError: nil.
		currentProcess := nil.
		processRunning := false
	] fork