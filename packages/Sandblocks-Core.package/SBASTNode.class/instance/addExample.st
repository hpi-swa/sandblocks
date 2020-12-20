actions
addExample
	<action>

	| method class |
	method := self containingArtefact.
	class := method methodClass.
	
	self sandblockEditor do: ((SBInsertCommand newFor: method)
		container: method body;
		index: 2;
		morph: (SBExample new
			self: (method isClassSide
				ifTrue: [SBName contents: class theNonMetaClassName]
				ifFalse: [
					(SBMessageSend new
						receiver: (SBName contents: class name)
						selector: (method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new]))])
			args: (SBArray new
				type: #dynamic
				contents: (Array streamContents: [:str | method arguments size timesRepeat: [str nextPut: SBUnknown new]]))
			label: 'example'))