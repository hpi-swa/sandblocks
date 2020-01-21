actions
openOpenWindow

	| selected |
	selected := self selectedArtefact.
	((selected notNil and: [(selected isMethod and: [selected relatedClass compiledMethodAt: selected selector asSymbol ifAbsent: [nil]]) notNil])
		ifTrue: [SBCodeOpener new positionNear: self; openFor: selected relatedClass >> selected selector asSymbol]
		ifFalse: [SBCodeOpener open]) ifNotNil: [:methodOrClass | self open: methodOrClass]