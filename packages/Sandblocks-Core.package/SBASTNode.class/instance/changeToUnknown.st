actions
changeToUnknown
	<action>

	| new |
	new := SBUnknown new anyRepresentationThat: self acceptedRepresentation.
	new ifNotNil: [
		self sandblockEditor
			copyBuffer: self;
			do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: new;
				shouldMergeWithNext: true;
				yourself);
			startInput: new at: 0 replacingContents: false]