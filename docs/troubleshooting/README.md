# Troubleshooting logs


## Overview

This document outlines the troubleshooting steps, infrastructure modifications, and structural best practices applied when scaling a single-server Windows Server Active Directory (AD) environment to a multi-workstation lab.

## 🛠️ Identity and Trust Relationship Repairs

### Duplicate SID Conflicts

* **Issue:** Booting raw cloned VMs caused identical machine Security Identifiers (SIDs) to contact the Domain Controller. Active Directory severed the domain trust to protect the network, resulting in "Trust Relationship Failed" errors.

* **Resolution:** 
  1. Logged in via the local administrator to bypass the domain block.
  2. Dropped the workstation to a Workgroup.
  3. Executed `C:\Windows\System32\Sysprep\sysprep.exe` with the **Generalize** flag enabled to strip the duplicated hardware identity.
  4. Rejoined the `bek.local` domain to generate a fresh, unique computer account.

### Locked Administrator Accounts

* **Issue:** When a broken clone dropped from the domain, the default local administrator account was found to be disabled by Windows 10, completely locking out system access.

* **Resolution:** 
  1. Destroyed the broken VM and cloned a fresh offline copy from the master template.
  2. Kept the virtual network adapter disconnected to prevent AD detection upon boot.
  3. Ran Sysprep offline to force a new Out-Of-Box Experience (OOBE) setup, allowing the creation of a new, accessible local admin account before reconnecting to the network.

## 🌐 Network and Connectivity Resolution

### IP Address Collisions

* **Issue:** Clones booting with identical static IPs caused Windows to drop the network connection entirely (falling back to APIPA `169.254.x.x`) and trigger "Domain isn't available" errors on the login screen.

* **Resolution:** 
  1. Bypassed the domain lock using local credentials.
  2. Assigned unique static IPs (e.g., `192.168.50.24`) via `ncpa.cpl`.
  3. Pointed DNS directly to the Domain Controller at `192.168.50.10` to restore directory communication.

## 🗂️ Active Directory Organization

### Group Policy Targeting and Object Management

* **Issue:** Remote `gpupdate /force` commands from the server failed because the Windows 10 virtual machines were located in the default, unmanaged `Computers` container.

* **Resolution:** Transitioned to an enterprise-standard nested OU structure.
  * Created `IT_Users` and `IT_Computers` as Sub-OUs under the main `IT` department OU.
  * Separated User objects (e.g., Alice) and Computer objects (e.g., `CLIENT-01`) into their respective OUs.
  * This structure ensures hardware-level Group Policies apply accurately to machines without conflicting with user-level behavioral restrictions.


