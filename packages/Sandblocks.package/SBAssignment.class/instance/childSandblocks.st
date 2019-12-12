converting
childSandblocks

	^ {self submorphs at: 1 ifAbsent: [nil]. self submorphs at: 3 ifAbsent: [nil]} select: #notNil