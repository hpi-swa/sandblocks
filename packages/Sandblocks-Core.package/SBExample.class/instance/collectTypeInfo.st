as yet unclassified
collectTypeInfo

	| arguments receiver selector |
	receiver := self evaluateSelf.
	arguments := self evaluateArguments.
	selector := self containingArtefact selector asSymbol.
	
	SBTypeCollectSimulator new
		editor: self sandblockEditor;
		simulate: [[receiver perform: selector withArguments: arguments] on: Error do: []]