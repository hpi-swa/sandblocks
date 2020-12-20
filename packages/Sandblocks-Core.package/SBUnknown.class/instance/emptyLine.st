as yet unclassified
emptyLine
	<action>
	<actionValidIf: #isStatement>
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: SBEmptyLine new)