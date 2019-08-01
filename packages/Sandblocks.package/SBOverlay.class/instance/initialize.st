as yet unclassified
initialize

	super initialize.
	
	self
		extent: 200 @ 200;
		color: Color transparent;
		addMorphBack: (SBOverlayOption new
			contents: 'Navigation';
			suboptions: {
				SBOverlayOption new
					command: #swapLeft;
					contents: 'Swap left';
					place: 250 @ 0.
				SBOverlayOption new
					command: #swapRight;
					contents: 'Swap right';
					place: -250 @ 0.
			};
			center: 100 @ 100; top: 200);
		addMorphBack: (SBOverlayOption new
			contents: 'Modify';
			suboptions: {
				SBOverlayOption new
					contents: 'Delete';
					command: #deleteSelection;
					place: 200 @ -80.
				SBOverlayOption new
					command: #startInputAtStart;
					contents: 'Insert';
					place: 200 @ 0.
				SBOverlayOption new
					contents: 'Substitute';
					command: #startInputSubstituting;
					place: 200 @ 80.
			};
			center: 100 @ 100; left: 200);
		addMorphBack: (SBOverlayOption new
			contents: 'Refactor';
			suboptions: {
				SBOverlayOption new
					contents: 'Extract variable';
					command: #extractVariable;
					place: -200 @ -50.
				SBOverlayOption new
					contents: 'Extract method';
					command: #extractMethod;
					place: -200 @ 50
			};
			center: 100 @ 100; right: 0);
		addMorphBack: (SBOverlayOption new
			contents: 'Replace';
			suboptions: {
				SBOverlayOption new
					contents: 'Swap left';
					place: 200 @ 0.
				SBOverlayOption new
					contents: 'Swap right';
					place: -200 @ 0
			};
			center: 100 @ 100; bottom: 0)