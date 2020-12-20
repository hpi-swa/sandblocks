as yet unclassified
deleteClass
	<action>
	
	| classToRemove |
	classToRemove := self relatedClass theNonMetaClass.
	(self confirm: 'Are you certain that you want to DELETE the class ', classToRemove name, ' (no easy undo)?') ifTrue: [
		classToRemove subclasses notEmpty ifTrue: [
			(self confirm: 'class has subclasses: still delete?') ifFalse: [^ self]].
		classToRemove removeFromSystem].
	self delete