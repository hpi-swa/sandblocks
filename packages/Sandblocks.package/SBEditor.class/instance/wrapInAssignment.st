actions
wrapInAssignment

	| binding |
	binding := SBBinding new.
	self do: (SBWrapCommand new
		outer: SBAssignment new;
		inner: self selection;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: binding at: 0 replacingContents: true