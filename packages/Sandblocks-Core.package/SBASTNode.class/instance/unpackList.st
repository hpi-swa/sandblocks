actions
unpackList
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	self sandblockEditor do: ((SBUnwrapConsecutiveCommand newFor: self containingArtefact) target: self)