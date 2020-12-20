actions
inputPreviousUnknown
	<action>
	<inputAction>

	(self previousMorphThat: [:m | m isSandblock and: [m isUnknown]])
		ifNotNil: [:m | self sandblockEditor startInput: m at: 1 replacingContents: true]