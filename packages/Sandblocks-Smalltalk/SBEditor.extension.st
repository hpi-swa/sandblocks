Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Smalltalk' }
SBEditor >> createEmptySmalltalkClass [
	<action>
	<addAction>
	<label: 'Smalltalk Class'>

	| class |
	class := SBStClass new category: (self anyNearbyClass ifNotNil: #category ifNil: ['UserObjects']).
	self openMorphInView: class.
	self startInput: class childSandblocks first at: 1 replacingContents: false
]

{ #category : #'*Sandblocks-Smalltalk' }
SBEditor >> createEmptySmalltalkMethod [
	<addAction>
	<label: 'Smalltalk Method'>
	<action>

	| method |
	self openMorphInView: (method := SBStMethod new
		selector: ''
		arguments: #()
		class: ((self selectedArtefact ifNotNil: [:container | container relatedClass]) ifNil: [UIManager default chooseClassOrTrait]);
		body: (SBStBlockBody new in: [:b | b statements: {b newNullBlock}])).
	self startInput: method at: 1 replacingContents: true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBEditor >> openRepl [
	<addAction>
	<label: 'Smalltalk Workspace'>
	<action>

	| repl |
	repl := self openMorphInView: SBStPlayground new.
	self startInput: repl body childSandblocks first at: 1 replacingContents: true
]
