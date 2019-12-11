actions
deleteAroundSelection

	self do: ((SBReplaceCommand newFor: self method)
		target: self selection parentSandblock;
		replacer: self selection)