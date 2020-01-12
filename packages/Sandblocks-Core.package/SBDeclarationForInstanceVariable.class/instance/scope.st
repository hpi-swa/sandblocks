as yet unclassified
scope

	^ self sandblockEditor methods select: [:m | m methodClass = self containingArtefact shownClass]