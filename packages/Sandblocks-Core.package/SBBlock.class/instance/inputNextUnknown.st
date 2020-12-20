actions
inputNextUnknown
	<action>
	<inputAction>

	(self nextBlockThat: [:m | m isUnknown])
		ifNotNil: [:m | self sandblockEditor startInput: m at: 1 replacingContents: true]