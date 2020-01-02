as yet unclassified
visitMethodNode: aNode 
	aNode selector isUnary
		ifTrue: [stream nextPutAll: aNode selector]
		ifFalse: [self
				with: aNode selector keywords
				and: aNode arguments
				do: [:part :arg | 
					stream nextPutAll: part.
					stream space.
					self visitNode: arg]
				separatedBy: [stream space]].
	self newLine.
	self
		indent: 1
		around: [self newLine.
			self visitNode: aNode block]