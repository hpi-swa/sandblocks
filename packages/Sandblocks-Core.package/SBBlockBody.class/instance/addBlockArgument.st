converting
addBlockArgument

	self sandblockEditor
		endInput;
		do: ((SBInsertCommand newFor: self containingArtefact)
			index: bindings submorphCount + 1;
			container: bindings;
			morph: SBDeclarationForBlock new;
			shouldMergeWithNext: true;
			yourself);
		startInput: self sandblockEditor selection at: 0 replacingContents: false