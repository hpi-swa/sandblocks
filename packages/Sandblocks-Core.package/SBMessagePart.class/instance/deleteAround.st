actions
deleteAround
	<action>

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self messageSend;
		replacer: (SBName contents: self actualContents))