actions
addExample

	self selection ifNotNil: [:selected | selected isExample ifTrue: [^ selected toggleRunning]].
	
	self do: ((SBInsertCommand newFor: self method)
		container: self method body;
		index: 2;
		morph: (SBExample new
			self: (self method isClassSide
				ifTrue: [SBBinding new contents: self method methodClass theNonMetaClassName]
				ifFalse: [
					(SBMessageSend new
						receiver: (SBBinding new contents: self method methodClass name)
						selector: (self method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new]))])
			args: (SBArray new
				type: #dynamic
				contents: (Array streamContents: [:str | self method arguments size timesRepeat: [str nextPut: SBUnknown new]]))
			label: 'simple'))