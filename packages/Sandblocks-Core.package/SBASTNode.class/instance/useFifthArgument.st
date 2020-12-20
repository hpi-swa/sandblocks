actions input
useFifthArgument
	<inputAction>
	
	self containingArtefact arguments size >= 5 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments fifth contents]