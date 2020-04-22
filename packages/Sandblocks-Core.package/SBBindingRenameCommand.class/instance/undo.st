as yet unclassified
undo

	| ret usages declaration |
	didRename ifFalse: [^ super undo].
	
	declaration := newMorph bindingFor: newText ifPresent: [:b | b].
	usages := declaration behavior allUsages, {declaration}.
	ret := super undo.
	usages do: [:binding | binding contents: previousText].
	^ ret