as yet unclassified
promptAddArtifact

	| index |
	index := UIManager default chooseFrom: {
		('Add method ', (self class shortcutStringForAction: #createEmptyMethod)).
		('Add class ', (self class shortcutStringForAction: #createEmptyClass)).
		('Open Workspace ', (self class shortcutStringForAction: #openRepl))
	}.
	
	index = 1 ifTrue: [^ self createEmptyMethod].
	index = 2 ifTrue: [^ self createEmptyClass].
	index = 3 ifTrue: [^ self openRepl]
	