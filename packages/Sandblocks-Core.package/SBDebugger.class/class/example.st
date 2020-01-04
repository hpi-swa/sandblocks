as yet unclassified
example

	| method guineaPig context debugger |
	method := (Compiler new compileNoPattern: 'Random new next' in: UndefinedObject notifying: nil ifFail: []) generateWithTempNames.
	guineaPig := [method
			valueWithReceiver: nil
			 arguments: (#()).
		 guineaPig := nil "spot the return from aCompiledMethod"] newProcess.
	context := guineaPig suspendedContext.
	
	debugger := self new
		process: guineaPig
		context: context;
		openInWindow;
		yourself.
	
	"Now step into the expression.  But if it is quick (is implemented as a primtiive, e.g. `0')
	 it will return immediately back to the block that is sent newProcess above.  Guard
	 against that with the check for home being thisContext."
	[debugger interruptedContext method == method]
		whileFalse:
			[(guineaPig isNil
			  and: [debugger interruptedContext home == thisContext]) ifTrue:
				[UIManager default inform: 'Nothing to debug; expression is optimized'. ^ self].
			debugger send]