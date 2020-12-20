as yet unclassified
collectTypeInfo

	| arguments receiver selector |
	receiver := [self evaluateSelf] on: Error do: [^ self].
	arguments := [self evaluateArguments] on: Error do: [^ self].
	selector := self containingArtefact selector asSymbol.
	
	SBTypeCollectSimulator new
		methodMap: self sandblockEditor currentMethodMap;
		simulate: [[receiver perform: selector withArguments: arguments] on: Error do: []]