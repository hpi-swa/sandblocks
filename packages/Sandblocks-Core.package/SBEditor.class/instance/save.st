actions
save
	<action>
	<inputAction>

	self interruptInputDuring: [
		self selection ifNotNil: [self save: self selectedArtefact tryFixing: true quick: false]]