actions input
useFirstArgument
	<inputAction>
	
	self containingArtefact arguments ifNotEmpty: [
		self sandblockEditor endInputWith: self containingArtefact arguments first contents]