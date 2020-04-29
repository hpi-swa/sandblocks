as yet unclassified
resolveBinding

	self block bindingFor: self contents class: self block containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil