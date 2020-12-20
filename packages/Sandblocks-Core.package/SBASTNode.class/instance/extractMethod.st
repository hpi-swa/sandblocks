actions
extractMethod
	<multiSelectAction>

	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	
	self sandblockEditor doMultiSelection: [:extracting | | arguments localBindings method |
		self flag: #todo. " consider write vs read access "
		localBindings := extracting gather: #resolveLocalBindings.
		localBindings := ((KeyedSet keyBlock: #name) addAll: localBindings; yourself) asArray.
		arguments := localBindings collect: [:arg | SBName contents: arg contents].
		
		method := SBMethod new
				selector: (#extracted numArgs: localBindings size)
				arguments: localBindings veryDeepCopy
				class: self containingArtefact methodClass;
				body: SBBlockBody new.
		
		SBCombinedCommand newWith:
			{(SBReplaceConsecutiveCommand newFor: self containingArtefact)
				targets: extracting;
				replacer: (SBMessageSend new
					receiver: (SBName contents: 'self')
					selector: method selector
					arguments: arguments veryDeepCopy)},
			(extracting withIndexCollect: [:stmt :index | (SBInsertCommand newFor: method)
				container: method body;
				index: index + 1;
				morph: stmt;
				yourself]),
			{
				(SBWrapCommand newFor: self containingArtefact)
					inner: extracting last;
					outer: SBReturn new;
					wrap: [:outer :inner | outer expression: inner].
				self sandblockEditor openMorphInViewCommand: method}
		]