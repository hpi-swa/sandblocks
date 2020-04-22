as yet unclassified
evaluate

	| res |
	res := Compiler evaluate: self sourceString.
	self containingArtefact ifNotNil: [:artefact | artefact cacheType: res class for: self].
	^ res