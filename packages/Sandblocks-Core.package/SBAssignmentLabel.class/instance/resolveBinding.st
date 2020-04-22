as yet unclassified
resolveBinding

	self block bindingFor: self contents ifPresent: [:b | ^ b].
	^ nil