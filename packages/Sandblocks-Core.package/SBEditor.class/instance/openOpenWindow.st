actions
openOpenWindow

	((self method notNil and: [(self method methodClass compiledMethodAt: self method selector asSymbol ifAbsent: [nil]) notNil])
		ifTrue: [SBCodeOpener new positionNear: self; openFor: self method methodClass >> self method selector asSymbol]
		ifFalse: [SBCodeOpener open]) ifNotNil: [:methodOrClass | self open: methodOrClass]