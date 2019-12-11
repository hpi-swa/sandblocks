actions
wrapInReturn

	self do: ((SBWrapCommand newFor: self method)
		outer: SBReturn new;
		inner: self selection;
		wrap: [:outer :inner | outer expression: inner];
		yourself)