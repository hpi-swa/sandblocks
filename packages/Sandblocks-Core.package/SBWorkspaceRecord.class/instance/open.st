accessing
open

	lastUsed := DateAndTime now.
	(Compiler evaluate: self workspaceString)
		workspace: self;
		openInWindow