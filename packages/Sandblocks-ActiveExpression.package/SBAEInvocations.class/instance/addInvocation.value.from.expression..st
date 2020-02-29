accessing
addInvocation: aContext value: anObject from: aSubjectObject expression: anAExpression

	| stack newInvocation |
	stack := self relevantContextsFrom: thisContext.
	newInvocation := SBAEInvocationAggregate new.
	
	" defer because we can come here from the simulator, making this very slow "
	Project current addDeferredUIMessage: [ | index |
		newInvocation
			 stack: stack;
			 addInvocation: anObject asString;
			 subject: aSubjectObject.
		invocations addMorph: newInvocation.
		
		index := expressions keysInOrder indexOf: anAExpression.
		self
			addInvocation: newInvocation toList: (expressions atIndex: index) value;
			expressionIndex: index].
	
	^ newInvocation