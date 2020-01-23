actions
pasteString

	| doIt block baseIndex |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements last expr asSandblock.
	baseIndex := self selection containingStatement owner submorphIndexOf: self selection containingStatement.
	
	self do: ((SBCombinedCommand newFor: self selectedArtefact)
		commands:
			{(SBReplaceCommand newFor: self method) target: self selection; replacer: block},
			(doIt block statements allButLast withIndexCollect: [:statement :index |
				(SBInsertCommand newFor: self selectedArtefact)
					index: baseIndex + index - 1;
					container: self selection containingStatement owner;
					morph: statement asSandblock]))