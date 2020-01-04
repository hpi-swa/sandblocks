converting
writeSourceOn: aStream

	| prefix suffix |
	prefix := type caseOf: {[#dynamic] -> ['{']. [#literal] -> ['#(']. [#byte] -> ['#[']}.
	suffix := type caseOf: {[#dynamic] -> ['}']. [#literal] -> [')']. [#byte] -> [']']}.
	
	aStream nextPutAll: prefix.
	self submorphs
		do: [:m | m writeSourceOn: aStream]
		separatedBy: [type = #dynamic ifTrue: [aStream nextPutAll: '. '] ifFalse: [aStream space]].
	aStream nextPutAll: suffix