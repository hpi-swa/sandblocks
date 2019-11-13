actions
wrapInCascade

	| cascade |
	cascade := SBCascade new.
	self doMultiSelection: [:selected |
		SBCombinedCommand new commands: (selected allButFirst collectWithIndex: [:message :index |
			SBInsertCommand new
				container: cascade;
				morph: message;
				index: index + 1;
				yourself]), {
			SBWrapCommand new
				outer: cascade;
				inner: selected first;
				wrap: [:outer :inner | outer receiver: inner receiver messages: {inner}];
				yourself}].
	self select: cascade