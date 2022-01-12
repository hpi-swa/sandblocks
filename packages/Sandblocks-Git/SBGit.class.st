Class {
	#name : #SBGit,
	#superclass : #SBBlock,
	#instVars : [
		'projectChooser',
		'branchChooser',
		'commits',
		'index',
		'pushButton'
	],
	#classVars : [
		'AuthorImageCache'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #'author images' }
SBGit class >> authorImageCache [

	^ AuthorImageCache ifNil: [AuthorImageCache := Dictionary new]
]

{ #category : #'author images' }
SBGit class >> avatarForCommit: aGitCommit project: aProject [

	^ self authorImageCache at: aGitCommit author email ifAbsentPut: [ | data url |
		url := ((SBGit githubProjectFor: aProject) ifNotNil: [:project | | author |
			data := WebClient httpGet: ('https://api.github.com/repos/{1}/{2}/commits/{3}' format: project, {aGitCommit hexHash}).
			author := (Json readFrom: data content readStream) author.
			author ifNotNil: [author avatar_url, ('&size=', self avatarImageSize asString)]]) ifNil: ['http://www.gravatar.com/avatar/', (WebUtils md5Digest: aGitCommit author email), ('?s=', self avatarImageSize asString)].
		
		data := WebClient httpGet: url.
		(ImageReadWriter formFromStream: data content asByteArray readStream) scaledIntoFormOfSize: self avatarImageSize asPoint]
]

{ #category : #'author images' }
SBGit class >> avatarImageSize [

	^ 16
]

{ #category : #'git utils' }
SBGit class >> commitsFor: aProject max: aNumber [

	| walker count |
	walker := aProject loadedHistorian repository historyWalkClass new.
	walker nextPut: aProject loadedHistorian version.
	count := 0.
	^ Array streamContents: [:stream |
		[walker atEnd or: [count > aNumber]] whileFalse: [
			stream nextPut: walker next.
			count := count + 1]]
]

{ #category : #'git utils' }
SBGit class >> createIndexFastFor: aProject [

	| repository fs currentHead branch |
	self example: [SBGit] args: [{SBGit project: 'sandblocks'}] label: 'example'.
	branch := aProject loadedHistorian.
	repository := aProject repository fsgitRepository.
	currentHead := branch version commit.
	fs := repository commitNamed: currentHead hexHash.
	
	(self packagesIn: aProject) keysAndValuesDo: [:path :package | | classes packagePath methods extensionMethods classesWithExtension |
		packagePath := fs root resolvePath: (FSPath from: path delimiter: '/').
		classes := Set new.
		classesWithExtension := Set new.
		extensionMethods := OrderedCollection new.
		
		methods := (SBGitPackageWatcher touchedArtefactsFor: package name) do: [:m |
			" actualClass may be nil a reference has been moved around "
			m actualClass ifNotNil: [
				(m actualClass category beginsWith: package name)
					ifTrue: [classes add: m actualClass theNonMetaClass]
					ifFalse: [classesWithExtension add: m actualClass theNonMetaClass]]].
		classes do: [:class |
			(TonelWriter on: packagePath)
				snapshot: (MCSnapshot fromDefinitions: ((package coreMethodsForClass: class), (package coreMethodsForClass: class class) collect: [:m | m asMethodDefinition]));
				writeClass: class asClassDefinition].
		classesWithExtension do: [:class |
			(TonelWriter on: packagePath)
				writeExtensionMethods: ((package extensionMethodsForClass: class) collect: [:m | m asMethodDefinition])
				className: class name]].
	
	^ fs prepareNewCommit
]

{ #category : #'git utils' }
SBGit class >> createIndexFor: aProject [

	| repository fs currentHead branch snapshots |
	self example: [SBGit new] args: [{SBGit project: 'sandblocks'}] label: 'example'.
	
	true ifTrue: [^ self createIndexFastFor: aProject].
	
	branch := aProject loadedHistorian.
	repository := aProject repository fsgitRepository.
	currentHead := branch version commit.
	fs := repository commitNamed: currentHead hexHash.
	snapshots := SBGit snapshotsForProject: aProject.
	SBGit writeSnapshots: snapshots on: fs root.
	
	^ fs prepareNewCommit
]

{ #category : #'git utils' }
SBGit class >> diffIn: aProject from: aFromHash to: aToHash [

	| repository from to |
	self
		example: [SBGit new]
		args: [
			{
				SBGit project: 'sandblocks'.
				'a63fd3c5fcb8903581b0ec750aab790987b772d6'.
				'f23c3537834f65a2d7e653922c4092200b79667b'}]
		label: 'example'.
	repository := aProject repository fsgitRepository.
	
	from := aFromHash isString
		ifTrue: [(repository unitOfWork objectNamed: aFromHash) tree]
		ifFalse: [aFromHash].
	to := aToHash isString
		ifTrue: [(repository unitOfWork objectNamed: aToHash) tree]
		ifFalse: [aToHash].
	
	^ ((GitDiffCreator new diffTrees: from and: to) values select: [:entry | entry rightSide isInFileMode]) collect: [:entry |
		(entry rightSide
			ifNil: [MCSnapshot fromDefinitions: {}]
			ifNotNil: [self tonelDeserializeBlob: entry rightSide object]) patchRelativeToBase: (entry leftSide
			ifNil: [MCSnapshot fromDefinitions: {}]
			ifNotNil: [self tonelDeserializeBlob: entry leftSide object])]
]

{ #category : #'git utils private' }
SBGit class >> extensionMethodsForAll: infos [

	| extensions |
	self example: [SBGit new] args: [{{PackageInfo named: 'Sandblocks-Core'}}] label: 'example'.
	extensions := Dictionary new.
	" TODO: missing externalTraits "
	ProtoObject withAllSubclassesDo: [:class |
		class organization categories do: [:category |
			infos do: [:info |
				(info isYourClassExtension: category) ifTrue: [
					info
						methodsInCategory: category
						ofClass: class
						do: [:method | method actualClass category ~= info packageName ifTrue: [(extensions at: info packageName ifAbsentPut: [OrderedCollection new]) add: method]]]]]].
	^ extensions
]

{ #category : #'git utils' }
SBGit class >> githubProjectFor: aProject [

	| branch git remote url regex |
	self example: [SBGit] args: [{SBGit project: 'sandblocks'}] label: 'example'.
	git := aProject loadedHistorian repository git.
	branch := aProject loadedHistorian shortName.
	remote := git upstreamRemoteOfBranchNamed: branch.
	url := git remoteUrl: remote.
	
	regex := '.+github\.com[\:\/]([^\/]+)\/([^\/\.]+).*' asRegex.
	(regex matches: url) ifFalse: [^ false].
	^ {regex subexpression: 2. regex subexpression: 3}
]

{ #category : #'git utils' }
SBGit class >> numberOfUnpushedCommits: aProject [

	| remoteCommit localCommit |
	self example: [SBGit] args: [{SBGit project: 'sandblocks'}] label: 'example'.
	remoteCommit := self remoteHeadCommit: aProject.
	localCommit := aProject loadedHistorian version commit.
	
	^ (remoteCommit isAncestorOf: localCommit)
		ifTrue: [(localCommit ancestors viewFrom: 1 until: [:ancestor | ancestor = remoteCommit]) size]
		ifFalse: [0]
]

{ #category : #'git utils private' }
SBGit class >> overridenMethodsForAll: infos [

	| overrides |
	overrides := Dictionary new.
	infos first allOverriddenMethodsDo: [:method | | category changeRecord |
		category := method category.
		infos do: [:info |
			changeRecord := info changeRecordForOverriddenMethod: method.
			((info isYourClassExtension: category) not and: [changeRecord notNil]) ifTrue: [(overrides at: info packageName ifAbsentPut: [OrderedCollection new]) add: changeRecord]]].
	^ overrides
]

{ #category : #'as yet unclassified' }
SBGit class >> packagesIn: aProject [

	^ ((aProject store objectPaths collect: [:path | | object |
		object := aProject store objectAt: path.
		(object isKindOf: PackageInfo) ifTrue: [path -> object] ifFalse: [nil]]) select: #notNil) as: OrderedDictionary
]

{ #category : #'git utils' }
SBGit class >> project: aString [

	^ SquotWorkingCopy registered detect: [:p | p name = aString]
]

{ #category : #'git utils' }
SBGit class >> remoteHeadCommit: aProject [

	| branch trackingBranch git |
	self example: [SBGit] args: [{SBGit project: 'sandblocks'}] label: 'example'.
	git := aProject loadedHistorian repository git.
	branch := aProject loadedHistorian shortName.
	trackingBranch := 'refs/remotes/{1}/{2}' format: {git upstreamRemoteOfBranchNamed: branch. branch}.
	
	^ git objectNamed: (git resolveRef: trackingBranch)
]

{ #category : #'git utils private' }
SBGit class >> snapshotsForPackages: aCollection [

	| overrides extensions |
	^ CurrentReadOnlySourceFiles cacheDuring: [
		self useWatchers ifFalse: [
			extensions := self extensionMethodsForAll: aCollection.
			overrides := self overridenMethodsForAll: aCollection].
		aCollection collect: [:info |
			MCSnapshot fromDefinitions: (Array streamContents: [:stream |
				info systemCategories ifNotEmpty: [:categories | stream nextPut: (MCOrganizationDefinition categories: categories)].
				info coreMethods do: [:ea | stream nextPut: ea asMethodDefinition].
				(self useWatchers
					ifTrue: [SBGitPackageWatcher extensionMethodsFor: info packageName]
					ifFalse: [extensions at: info packageName ifAbsent: [#()]]) do: [:ea | stream nextPut: ea asMethodDefinition].
				(self useWatchers
					ifTrue: [SBGitPackageWatcher overridenMethodsFor: info packageName]
					ifFalse: [overrides at: info packageName ifAbsent: [#()]]) do: [:ea | stream nextPut: ea asMethodDefinition].
				info classes do: [:ea | stream nextPutAll: ea classDefinitions]])]]
]

{ #category : #'git utils private' }
SBGit class >> snapshotsForProject: aProject [

	| packages |
	packages := self packagesIn: aProject.
	^ packages keys
		with: (self snapshotsForPackages: packages values)
		collect: [:path :snapshot | path -> snapshot]
]

{ #category : #'git utils private' }
SBGit class >> tonelDeserializeBlob: aBlob [

	^ MCSnapshot fromDefinitions: (TonelParser parseStream: aBlob bytes utf8Decoded readStream)
]

{ #category : #'git utils private' }
SBGit class >> useWatchers [

	^ true
]

{ #category : #'git utils private' }
SBGit class >> writeSnapshots: aCollectionOfPairs on: aFSReference [

	aCollectionOfPairs do: [:pair | | path snapshot packagePath |
		path := pair key.
		snapshot := pair value.
		packagePath := aFSReference resolvePath: (FSPath from: path delimiter: '/').
		(TonelWriter on: packagePath parent) writeSnapshot: snapshot.
		packagePath / '.squot-contents' writeStreamDo: [:stream |
			(STONWriter on: stream)
				prettyPrint: true;
				nextPut: (SquotTrackedObjectMetadata newFrom: {#objectClassName -> #PackageInfo. #objectsReplacedByNames -> true. #serializer -> #SquotTonelSerializer})]]
]

{ #category : #accessing }
SBGit >> activeProject [

	^ projectChooser object
]

{ #category : #'git external' }
SBGit >> checkedCmd: aProgramPathString arguments: aCollection env: aDictionary stdin: aString [

	^ (self cmd: aProgramPathString arguments: aCollection env: aDictionary stdin: aString cancel: [:b | ]) wait value: [:status :stdout :stderr | status = 0 ifTrue: [stdout] ifFalse: [self error: stderr]]
]

{ #category : #'git external' }
SBGit >> cmd: aProgramPathString arguments: aCollection env: aDictionary stdin: aString cancel: aBlock [

	| inputPipe outputPipe errorPipe process stderrPromise stdoutPromise processPromise |
	inputPipe := aString ifNotNil: [OSPipe blockingPipe].
	outputPipe := OSPipe nonBlockingPipe.
	errorPipe := OSPipe nonBlockingPipe.
	process := UnixProcess
		forkJob: aProgramPathString
		arguments: aCollection
		environment: (aDictionary ifNotNil: [:d | d as: Dictionary])
		descriptors: {inputPipe ifNotNil: #reader. outputPipe writer. errorPipe writer}.
	aBlock value: [process sigterm].
	outputPipe writer close.
	errorPipe writer close.
	inputPipe ifNotNil: [
		inputPipe reader close.
		inputPipe writer
			nextPutAll: aString utf8Encoded;
			flush;
			close].
	processPromise := Promise new.
	stdoutPromise := Promise new.
	stderrPromise := Promise new.
	[
		stdoutPromise resolveWith: (self trimEOF: (String streamContents: [:stream |
			[outputPipe closed] whileFalse: [
				(Delay forMilliseconds: 20) wait.
				stream nextPutAll: outputPipe upToEnd]]))] fork.
	[
		stderrPromise resolveWith: (self trimEOF: (String streamContents: [:stream |
			[errorPipe closed] whileFalse: [
				(Delay forMilliseconds: 20) wait.
				stream nextPutAll: errorPipe upToEnd]]))] fork.
	[
		[process runState == #complete] whileFalse: [(Delay forMilliseconds: 20) wait].
		outputPipe close.
		errorPipe close.
		processPromise resolveWith: (UnixProcessExitStatus for: process exitStatus) exitStatus] fork.
	^ (Promise all: {processPromise. stdoutPromise. stderrPromise}) then: [:array | [:block | block valueWithArguments: array]]
]

{ #category : #git }
SBGit >> commitProject: aString message: anotherString [

	| project branch currentHead repository fs commit |
	self example: [SBGit new] args: [{'sandblocks'. 'test commit 4'}] label: 'example'.
	project := SquotWorkingCopy registered detect: [:p | p name = aString].
	branch := project loadedHistorian.
	currentHead := branch version commit.
	repository := project repository fsgitRepository.
	
	fs := repository commitNamed: currentHead hexHash.
	
	SBGit writeSnapshots: (SBGit snapshotsForProject: project) on: fs root.
	
	commit := fs prepareNewCommit.
	commit
		message: anotherString;
		parents: {currentHead hexHash};
		author: GitStamp now;
		committer: GitStamp now;
		store.
	
	repository unitOfWork
		updateRef: branch name
		to: commit hexHash
		message: 'commit: ', anotherString asString
]

{ #category : #'initialize-release' }
SBGit >> initialize [

	super initialize.
	
	self
		layoutInset: 8;
		cellGap: 8;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			cellGap: 4;
			hResizing: #spaceFill;
			addMorphBack: (projectChooser := SBComboBox new
				prefix: 'Project: ';
				values: SquotWorkingCopy registered;
				object: SquotWorkingCopy registered first;
				when: #selectionChanged send: #updateForProject to: self);
			addMorphBack: (branchChooser := SBComboBox new prefix: 'Branch: ');
			addMorphBack: (Morph new
				extent: 0 @ 0;
				hResizing: #spaceFill);
			addMorphBack: (SBButton new
				icon: SBIcon iconCloudDownload shortcut: nil do: [self pull];
				balloonText: 'Fetch changes from remote and merge');
			addMorphBack: (pushButton := SBButton new
				icon: SBIcon iconCloudUpload label: '' do: [self push];
				balloonText: 'Push changes to remote'));
		addMorphBack: (index := SBGitIndex new when: #commitCreated send: #updateCommitList to: self);
		addMorphBack: (commits := SBColumn new);
		attachDecorator: SBForceMoveDecorator newConfigured.
	
	self updateForProject
]

{ #category : #'git external' }
SBGit >> pull [

	| currentHead newHead loader directory |
	directory := self activeProject repository fsgitRepository repository workingDir.
	index isClean ifFalse: [^ self error: 'Working image is not clean. Please commit first.'].
	
	currentHead := self activeProject loadedHistorian version commit.
	(self
		checkedCmd: ExternalUnixOSProcess defaultShellPath
		arguments: {'-c'. 'cd {1}; git status --untracked-files=no --porcelain' format: {directory}}
		env: nil
		stdin: nil) ifNotEmpty: [^ self error: 'Working copy in file system not clean. Please reset or commit first.'].
	self
		checkedCmd: ExternalUnixOSProcess defaultShellPath
		arguments: {'-c'. 'cd {1}; git pull' format: {directory}}
		env: nil
		stdin: nil.
	newHead := self activeProject loadedHistorian version commit.
	
	loader := MCPackageLoader new.
	(SBGit diffIn: self activeProject from: currentHead to: newHead) do: [:op | op applyTo: loader].
	loader load
]

{ #category : #'git external' }
SBGit >> push [

	self
		checkedCmd: ExternalUnixOSProcess defaultShellPath
		arguments: {'-c'. 'cd {1}; git push' format: {self activeProject repository fsgitRepository repository workingDir}}
		env: nil
		stdin: nil.
	self updatePushButton.
	self updateCommitList
]

{ #category : #'git external' }
SBGit >> trimEOF: aString [

	aString ifEmpty: [^ aString].
	aString last = Character lf ifTrue: [^ aString allButLast].
	^ aString
]

{ #category : #'initialize-release' }
SBGit >> updateCommitList [

	commits removeAllMorphs.
	(SBGit commitsFor: self activeProject max: 10) do: [:commit | commits addMorphBack: (SBGitCommit new commit: commit project: self activeProject)].
	self sandblockEditor ifNotNil: [commits childSandblocks first select].
	
	self updatePushButton
]

{ #category : #'initialize-release' }
SBGit >> updateForProject [

	self updateCommitList.
	index project: self activeProject.
	branchChooser object: self activeProject loadedHistorian shortName
]

{ #category : #'initialize-release' }
SBGit >> updatePushButton [

	| unpushed |
	unpushed := SBGit numberOfUnpushedCommits: self activeProject.
	pushButton label: ('({1})' format: {unpushed})
]
