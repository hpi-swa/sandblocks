actions
addElement

	| cmd |
	cmd := self selection addCommandRequest ifNil: [^ self].
	
	self do: cmd.
	
	cmd shouldMergeWithNext ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]