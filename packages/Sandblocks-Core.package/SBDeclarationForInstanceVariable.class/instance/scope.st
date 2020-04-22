as yet unclassified
scope

	^ self block sandblockEditor methods select: [:m | m methodClass = self block containingArtefact shownClass]