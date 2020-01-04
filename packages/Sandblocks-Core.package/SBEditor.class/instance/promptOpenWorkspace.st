shortcuts
promptOpenWorkspace

	| workspace items |
	items := SBWorkspaceHistory default items.
	workspace := (UIManager default chooseFrom: items) ifNil: [^ self] ifNotNil: [:index |
		self close.
		(items at: index) open]