as yet unclassified
resolveBinding

	self bindingFor: self contents ifPresent: [:b | ^ b].
	^ nil