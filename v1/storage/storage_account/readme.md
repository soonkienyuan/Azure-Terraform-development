## storage account level immutability policy

Enable version/account-level immutability support
Allows you to set time-based retention policy on the account-level
that will apply to all blob versions. Enable this feature to set 
a default policy at the account level. Without enabling this, 
you can still set a default policy at the container level or set 
policies for specific blob versions. 

> **Blob Versioning is required for this property to be enabled**


Default account-level immutability policy 
applies to all object in sa that do not possess an explicit immutability policy at the object level object-level immutability policy has 
higher precedence than the container-level immutabilit which, higher precedence than the account-level immutability policy.

When variable **state** is

Disabled :

The policy is not active, and no immutability restrictions are applied to the container.

Unlocked :

The policy is active, but the immutability retention time can be increased or decreased, and the allowProtectedAppendWrites property can be toggled.

Locked:

The policy is active and locked. The immutability retention time can only be increased, not decreased, and the allowProtectedAppendWrites 
property cannot be changed.

allow_protected_append_writes:

new blocks can be written to an append blob while 
maintaining immutability protection and compliance. 
Only new blocks can be added and any existing blocks 
cannot be modified or deleted.
