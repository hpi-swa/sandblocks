as yet unclassified
undo

	| ret usages declaration |
	didRename ifFalse: [^ super undo].
	
	declaration := newMorph binding: newText for: newMorph class: newMorph containingArtefact relatedClass ifPresent: [:b | b].
	usages := declaration behavior allUsages, {declaration}.
	ret := super undo.
	usages do: [:binding | binding contents: previousText].
	^ ret