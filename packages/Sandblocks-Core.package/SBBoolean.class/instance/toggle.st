as yet unclassified
toggle
	<action>

	self block sandblockEditor do: ((SBMutatePropertyCommand newFor: self block containingArtefact)
		target: self block;
		selector: #contents;
		value: self parsedContents not asString;
		yourself)