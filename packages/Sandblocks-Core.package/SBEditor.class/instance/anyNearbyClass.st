actions
anyNearbyClass

	| artefact |
	scroll hasSubmorphs ifFalse: [^ nil].
	
	artefact := (self selection ifNil: [self methods first]) containingArtefact.
	artefact isMethod ifTrue: [^ artefact methodClass].
	artefact isClassContainer ifTrue: [^ artefact shownClass].
	^ nil