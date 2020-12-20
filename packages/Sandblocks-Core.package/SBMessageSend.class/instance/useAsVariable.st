accessing
useAsVariable
	<action>
	<actionValidIf: #isUnary>

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBName contents: self selector))