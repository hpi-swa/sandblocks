actions
saveWorkspace

	workspace
		ifNotNil: [workspace updateFrom: self]
		ifNil: [
			SBWorkspaceHistory default
				save: self
				named: ((UIManager default
					request: 'Workspace name?'
					initialAnswer: (((self methods collect: #methodClass) collect: #name) asSet asArray joinSeparatedBy: ', ')) ifNil: [^ self])]