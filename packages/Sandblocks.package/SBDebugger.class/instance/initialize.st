as yet unclassified
initialize

	super initialize.
	
	blockValues := Dictionary new.
	
	self
		color: Color white;
		addMorphBack: (editor := SBEditor new
			vResizing: #spaceFill;
			hResizing: #spaceFill;
			addShortcut: [:event | event keyCharacter = $q and: [event commandKeyPressed]] do: [self send];
			addShortcut: [:event | event keyCharacter = $w and: [event commandKeyPressed]] do: [self stepThrough];
			addShortcut: [:event | event keyCharacter = $e and: [event commandKeyPressed]] do: [self stepOver];
			addShortcut: [:event | event keyCharacter = $r and: [event commandKeyPressed]] do: [self restart];
			addShortcut: [:event | event keyCharacter = $a and: [event commandKeyPressed]] do: [self where]);
		changeTableLayout;
		addMorphBack: (SBRow new
			changeTableLayout;
			layoutInset: 6 * self scalingFactor;
			cellInset: 12 * self scalingFactor;
			addMorphBack: (self shortcut: 'ctrl+q' label: 'step into');
			addMorphBack: (self shortcut: 'ctrl+w' label: 'step through');
			addMorphBack: (self shortcut: 'ctrl+e' label: 'step over');
			addMorphBack: (self shortcut: 'ctrl+r' label: 'restart');
			addMorphBack: (self shortcut: 'ctrl+a' label: 'where');
			addMorphBack: (pcLabel := StringMorph new));
		addMorphBack: (frames := ECSTextList new
			minHeight: 200 * self scalingFactor)