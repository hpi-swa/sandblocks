actions
open: aMethodOrClass

	aMethodOrClass isBehavior
		ifTrue: [aMethodOrClass methodsDo: [:compiledMethod | self openCompiledMethod: compiledMethod]]
		ifFalse: [self openCompiledMethod: aMethodOrClass]