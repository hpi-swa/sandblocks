Class {
	#name : #SBGitCommit,
	#superclass : #SBBlock,
	#instVars : [
		'commit'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #actions }
SBGitCommit >> checkout [

	| project headHex indexCommit operations loader |
	project := self project.
	
	headHex := project loadedHistorian version commit hexHash.
	indexCommit := (SBGit createIndexFor: project)
		parents: {headHex};
		yourself.
	operations := SBGit
		diffIn: project
		from: indexCommit tree
		to: (project repository fsgitRepository unitOfWork objectNamed: headHex) tree.
	
	loader := MCPackageLoader new.
	operations do: [:operation | operation applyTo: loader].
	loader load
]

{ #category : #initialize }
SBGitCommit >> commit: aCommit project: aProject [

	commit := aCommit commit.
	
	self
		addMorphBack: (SBGit avatarForCommit: commit project: aProject) asMorph;
		addMorphBack: (SBStringMorph new contents: (self truncateMessage: commit message lines first)).
	
	commit = (SBGit remoteHeadCommit: aProject) ifTrue: [
		self addMorphBack: (SBStringMorph new
			contents: 'origin';
			bold)]
]

{ #category : #initialize }
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

{ #category : #accessing }
SBGitCommit >> project [

	^ self parentSandblock activeProject
]

{ #category : #actions }
SBGitCommit >> revertHeadOfActiveBranch [
	<action>

	| project repository |
	project := self project.
	repository := project repository fsgitRepository.
	repository unitOfWork
		updateRef: project loadedHistorian name
		to: commit hexHash
		message: 'reset: moving to', commit hexHash.
	self parentSandblock updateForProject
]

{ #category : #initialize }
SBGitCommit >> truncateMessage: aString [

	^ aString size > 72 ifTrue: [(aString first: 69), '...'] ifFalse: [aString]
]
