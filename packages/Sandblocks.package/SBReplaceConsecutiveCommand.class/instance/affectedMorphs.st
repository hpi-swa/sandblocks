as yet unclassified
affectedMorphs

	^ targets, {replacerOldOwner ifNil: [replacer owner]} select: #notNil