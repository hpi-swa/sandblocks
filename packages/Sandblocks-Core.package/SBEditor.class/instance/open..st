actions
open: aMethodOrClass

	aMethodOrClass isCollection ifTrue: [^ aMethodOrClass do: [:methodOrClass | self open: methodOrClass]].
	
	aMethodOrClass isBehavior
		ifTrue: [
			self openMorphInView: (SBClass new class: aMethodOrClass).
			aMethodOrClass methodsDo: [:compiledMethod | self openCompiledMethod: compiledMethod]]
		ifFalse: [self openCompiledMethod: aMethodOrClass]