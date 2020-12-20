as yet unclassified
useAsMessageSend
	<action>

	^ self block sandblockEditor do: ((SBReplaceCommand newFor: self block containingArtefact)
		target: self block;
		replacer: (SBMessageSend new receiver: (SBName contents: 'self') selector: self block contents asSymbol);
		yourself)