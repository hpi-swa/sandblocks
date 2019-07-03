actions
pasteString

	| doIt block |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements first expr asSandblock.
	self do: (SBReplaceCommand target: self selection replacer: block)