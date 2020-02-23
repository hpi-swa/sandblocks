actions
addElement

	| cmd |
	cmd := (self selection insertCommandRequest: true near: (self selection childSandblocks ifNotEmpty: #last ifEmpty: [nil])) ifNil: [^ self].
	
	self do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]