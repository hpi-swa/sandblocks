submorphs-add/remove
outOfWorld: aWorld

	super outOfWorld: aWorld.
	self service removeDependent: self.