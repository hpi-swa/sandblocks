as yet unclassified
evaluate

	| arguments |
	currentSelf := self evaluateSelf.
	arguments := self evaluateArguments.
	currentSelf perform: self containingArtefact selector asSymbol withArguments: arguments