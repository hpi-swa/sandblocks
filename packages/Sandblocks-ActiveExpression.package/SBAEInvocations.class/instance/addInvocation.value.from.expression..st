as yet unclassified
addInvocation: aContext value: anObject from: aSubjectObject expression: anAExpression

	| stack newInvocation |
	stack := self relevantContextsFrom: thisContext.
	newInvocation := SBAEInvocationAggregate new.
	
	" defer because we can come here from the simulator, making this very slow "
	Project current addDeferredUIMessage: [ | index aggregate list |
		newInvocation
			 stack: stack;
			 addInvocation: anObject asString;
			 subject: aSubjectObject.
		
		index := expressions keysInOrder indexOf: anAExpression.
		index ~= self expressionIndex ifTrue: [
			self expressionIndex: index].
		
		list := (expressions atIndex: index) value.
		aggregate := "DISABLED AGGREGATION
		list
			detect: [:invocation | invocation sameLocation: newInvocation]
			ifFound: [:invocation |
				invocations addMorph: invocation.
				list remove: invocation; addFirst: invocation.
				
				invocation addInvocation: anObject asString]
			ifNone: "[
				list addFirst: newInvocation.
				invocations addMorph: newInvocation.
				self updateInterestingCodeLocations: list.
				newInvocation] value].
	^ newInvocation