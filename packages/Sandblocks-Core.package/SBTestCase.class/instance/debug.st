as yet unclassified
debug
	<action>

	| testCase |
	testCase := self methodClass selector: self currentSelector.
	
	SBToggledCode comment: 'doesn''t work yet :(' active: 1 do: {[self flag: #fixme]}.
	
	[testCase debugAsFailure]
		on: Halt
		do: [:halt |
			self sandblockEditor
				reportError: halt
				process: ((Process forContext: halt signalerContext copyStack priority: Processor activeProcess priority)
					shouldResumeFromDebugger: false;
					yourself).
			self sandblockEditor errors focusErrors]