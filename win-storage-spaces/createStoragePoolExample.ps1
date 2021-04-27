# This script can be used as an example of creating a volume of striped disks using Windows Storage Spaces. This should only be used for POC or testing.

$physicalDisks = Get-PhysicalDisk | ? { $_.FriendlyName -eq "Msft Virtual Disk" } # Add customizations to filter to the the disks to create the storage pool. This will create a pool from all attached managed disks.

$storagePoolName = "NewStoragePool"
$virtualDiskName = "NewVirtualDisks"
$volumeName = "DataVolume"
$interleaveSize = 64kb # this is commonly referred to the stripe size. SQL recommendations are 256 KB (Data warehousing); 64 KB (Transactional)
$allocationUnitSize = 64kb # NTFS allocation size. SQL recommendation to 64kb

# Create the storage pool from the physical disks (managed disks) attached to the VM
$storagePool = New-StoragePool -FriendlyName $storagePoolName -StorageSubsystemFriendlyName "Windows Storage*" -PhysicalDisks $physicalDisks

# Set the MediaType to SSD or HDD for the physical disks
$storagePool | Get-PhysicalDisk | % { $_ | Set-PhysicalDisk -MediaType SSD}

# Create the virtual disk
$virtualDisk = $storagePool | New-VirtualDisk -FriendlyName $virtualDiskName -Interleave $interleaveSize -NumberOfColumns $physicalDisks.Count -ResiliencySettingName simple –UseMaximumSize

# Initialize the disk, create the partition, and format the volume
$virtualDisk | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel $volumeName -AllocationUnitSize $allocationUnitSize -Confirm:$false