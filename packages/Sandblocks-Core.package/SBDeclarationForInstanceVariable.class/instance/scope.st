as yet unclassified
scope

	^ self block sandblockEditor ifNotNil: [:e | e methods select: [:m | m methodClass = self block containingArtefact shownClass]] ifNil: [#()]