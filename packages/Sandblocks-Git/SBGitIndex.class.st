Class {
	#name : #SBGitIndex,
	#superclass : #SBBlock,
	#instVars : [
		'commitDraft',
		'message',
		'project',
		'changes'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #'as yet unclassified' }
SBGitIndex >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		layoutInset: 4;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBGitIndex >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBGitIndex >> isClean [

	^ changes hasSubmorphs not
]

{ #category : #'as yet unclassified' }
SBGitIndex >> project [

	^ project
]

{ #category : #'as yet unclassified' }
SBGitIndex >> project: aProject [

	| headHex |
	self removeAllMorphs.
	project := aProject.
	
	self addMorphBack: (SBRow new
		hResizing: #spaceFill;
		cellGap: 4;
		addMorphBack: (changes := SBColumn new
			hResizing: #spaceFill;
			cellGap: 1);
		addMorphBack: (SBColumn new
			addMorphBack: (message := SBTextBubble multiLine
				layoutInset: 2;
				minimumHeight: 32;
				minimumWidth: 200;
				maxWidth: 200;
				hResizing: #spaceFill;
				placeholderText: 'Commit message ...');
			cellGap: 4;
			addMorphBack: (SBRow new
				hResizing: #spaceFill;
				addMorphBack: (SBButton new
					label: 'Commit' shortcut: (SBEditor anyShortcutForAction: #save) do: [];
					hResizing: #spaceFill);
				addMorphBack: (SBButton new icon: SBIcon iconRefresh shortcut: nil do: [self rebuild])))).
	
	headHex := aProject loadedHistorian version commit hexHash.
	commitDraft := (SBGit createIndexFor: aProject)
		parents: {headHex};
		yourself.
	
	(SBGit
		diffIn: aProject
		from: (aProject repository fsgitRepository unitOfWork objectNamed: headHex) tree
		to: commitDraft tree) do: [:patch | patch operations do: [:operation | changes addMorphBack: (SBPatchOperation new operation: operation)]]
]

{ #category : #'as yet unclassified' }
SBGitIndex >> rebuild [

	^ self project: project
]

{ #category : #'as yet unclassified' }
SBGitIndex >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	| repository |
	commitDraft
		message: message contents;
		author: GitStamp now;
		committer: GitStamp now;
		store.
	
	repository := project repository fsgitRepository.
	repository unitOfWork
		updateRef: project loadedHistorian name
		to: commitDraft hexHash
		message: 'commit: ', message contents.
	
	self triggerEvent: #commitCreated.
	
	self rebuild.
	
	^ true
]
