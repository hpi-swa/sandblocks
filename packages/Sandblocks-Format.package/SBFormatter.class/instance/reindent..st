as yet unclassified
reindent: aStringAndIndentPair 
	| text currentIndent |
	SBExample
		self: [SBFormatter new indent: 2]
		args: [{{'test
		a
		b
		c'. 2}}]
		label: 'same'.
	SBExample
		self: [SBFormatter new indent: 3]
		args: [{{'test
		a
		b
		c'. 2}}]
		label: 'more'.
	SBExample
		self: [SBFormatter new indent: 1]
		args: [{{'test
		a
		b
		c'. 2}}]
		label: 'less'.
	text := aStringAndIndentPair first.
	currentIndent := aStringAndIndentPair second.
	currentIndent ~= indent
		ifTrue: [| lines |
			lines := text lines.
			2
				to: lines size
				do: [:index | lines
						at: index
						put: (currentIndent > indent
								ifTrue: [(lines at: index)
										allButFirst: currentIndent - indent]
								ifFalse: [(String new: indent - currentIndent withAll: Character tab)
										, (lines at: index)])].
			text := lines joinSeparatedBy: Character cr].
	^ SBExampleWatch report: text for: 580045475