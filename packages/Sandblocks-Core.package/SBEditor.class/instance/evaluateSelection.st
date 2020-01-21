actions
evaluateSelection

	| result |
	result := self selection evaluateWith: self selection containingArtefact.
	result explore