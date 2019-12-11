as yet unclassified
newFor: aMethodOrClass

	| editor |
	editor := self new.
	aMethodOrClass isCompiledCode
		ifTrue: [editor openCompiledMethod: aMethodOrClass]
		ifFalse: [aMethodOrClass methodsDo: [:method | editor openCompiledMethod: method]].
	
	^ editor