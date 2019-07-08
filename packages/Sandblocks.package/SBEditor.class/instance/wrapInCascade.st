actions
wrapInCascade

	self doMultiSelection: [:selected | | cascade |
		cascade := SBCascade new.
		SBCombinedCommand new commands: {
			SBWrapCommand new
				outer: cascade;
				inner: selected first;
				wrap: [:outer :inner | outer receiver: inner receiver messages: {inner}];
				yourself},
			(selected allButFirst collectWithIndex: [:message :index |
				SBInsertCommand new
					container: cascade;
					morph: message;
					index: index + 1;
					yourself])]