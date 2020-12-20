as yet unclassified
emptyLine: aBlock
	<action>
	<actionValidIf: #isStatement>
	
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: SBEmptyLine new)