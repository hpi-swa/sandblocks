actions
openRepl

	| repl |
	repl := self openMorphInView: SBRepl new.
	self startInput: repl body childSandblocks first at: 1 replacingContents: true