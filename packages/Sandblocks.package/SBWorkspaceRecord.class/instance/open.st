accessing
open

	lastUsed := DateAndTime now.
	self halt.
	(Compiler evaluate: self workspaceString) openInWindow