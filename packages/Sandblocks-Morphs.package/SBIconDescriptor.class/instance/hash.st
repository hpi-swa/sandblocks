comparing
hash

	self flag: #fixme. "not idea how collision-poor this is"
	^ (self svg hash bitXor: self size hash) bitXor: self color hash