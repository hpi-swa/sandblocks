actions
openOpenWindow
	<action>

	| selected |
	selected := self selectedArtefact.
	((selected notNil and: [selected object isCompiledCode or: [selected object isBehavior]])
		ifTrue: [SBCodeOpener new positionNear: self; openFor: selected object]
		ifFalse: [SBCodeOpener new positionNear: self; open]) ifNotNil: [:methodOrClass | self open: methodOrClass]