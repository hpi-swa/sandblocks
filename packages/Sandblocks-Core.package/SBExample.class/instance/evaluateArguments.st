as yet unclassified
evaluateArguments

	^ self argumentsBlock childSandblocks collect: [:block | Compiler evaluate: block sourceString]