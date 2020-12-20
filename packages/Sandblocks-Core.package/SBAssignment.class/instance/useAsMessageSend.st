as yet unclassified
useAsMessageSend
	<action>
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBMessageSend new receiver: (SBName contents: 'self') selector: self binding contents asSymbol asSimpleSetter arguments: {self expression}))