actions input
useSecondArgument
	<inputAction>
	
	self containingArtefact arguments size >= 2 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments second contents]