Class {
	#name : #SBGitCommit,
	#superclass : #SBBlock,
	#instVars : [
		'commit'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #'as yet unclassified' }
SBGitCommit >> commit: aCommit project: aProject [

	commit := aCommit commit.
	
	self
		addMorphBack: (SBGit imageForAuthor: commit author) asMorph;
		addMorphBack: (SBStringMorph new contents: (self truncateMessage: commit message lines first)).
	
	commit = (SBGit remoteHeadCommit: aProject) ifTrue: [
		self addMorphBack: (SBStringMorph new
			contents: 'origin';
			bold)]
]

{ #category : #'as yet unclassified' }
SBGitCommit >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 4;
		layoutInset: 2;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBGitCommit >> revertHeadOfActiveBranch [
	<action>

	| project repository |
	project := self parentSandblock activeProject.
	repository := project repository fsgitRepository.
	repository unitOfWork
		updateRef: project loadedHistorian name
		to: commit hexHash
		message: 'reset: moving to', commit hexHash.
	self parentSandblock updateForProject
]

{ #category : #'as yet unclassified' }
SBGitCommit >> truncateMessage: aString [

	^ aString size > 72 ifTrue: [(aString first: 69), '...'] ifFalse: [aString]
]
