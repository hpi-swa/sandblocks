as yet unclassified
affectedMorphs

	^ {targetOldOwner ifNil: [target owner]. replacerOldOwner ifNil: [replacer owner]} select: #notNil