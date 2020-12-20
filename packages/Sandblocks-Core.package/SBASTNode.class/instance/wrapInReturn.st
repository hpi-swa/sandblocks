actions
wrapInReturn
	<action>
	<actionValidIf: #isExpression>

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner];
		yourself)