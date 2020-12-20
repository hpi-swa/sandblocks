workspaces
promptOpenWorkspace
	<action>

	| items index |
	items := SBWorkspaceHistory default items.
	index := UIManager default chooseFrom: items.
	index = 0 ifTrue: [^ self].
	self close.
	(items at: index) open