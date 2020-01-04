shortcuts
openOpenWindow

	(self method
		ifNotNil: [:m | SBCodeOpener new positionNear: self; openFor: m methodClass >> m selector asSymbol]
		ifNil: [SBCodeOpener open]) ifNotNil: [:methodOrClass | self open: methodOrClass]