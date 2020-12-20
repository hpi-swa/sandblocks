as yet unclassified
layoutCommands

	| preamble preambleHasContent |
	preamble := self firstSubmorph layoutCommands.
	preambleHasContent := bindings hasSubmorphs or: [temporaries hasSubmorphs].
	
	self statementCount = 0 ifTrue: [^ SBAlgebraCommand container
			morph: self;
			data: {preamble}].
	
	^ (self statementCount > 1 or: [bindings hasSubmorphs and: [temporaries hasSubmorphs]])
		ifTrue: [
			SBAlgebraCommand container
				morph: self;
				data: {
					preamble.
					preambleHasContent ifTrue: [SBAlgebraCommand hardLine] ifFalse: [SBAlgebraCommand noop]},
					(self statements collect: [:stmt | stmt layoutCommands] separatedBy: [SBAlgebraCommand hardLine withGap: true])]
		ifFalse: [
			SBAlgebraCommand container
				morph: self;
				data: ({
					preamble.
					preambleHasContent ifTrue: [SBAlgebraCommand softLine] ifFalse: [SBAlgebraCommand noop].
					self statements first layoutCommands})]