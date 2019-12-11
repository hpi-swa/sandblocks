actions
extractMethod

	| localBindings selectorAndArguments |
	self multiSelectionIsConsecutive ifFalse: [^ self].
	self doMultiSelection: [:extracting |
		selectorAndArguments := (SBRequestSelector openForSnippet: extracting) ifNil: [^ self].
		
		localBindings := extracting gather: #resolveLocalBindings.
		localBindings := ((KeyedSet keyBlock: #name) addAll: localBindings; yourself) asArray.
		
		SBEditor new
			openMethod: (SBMethod new
				selector: selectorAndArguments first
				arguments: selectorAndArguments second veryDeepCopy
				class: self method methodClass;
				body: (SBBlockBody new statements: extracting veryDeepCopy));
			openInWindow.
		
		localBindings size < selectorAndArguments second size ifTrue: [
			selectorAndArguments second size - localBindings size timesRepeat: [localBindings := localBindings copyWith: SBUnknown new]].
		
		(SBReplaceConsecutiveCommand newFor: self method)
			targets: extracting;
			replacer: (SBMessageSend new
				receiver: (SBKeywordBinding new name: 'self')
				selector: selectorAndArguments first
				arguments: localBindings veryDeepCopy)]