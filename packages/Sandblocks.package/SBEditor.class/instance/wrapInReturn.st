actions
wrapInReturn

	self do: (SBWrapCommand new
		outer: SBReturn new;
		inner: self selection;
		wrap: [:outer :inner | outer expression: inner];
		yourself)