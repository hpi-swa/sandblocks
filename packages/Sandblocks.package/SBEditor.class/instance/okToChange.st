actions
okToChange

	^ self unsavedChanges not or: [UIManager default confirm: 'Discard unsaved changes?']