as yet unclassified
do

	| ret usages declaration |
	declaration := newMorph isDeclaration
		ifTrue: [oldMorph contents: previousText]
		ifFalse: [newMorph bindingFor: previousText ifPresent: [:b | b]].
	usages := declaration allUsages, {declaration}.
	
	ret := super do.
	usages do: [:binding | binding contents: newText].
	^ ret