actions
wrapInAssignment
	<action>
	<actionValidIf: #isExpression>

	| binding |
	binding := SBName new.
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBAssignment new;
		inner: self;
		wrap: [:outer :inner | outer binding: binding value: inner];
		shouldMergeWithNext: true;
		yourself).
	
	self sandblockEditor startInput: binding at: 0 replacingContents: true