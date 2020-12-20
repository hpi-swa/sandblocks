as yet unclassified
insertElement: aBoolean

	| cmd |
	cmd := (self parentSandblock insertCommandRequest: aBoolean near: self) ifNil: [^ self].
	
	self sandblockEditor do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self sandblockEditor startInput: self sandblockEditor selection at: 0 replacingContents: false]