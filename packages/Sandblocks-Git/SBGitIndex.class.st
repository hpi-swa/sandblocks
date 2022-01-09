Class {
	#name : #SBGitIndex,
	#superclass : #SBBlock,
	#instVars : [
		'commitDraft',
		'message',
		'project',
		'changes',
		'updatedQueued'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #'as yet unclassified' }
SBGitIndex >> initialize [

	super initialize.
	
	updatedQueued := false.
	
	self
		changeTableLayout;
		layoutInset: 4;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBGitIndex >> intoWorld: newOwner [

	SBGitPackageWatcher when: #packageTouched send: #package:touched: to: self
]

{ #category : #'as yet unclassified' }
SBGitIndex >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBGitIndex >> isClean [

	^ changes childSandblocks isEmpty
]

{ #category : #'as yet unclassified' }
SBGitIndex >> outOfWorld: newOwner [

	SBGitPackageWatcher removeActionsWithReceiver: self
]

{ #category : #'as yet unclassified' }
SBGitIndex >> package: aPackage touched: aMethod [

	updatedQueued ifTrue: [^ self].
	
	((SBGit packagesIn: project) values includes: aPackage) ifTrue: [
		updatedQueued := true.
		self addAlarm: #rebuild after: 1000]
]

{ #category : #'as yet unclassified' }
SBGitIndex >> project [

	^ project
]

{ #category : #'as yet unclassified' }
SBGitIndex >> project: aProject [

	| headHex patches operationsPerClass |
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
				minimumWidth: 210;
				maxWidth: 200;
				contents: (message ifNotNil: #contents ifNil: ['']);
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
	
	patches := SBGit
		diffIn: aProject
		from: (aProject repository fsgitRepository unitOfWork objectNamed: headHex) tree
		to: commitDraft tree.
	SBToggledCode comment: '' active: 1 do: {
		[
			operationsPerClass := (patches gather: [:p | p operations]) groupBy: [:operation |
				operation definition className, ((operation isClassPatch not and: [operation definition classIsMeta])
					ifTrue: [' class']
					ifFalse: [''])].
			operationsPerClass keysAndValuesDo: [:class :operations |
				changes addMorphBack: (SBStringMorph new
					contents: class;
					bold).
				operations do: [:operation | changes addMorphBack: (SBPatchOperation new operation: operation)].
				changes addMorphBack: (Morph new
					height: 8;
					color: Color transparent)]].
		[patches do: [:patch | patch operations do: [:operation | changes addMorphBack: (SBPatchOperation new operation: operation)]]]}.
	
	updatedQueued := false
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
	
	(SBGit packagesIn: project) do: [:package | SBGitPackageWatcher clearTouchedFor: package name].
	
	message contents: ''.
	self rebuild.
	
	^ true
]
