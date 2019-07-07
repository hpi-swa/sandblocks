actions
okToChange

	^ unsavedChanges not or: [UIManager default confirm: 'Discard unsaved changes?']