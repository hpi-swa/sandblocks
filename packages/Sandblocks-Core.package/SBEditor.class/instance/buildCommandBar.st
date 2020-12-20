ui
buildCommandBar

	^ SBRow new
		changeTableLayout;
		hResizing: #spaceFill;
		cellGap: 4 withScalingFactor;
		layoutInset: 4 withScalingFactor;
		addMorphBack: (SBButton new icon: SBIcon iconUndo shortcut: (self class anyShortcutForAction: #undo) do: [self undo]);
		addMorphBack: (SBButton new icon: SBIcon iconRepeat shortcut: (self class anyShortcutForAction: #redo) do: [self redo]);
		addMorphBack: (SBButton new icon: SBIcon iconFolder_open shortcut: (self class anyShortcutForAction: #openOpenWindow) do: [self openOpenWindow]);
		addMorphBack: (SBButton new
			icon: SBIcon iconPlus shortcut: nil do: [self promptAddArtifact];
			balloonText: 'Add artifact');
		addMorphBack: (Morph new
			height: 0;
			color: Color transparent;
			hResizing: #spaceFill);
		addMorphBack: (SBButton new
			icon: SBIcon iconWindow_maximize shortcut: nil do: [self promptWorkspaceActions];
			balloonText: 'Manage Workspaces');
		addMorphBack: (SBButton new icon: SBIcon iconExpand shortcut: (self class anyShortcutForAction: #toggleFullscreen) do: [self toggleFullscreen])