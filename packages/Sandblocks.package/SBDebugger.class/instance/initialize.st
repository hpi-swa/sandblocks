as yet unclassified
initialize

	super initialize.
	
	blockValues := Dictionary new.
	
	self
		color: Color white;
		addMorphBack: (editor := SBEditor new
			minHeight: 400 * self scalingFactor;
			vResizing: #spaceFill;
			hResizing: #spaceFill;
			addCommandShortcut: $q command do: [:editor | self send];
			addCommandShortcut: $w command do: [:editor | self stepThrough];
			addCommandShortcut: $e command do: [:editor | self stepOver];
			addCommandShortcut: $r command do: [:editor | self restart];
			addCommandShortcut: $a command do: [:editor | self where]);
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