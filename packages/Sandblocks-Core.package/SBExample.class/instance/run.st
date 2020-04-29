as yet unclassified
run

	self containingArtefact valid ifFalse: [^ self].
	processRunning ifTrue: [^ self].
	currentProcess ifNotNil: #terminate.
	
	errorDecorator ifNotNil: #detach.
	errorDecorator := nil.
	returnValue contents: ''.
	self sendStartNotification.
	self collectTypeInfo.
	
	processRunning := true.
	currentProcess := [
		| returned |
		[returned := self evaluate] on: Error do: [:e |
			processRunning := false.
			self scheduleLastError: e.
			Processor activeProcess suspend].
		self scheduleLastError: nil.
		currentProcess := nil.
		processRunning := false.
		Project current addDeferredUIMessage: [
			returnValue contents: '-> ', returned printString.
			self sendFinishNotification]
	] forkAt: Processor userBackgroundPriority