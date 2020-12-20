actions
wrapAsArgument
	<action>
	<actionValidIf: #isExpression>

	| msg |
	msg := SBMessageSend new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: msg;
			inner: self;
			shouldMergeWithNext: true;
			wrap: [:outer :inner |
				outer receiver: SBUnknown new selector: SBMessageSend placeholderSelector arguments: {inner}];
			yourself);
		startInput: msg receiver at: 0 replacingContents: false