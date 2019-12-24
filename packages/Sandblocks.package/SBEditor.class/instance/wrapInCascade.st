actions
wrapInCascade

	| cascade |
	cascade := SBCascade new.
	self doMultiSelection: [:selected |
		SBCombinedCommand newWith: {
			(SBMoveCommand newFor: self method)
				morph: selected first receiver;
				container: cascade;
				index: 1;
				yourself.
			(SBWrapCommand newFor: self method)
				outer: cascade;
				inner: selected first;
				wrap: [:outer :inner | outer addMorphBack: inner];
				yourself}, (selected allButFirst collectWithIndex: [:message :index |
			SBCombinedCommand newWith: {
				(SBInsertCommand newFor: self method)
					container: cascade;
					morph: message;
					index: index + 1;
					yourself.
				(SBDeleteCommand newFor: self method)
					target: message receiver;
					yourself
			}])].
	self select: cascade