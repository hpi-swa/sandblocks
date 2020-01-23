actions
openOpenWindow

	| selected |
	selected := self selectedArtefact.
	((selected notNil and: [selected artefact isCompiledCode or: [selected artefact isBehavior]])
		ifTrue: [SBCodeOpener new positionNear: self; openFor: selected artefact]
		ifFalse: [SBCodeOpener open]) ifNotNil: [:methodOrClass | self open: methodOrClass]