*Sandblocks-Core-override
messageListKey: aChar from: view
	"Respond to a Command key.  I am a model with a code pane, and I also
	have a listView that has a list of methods.  The view knows how to get
	the list and selection."
	| sel class |
	aChar == $D ifTrue: [^ self toggleDiffing].
	sel := self selectedMessageName.
	aChar == $m ifTrue:  "These next two put up a type in if no message selected"
		[^ self useSelector: sel orGetSelectorAndSendQuery: #browseAllImplementorsOf: to: self ].
	aChar == $n ifTrue: 
		[^ self useSelector: sel orGetSelectorAndSendQuery: #browseAllCallsOn: to: self ].
	aChar == $d ifTrue: [^ self removeMessageFromBrowser].
	"The following require a class selection"
	(class := self selectedClassOrMetaClass) ifNil: [^ self arrowKey: aChar from: view].
	aChar == $b ifTrue: [^ ToolSet browse: class selector: sel].
	aChar == $N ifTrue: [^ self browseClassRefs].
	aChar == $i ifTrue: [^ self methodHierarchy].
	aChar == $h ifTrue: [^ self classHierarchy].
	aChar == $p ifTrue: [^ self browseFullProtocol].
	aChar == $r ifTrue: [^ self browseVariableReferences].
	aChar == $a ifTrue: [^ self browseVariableAssignments].
	aChar == $O ifTrue: [^ (self selectedClassOrMetaClass compiledMethodAt: self selectedMessageName ifAbsent: []) ifNotNil: [:method| SBEditor openFor: method]].
	(aChar == $Y and: [self canShowMultipleMessageCategories])
		ifTrue: [^ self showHomeCategory].
	"The following require a method selection"
	sel ifNotNil: 
		[aChar == $o ifTrue: [^ self fileOutMessage].
		aChar == $c ifTrue: [^ self copySelector].
		aChar == $v ifTrue: [^ self browseVersions].
		aChar == $x ifTrue: [^ self removeMessage].
		aChar == $C ifTrue: [ self copyReference ]].
	^ self arrowKey: aChar from: view