actions
inputPreviousUnknown

	(self selection previousMorphThat: [:m | m isSandblock and: [m isUnknown]]) ifNotNil: [:m | self startInput: m at: 1 replacingContents: true]