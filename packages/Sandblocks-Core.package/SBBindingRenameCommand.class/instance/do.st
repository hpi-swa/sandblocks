as yet unclassified
do

	| ret usages declaration activeMorph |
	" during redo, our oldMorph is in the world, otherwise our newMorph "
	activeMorph := (newMorph isInWorld ifTrue: [newMorph] ifFalse: [oldMorph]).
	
	" if we rename to a variable that already exists, do not change all its usages, but perform a simple local rename "
	didRename := false.
	newMorph isName ifFalse: [^ super do].
	(#('self' 'super' 'thisContext' 'true' 'false' 'nil') includes: newText) ifTrue: [^ super do].
	activeMorph binding: newText for: activeMorph class: activeMorph containingArtefact relatedClass ifPresent: [:b |
		b ~= activeMorph ifTrue: [^ super do]].
	
	declaration := newMorph isDeclaration
		ifTrue: [oldMorph contents: previousText]
		ifFalse: [activeMorph binding: previousText for: activeMorph class: activeMorph containingArtefact relatedClass ifPresent: [:b | b]].
	
	declaration ifNil: [^ super do].
	
	didRename := true.
	usages := declaration behavior allUsages, {declaration}.
	ret := super do.
	usages do: [:binding | binding contents: newText].
	^ ret