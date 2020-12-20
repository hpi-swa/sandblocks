as yet unclassified
update

	| fields |
	self isCollapsed ifTrue: [^ self].
	
	fields := Array streamContents: [:stream |
		inspector streamFieldsOn: (SBImmediateStream with: [:subfield |
			(#(#all #self) includes: subfield type) ifFalse: [stream nextPut: subfield]])].
	
	(self submorphs viewFrom: 2 to: self submorphCount)
		with: fields
		do: [:row :subField | | newObject |
			newObject := [subField getValueFor: inspector] on: Error do: [nil].
			row submorphs second object == newObject
				ifTrue: [row submorphs second update]
				ifFalse: [
					row submorphs second replaceBy: (SBExplorer on: newObject field: (subField inspector: inspector))]]