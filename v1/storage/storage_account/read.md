## Supported account configurations

Immutability policies are supported for both new and existing storage accounts. The following table shows which types of storage accounts are supported for each type of policy:

| Type of immutability policy | Scope of policy       | Types of storage accounts supported                          | Supports hierarchical namespace |
| :-------------------------- | :-------------------- | :----------------------------------------------------------- | :------------------------------ |
| Time-based retention policy | Version-level scope   | General-purpose v2 Premium block blob                        | No                              |
| Time-based retention policy | Container-level scope | General-purpose v2 Premium block blob General-purpose v1 (legacy)1 Blob storage (legacy) | Yes                             |
| Legal hold                  | Version-level scope   | General-purpose v2 Premium block blob                        | No                              |
| Legal hold                  | Container-level scope | General-purpose v2 Premium block blob General-purpose v1 (legacy)1 Blob storage (legacy) | Yes                             |

>  **Immutability policies are not supported in accounts that have the Network File System (NFS) 3.0 protocol or the SSH File Transfer Protocol (SFTP) enabled on them.**

> **Point-in-time restore isn't supported when version-level immutability is enabled on a storage account or a container in an account.** 

https://learn.microsoft.com/en-us/azure/storage/blobs/immutable-storage-overview

https://learn.microsoft.com/en-us/azure/storage/blobs/point-in-time-restore-overview



### error on KeyBasedAuthenticationNotPermitted

![image-20231206214936196](../../../../../../../Desktop/ump/sem 5/english for tehnical communication/image/image-20231206214936196.png)
