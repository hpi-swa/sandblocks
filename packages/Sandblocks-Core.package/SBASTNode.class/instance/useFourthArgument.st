actions input
useFourthArgument
	<inputAction>
	
	self containingArtefact arguments size >= 4 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments fourth contents]