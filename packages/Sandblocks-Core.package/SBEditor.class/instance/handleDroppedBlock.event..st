submorphs-add/remove
handleDroppedBlock: aMorph event: anEvent

	aMorph isSelection ifTrue: [ | repl |
		repl := SBRepl new setFromSelection: aMorph.
		self sandblockEditor openMorphInView: repl.
		repl center: (scroll firstSubmorph globalPointToLocal: anEvent position).
		repl body firstSubmorph select]