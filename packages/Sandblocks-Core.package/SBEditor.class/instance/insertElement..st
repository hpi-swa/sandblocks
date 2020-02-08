actions
insertElement: aBoolean

	| cmd |
	cmd := (self selection parentSandblock insertCommandRequest: aBoolean near: self selection) ifNil: [^ self].
	
	self do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]