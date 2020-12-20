actions
deleteAdjacent
	<action>

	| count startIndex endIndex targets |
	count := self sandblockEditor countModifier.
	
	startIndex := self childIndex.
	endIndex := count = 0
		ifTrue: [self parentSandblock childSandblocks size]
		ifFalse: [
			startIndex + (count - 1) min: self parentSandblock childSandblocks size].
	
	targets := (startIndex to: endIndex) collect: [:index | self parentSandblock childSandblocks at: index].
	
	self sandblockEditor
		copyBuffer: targets;
		do: (SBCombinedCommand newWith: (targets
			collect: [:target |
				(SBDeleteCommand newFor: self containingArtefact)
					target: target]))