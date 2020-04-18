actions
open: aMethodOrClass

	aMethodOrClass isBehavior ifTrue: [
		self openClass: aMethodOrClass.
		^ aMethodOrClass methodsDo: [:compiledMethod | self openCompiledMethod: compiledMethod]].
	
	aMethodOrClass isCompiledMethod ifTrue: [^ self openCompiledMethod: aMethodOrClass].
	
	aMethodOrClass isCollection ifTrue: [^ aMethodOrClass do: [:methodOrClass | self open: methodOrClass]].
	
	self error: 'not supported for opening'