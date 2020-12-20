workspaces
promptWorkspaceActions

	| index |
	index := UIManager default chooseFrom: {
		('Open Workspace ', (self class shortcutStringForAction: #promptOpenWorkspace)).
		('Save Workspace ', (self class shortcutStringForAction: #saveWorkspace))
	}.
	index = 1 ifTrue: [^ self promptOpenWorkspace].
	index = 2 ifTrue: [^ self saveWorkspace]