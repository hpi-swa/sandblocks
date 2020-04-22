accessing
codeActions

	^ #()
	
	
	" from active-expressions experiment - not sure how to best place this now:
	
	self isExpression ifTrue: [
		{SBCodeAction labeled: 'Wrap in Marker' for: self do: [:node |
			node sandblockEditor do: ((SBWrapCommand newFor: node containingArtefact)
				outer: SBActiveExpressionSyncEvent new;
				inner: node;
				wrap: [:outer :inner | outer expression: inner])]}] ifFalse: [#()]"