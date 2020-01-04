actions
pasteString

	| doIt block |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements first expr asSandblock.
	self do: ((SBReplaceCommand newFor: self method) target: self selection; replacer: block)