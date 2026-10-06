# Active Directory Home Lab

## Overview
This repository contains documentation, scripts, and resources for setting up and managing an Active Directory home lab environment.

## Purpose
A hands-on learning environment for exploring Active Directory concepts, user management, group policies, and domain administration in a safe, isolated setting.

## Contents
- [Infrastructure Set Up](docs/infrastructure-setup)
- [GPO Configuration](docs/gpo-configurations/)
- Troubleshooting
- Bulk User Creation

## Environment Specifications

This lab was built and tested on a localized host machine utilizing isolated virtual networking to simulate an enterprise domain.

**Hardware (Host):**
* **Memory & Storage:** 32 GB RAM and 1 TB SSD (Providing high I/O for rapid VM provisioning and snapshotting)
* **GPU:** NVIDIA GeForce RTX 5060

**Software & Virtualization:**
* **Hypervisor:** VMware Workstation Pro 
  * *Note: Deployed using Linked Clones and a custom VMnet2 Host-Only isolated network to prevent DHCP conflicts.*
* **Domain Controller OS:** Windows Server 2022 Standard (Desktop Experience)
* **Client OS:** Windows 10/11 Enterprise Evaluation
## Getting Started
1. Review the documentation in the repository
2. Follow the setup guides
3. Execute configuration scripts as needed
4. Refer to examples for specific use cases

## Features
- Active Directory setup and configuration
- User and group management
- Group Policy implementation
- Domain controller setup

## Contributing
Feel free to contribute improvements, bug reports, or additional resources to this project.

## License
This project is open source and available under the MIT License.

## Resources
- [Microsoft Active Directory Documentation](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-domain-services)
- [Active Directory Best Practices](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/best-practices/)

## Contact
For questions or issues, please open a GitHub issue in this repository.

---
*Last updated: September 5, 2026*
