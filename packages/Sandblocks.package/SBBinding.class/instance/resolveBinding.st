as yet unclassified
resolveBinding

	self containingBlock bindingFor: self contents ifPresent: [:b | ^ b].
	^ nil