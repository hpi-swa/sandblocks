as yet unclassified
newFor: aMethodOrClass

	| editor method |
	editor := self new.
	aMethodOrClass isCompiledCode
		ifTrue: [method := editor openCompiledMethod: aMethodOrClass]
		ifFalse: [aMethodOrClass methodsDo: [:compiledMethod | method := editor openCompiledMethod: compiledMethod]].
	
	editor clearUndoStack.
	
	^ editor