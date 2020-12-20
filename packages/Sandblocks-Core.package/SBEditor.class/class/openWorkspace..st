initialize-release
openWorkspace: aString

	SBWorkspaceHistory default items detect: [:workspace | workspace name = aString] ifFound: [:workspace | workspace open] ifNone: [self error: 'no such workspace']