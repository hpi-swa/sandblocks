as yet unclassified
deleteMethod
	<action>

	^ self sandblockEditor do: ((SBDeleteMethodCommand newFor: self) target: self)