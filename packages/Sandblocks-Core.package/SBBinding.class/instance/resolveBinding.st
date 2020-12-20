as yet unclassified
resolveBinding

	self block binding: self contents for: self block class: self block containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil