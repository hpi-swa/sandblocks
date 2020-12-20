A SBPCMapper fills out program counter values for a given MethodNode.

Rationale: Usually, pc values are only filled out if you call #generate on a MethodNode. This, however, applies optimizations and restructures the AST. Thus, we can use this helper to fill out pc values in an unmodified AST.