actions
anyNearbyClass

	| artefacts |
	artefacts := self artefacts.
	artefacts ifEmpty: [^ UndefinedObject].
	
	^ ((self selection ifNotNil: #containingArtefact) ifNil: [artefacts first]) relatedClass