# wsus-scripts
Scripts to automate patch management and maintenance for WSUS 3.2.

# Scripts

## WSUS-Approve.ps1

This script will accept any EULAs then automatically approve selected updates in the "All Computers" group and any subgroups.

The selection criteria is an UpdateClassificationTitle of:
- "Critical Updates"
- "Security Updates"
- "Service Packs"
- "Update Rollups"

It will exclude approving any updates that have been denied.

## WSUS-Maintenance.ps1

This script will accept any EULAs then perform maintenance tasks on the database. You can comment out lines to not perform that task.

# Intended Use

The way I use these scripts is to create one or more Test subgroups under "All Computers", and configure WSUS to auto-approve updates to these groups (make sure you set up the rule so categories match the script above). Any servers or workstations placed into these Test subgroups will receive updates as soon as they are made available.

I then run WSUS-Approve as a scheduled task a set number of days after https://en.wikipedia.org/wiki/Patch_Tuesday as per the company patch management policy.

This will give you updates on your test machines first, followed by auto-approval on production as per your policy. If you run into issues during the testing phase, you can deny the update to prevent it from being pushed to production.

The maintenance script is simply run daily at a time where the server utilisation would otherwise be low.
