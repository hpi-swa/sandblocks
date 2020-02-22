as yet unclassified
do

	| ret usages declaration activeMorph |
	" during redo, our oldMorph is in the world, otherwise our newMorph "
	activeMorph := (newMorph isInWorld ifTrue: [newMorph] ifFalse: [oldMorph]).
	
	declaration := newMorph isDeclaration
		ifTrue: [oldMorph contents: previousText]
		ifFalse: [activeMorph bindingFor: previousText ifPresent: [:b | b]].
	
	" if we rename to a variable that already exists, do not change all its usages, but perform a simple local rename "
	activeMorph bindingFor: newText ifPresent: [:b |
		didRename := false.
		^ super do].
	(#('self' 'super' 'thisContext' 'true' 'false' 'nil') includes: newText) ifTrue: [^ super do].
	
	didRename := true.
	usages := declaration allUsages, {declaration}.
	ret := super do.
	usages do: [:binding | binding contents: newText].
	^ ret