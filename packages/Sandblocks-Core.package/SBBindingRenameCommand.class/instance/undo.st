as yet unclassified
undo

	| ret usages declaration |
	declaration := newMorph bindingFor: newText ifPresent: [:b | b].
	usages := declaration allUsages, {declaration}.
	ret := super do.
	usages do: [:binding | binding contents: previousText].
	^ ret