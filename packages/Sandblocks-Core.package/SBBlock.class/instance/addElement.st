actions
addElement
	<action>

	| cmd |
	cmd := (self insertCommandRequest: true near: (self childSandblocks ifNotEmpty: #last ifEmpty: [nil])) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self sandblockEditor startInput: self sandblockEditor selection at: 0 replacingContents: false]