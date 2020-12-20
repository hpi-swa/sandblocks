as yet unclassified
useAsString
	<action>
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBString new contents: self contents))