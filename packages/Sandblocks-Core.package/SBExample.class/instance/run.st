as yet unclassified
run

	self containingArtefact valid ifFalse: [^ self].
	processRunning ifTrue: [^ self].
	currentProcess ifNotNil: #terminate.
	
	errorDecorator ifNotNil: #detach.
	errorDecorator := nil.
	self sendStartNotification.
	self collectTypeInfo.
	
	processRunning := true.
	currentProcess := [
		[ | arguments |
			currentSelf := self evaluateSelf.
			arguments := self evaluateArguments.
			currentSelf perform: self containingArtefact selector asSymbol withArguments: arguments
		] on: Error do: [:e |
			processRunning := false.
			self scheduleLastError: e.
			Processor activeProcess suspend].
		self scheduleLastError: nil.
		currentProcess := nil.
		processRunning := false.
		Project current addDeferredUIMessage: [self sendFinishNotification]
	] forkAt: Processor userBackgroundPriority