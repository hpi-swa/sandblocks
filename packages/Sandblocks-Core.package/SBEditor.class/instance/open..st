actions
open: aMethodOrClass

	aMethodOrClass isBehavior
		ifTrue: [
			self openMorphInView: (SBClass new class: aMethodOrClass).
			aMethodOrClass methodsDo: [:compiledMethod | self openCompiledMethod: compiledMethod]]
		ifFalse: [self openCompiledMethod: aMethodOrClass]