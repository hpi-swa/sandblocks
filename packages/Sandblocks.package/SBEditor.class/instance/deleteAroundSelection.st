actions
deleteAroundSelection

	self do: (SBReplaceCommand target: self selection parentSandblock replacer: self selection)