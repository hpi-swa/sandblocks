actions input
useThirdArgument
	<inputAction>
	
	self containingArtefact arguments size >= 3 ifTrue: [
		self sandblockEditor endInputWith: self containingArtefact arguments third contents]