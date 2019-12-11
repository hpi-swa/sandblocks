actions
wrapInCascade

	| cascade |
	cascade := SBCascade new.
	self doMultiSelection: [:selected |
		SBCombinedCommand newWith: (selected allButFirst collectWithIndex: [:message :index |
			(SBInsertCommand newFor: self method)
				container: cascade;
				morph: message;
				index: index + 1;
				yourself]), {
			(SBWrapCommand newFor: self method)
				outer: cascade;
				inner: selected first;
				wrap: [:outer :inner | outer receiver: inner receiver messages: {inner}];
				yourself}].
	self select: cascade