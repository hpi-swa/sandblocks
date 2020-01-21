actions
saveWorkspace

	workspace
		ifNotNil: [workspace updateFrom: self]
		ifNil: [ | name |
			name := (UIManager default
				request: 'Workspace name?'
				initialAnswer: (((self methods collect: #methodClass) collect: #name) asSet asArray joinSeparatedBy: ', ')) ifNil: [^ self].
			
			self workspace: (SBWorkspaceHistory default
				save: self
				named: name)]