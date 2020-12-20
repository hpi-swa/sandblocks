A SBTracingSimulator will execute a Smalltalk block and record all relevant sideeffects.

We distinguish between relevant and non-relevant sideeffects by tracking the identity of all objects that are created during the simulation.
These objects we consider as temporary objects.
When state is changed (meaning a variable changed was assigned a new value or a store into an object happened via `at:put:`), we see if this concerned one of the temporary objects.
If that is not the case, we consider the change as a relevant sideeffect (meaning persistent after execution of the sideeffect handler finished).