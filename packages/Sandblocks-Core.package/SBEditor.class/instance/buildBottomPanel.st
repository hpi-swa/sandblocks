initialize-release
buildBottomPanel

	^ Morph new
		changeTableLayout;
		cellPositioning: #center;
		vResizing: #shrinkWrap;
		cellGap: 8 withScalingFactor;
		hResizing: #spaceFill;
		wrapCentering: #center;
		layoutInset: 4 withScalingFactor;
		listDirection: #leftToRight;
		color: Color transparent;
		addMorphBack: (modeLabel := StringMorph new emphasis: TextEmphasis bold emphasisCode);
		addMorphBack: (selectionLabel := StringMorph new contents: '');
		addMorphBack: (searchInput := SBSearchPanel new);
		addMorphBack: (Morph new
			extent: 0 @ 0;
			hResizing: #spaceFill;
			color: Color transparent);
		"addMorphBack: (compileTimeButton := StringMorph new
			contents: 'Compile on save';
			on: #click send: #promptChangeCompile to: self);"
		addMorphBack: (SBButton new
			balloonText: 'Copy';
			icon: SBIcon iconCopy shortcut: (self class anyShortcutForAction: #copyToBuffer) do: [self selection copyToBuffer]);
		addMorphBack: (SBButton new
			balloonText: 'Copy around';
			icon: SBIcon iconClipboard
				shortcut: (self class anyShortcutForAction: #copyAround)
				do: [self selection copyAround]);
		addMorphBack: (copyBufferPreview := ImageMorph new image: (Form extent: 1 @ 1));
		yourself