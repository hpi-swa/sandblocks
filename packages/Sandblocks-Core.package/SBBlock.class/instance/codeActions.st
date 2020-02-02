as yet unclassified
codeActions

	^ self isExpression ifTrue: [
		{SBCodeAction labeled: 'Wrap in Marker' for: self do: [:node |
			node sandblockEditor do: ((SBWrapCommand newFor: node containingArtefact)
				outer: SBActiveExpressionSyncEvent new;
				inner: node;
				wrap: [:outer :inner | outer expression: inner])]}] ifFalse: [#()]