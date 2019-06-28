*Sandblocks
asSandblock

	^ SBMethod new
		signature: self selector values: (self arguments collect: #asSandblock) class: self methodClass;
		body: (self block asSandblock temporaries: (self temporaries collect: #asSandblock));
		yourself