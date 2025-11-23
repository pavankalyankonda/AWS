# AWS ↔ Azure AD Site-to-Site VPN Lab

**Goal (summary, simple):**
Create an AWS VPC with a Windows Server promoted to Active Directory Domain Controller (AD DC). Create an Azure VNet with a Windows Server. Build a Site-to-Site VPN between AWS (VGW) and Azure (Virtual Network Gateway). Join the Azure VM to the AWS AD domain, test authentication and file copy from the domain user.

---

## High-level architecture (ASCII)

```
  On‑Prem (optional)
      |
  Internet
      |
  AWS VPC (10.10.0.0/16)                 Azure VNet (10.20.0.0/16)
  ----------------------------             -------------------------
  | Subnet: AD (10.10.1.0/24) |             | GatewaySubnet (10.20.0.0/27) |
  |  Windows AD DC (private)  |             | VM Subnet (10.20.1.0/24)     |
  ----------------------------             -------------------------
         |                    \                 |
      Virtual Private        Peered? (not used)  Virtual Network Gateway
      Gateway (VGW)          *not transitive*     (public IP)
         |                                    
    Customer Gateway (AWS) <---- Site-to-Site VPN ---> Local Network Gateway (Azure)

Key: AWS AD DC acts as domain controller; Azure VM will use AWS AD DNS and join domain.
```

> Note: This doc uses example CIDRs — replace with yours.

---

## Prerequisites / assumptions

* AWS account & sufficient permissions to create VPC, VGW, Customer Gateway, EC2, Elastic IPs, and VPN.
* Azure subscription & permissions to create VNet, Virtual Network Gateway, Public IP, VM.
* Public IP that both sides can see (AWS VPN endpoint gets a public IP automatically for the VGW; Azure will have a public IP for its gateway).
* Basic Windows Server ISO/AMI for EC2 and Azure VM (Windows Server 2019/2022 recommended).
* Time to wait — gateway creation (Azure VPN GW) may take 20–40 minutes.

---

## Ports & firewall rules required (minimum for AD join & SMB)

Open between the two VNets (AWS <-> Azure) on the VPN tunnel and in Security Groups / NSGs / Windows Firewall:

* TCP 53 (DNS)
* UDP 53 (DNS)
* TCP 88 (Kerberos)
* TCP/UDP 389 (LDAP)
* TCP 445 (SMB / file shares)
* TCP 135 (RPC Endpoint Mapper)
* TCP 464 (Kerberos change password)
* TCP/UDP 123 (NTP - optional but recommended)
* Dynamic RPC range: TCP 49152–65535 (or a smaller projected range) — required for some AD operations

> If you want minimal exposure, restrict source IPs to the peer CIDRs (AWS VPC CIDR and Azure VNet CIDR).

---

## AWS: Step‑by‑step (concise)

1. **Create a VPC** (example 10.10.0.0/16).
2. **Create subnets**:

   * AD subnet (10.10.1.0/24) — place the AD DC here.
   * Other subnets as needed.
3. **Create an Internet Gateway** (attach only if you need internet access / RDP/WinRM). Add route to 0.0.0.0/0 in the subnet's route table.
4. **Create a Route Table** for the AD subnet.
5. **Launch EC2 Windows Server** in AD subnet.

   * Give it a private IP (e.g., 10.10.1.10). Optionally assign Elastic IP if you need RDP from internet.
   * Security Group (AD-SG): allow RDP from your admin IP (TCP 3389), and later allow the Azure CIDR for AD ports.
6. **Promote EC2 to Domain Controller (AD)**

   * Install AD DS role:

     ```powershell
     Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
     Install-ADDSForest -DomainName "pkaws.xyz" -SafeModeAdministratorPassword (ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force)
     ```
   * Reboot and confirm DC is up. Note AD DC private IP.
7. **Create/Configure a Virtual Private Gateway (VGW)**

   * AWS Console → VPC → Virtual Private Gateways → Create and Attach to your VPC.
8. **Create a Customer Gateway (represents Azure side)**

   * Provide Azure Gateway public IP and routing info (you can use static routing for lab).
9. **Create Site-to-Site VPN Connection** (VGW ↔ Customer Gateway)

   * Choose Static routes: list the Azure VNet CIDR (e.g., 10.20.0.0/16).
   * After creation, note the AWS VPN public IP(s) and tunnel configuration (pre-shared key).
10. **Route table update**

* Add a route in the AD subnet route table: Destination = Azure VNet CIDR (10.20.0.0/16), Target = Virtual Private Gateway (VGW).

11. **Security Groups & NACLs**

* Update AD-SG to allow inbound AD ports from Azure VNet CIDR.
* NACLs: ensure subnet-level allow for the Azure VNet CIDR for the same ports.

12. **Optional: Configure DNS**

* The AD DC will host DNS for the domain. Ensure the Azure VM uses AD DC private IP as its primary DNS.

---

## Azure: Step‑by‑step (concise)

1. **Create a VNet** (example 10.20.0.0/16) with subnets:

   * `GatewaySubnet` (must be named exactly "GatewaySubnet") e.g., 10.20.0.0/27
   * `VMSubnet` e.g., 10.20.1.0/24
2. **Create Virtual Network Gateway (VPN Gateway)**

   * Type: VPN
   * VPN type: Route-based (recommended)
   * SKU: Basic/VpnGw1 etc (lab: Basic or VpnGw1)
   * This takes ~20–40 minutes.
3. **Create a Public IP** for the gateway (Azure will create it).
4. **Create Local Network Gateway** (represents AWS):

   * Provide AWS public VPN endpoint IP and the AWS VPC CIDR (10.10.0.0/16).
5. **Create Connection** (Site-to-site) between Azure Virtual Network Gateway and Local Network Gateway

   * Use the same pre-shared key as AWS, add the AWS VPN public IP as peer.
   * Use Static routing (or BGP if you set up).
6. **Create Azure VM (Windows Server)** in VMSubnet

   * Set its network interface DNS server to point to AWS AD DC private IP (10.10.1.10) — network interface → DNS servers -> Custom.
   * Open NSG rules to allow RDP from your admin IP and AD ports from AWS CIDR as needed.
7. **Testing connectivity**

   * From Azure portal, connect to the VM using RDP (make sure gateway is up), then `ping 10.10.1.10` (may require ICMP allowed).

---

## Domain join steps (from Azure VM)

1. Ensure Azure VM uses AWS AD DC as DNS.
2. In Azure VM: `ipconfig /flushdns` and `nslookup <ad-dc-hostname>` should resolve to 10.10.1.10.
3. Join domain (GUI): System → Change settings → Computer Name → Domain: `pkaws.xyz` and provide domain admin credentials (e.g., `PKAWS\Administrator` and password).

   * Or PowerShell:

     ```powershell
     Add-Computer -DomainName "pkaws.xyz" -Credential (Get-Credential) -Restart
     ```
4. After reboot, log in using domain account `PKAWS\konp` (or `konp@pkaws.xyz`).

---

## File download and copy test (what happens and where)

* If you **open MS Edge on the Azure VM** and authenticate with the domain user (or run Edge as that domain user), any file you download through Edge will be saved to **that Azure VM's local user profile** (e.g., `C:\Users\konp\Downloads`).
* To copy a file from the AWS AD server to Azure VM using Windows share:

  1. On AWS AD DC, create a share (e.g., `C:\Share`) and grant share + NTFS permissions for `PKAWS\konp`.
  2. Ensure Windows Firewall on AD DC allows File and Printer Sharing (TCP 445) from Azure CIDR.
  3. On Azure VM, map the share:

     ```cmd
     net use Z: \\10.10.1.10\Share /user:PKAWS\konp <password>
     copy Z:\file.txt C:\Users\konp\Downloads\
     ```
  4. Alternatively use `\10.10.1.10\Share` in Run (Win+R) to open the UNC path.

> The file resides where you download it. If downloaded inside Azure VM’s Edge, it stays on Azure VM. If you copy from AD DC share, you fetch it across the VPN into Azure VM.

---

## Troubleshooting checklist (common issues)

* **Gateway not provisioned**: Azure VPN GW may still be creating — wait until state is Succeeded.
* **Routes missing**: Ensure both sides have route entries for the opposite CIDRs pointing to their gateway.
* **Security Groups / NSGs**: Confirm AD ports allowed and source/dest CIDRs are correct.
* **Windows Firewall**: Must allow SMB/AD ports on the Windows servers.
* **DNS**: If Azure VM cannot resolve domain name, domain join fails — set DNS to AD DC IP.
* **Non‑transitive caveat**: If you were using a third VPC and VGW attached to only one VPC, AWS will not forward traffic transitively.

---

## Minimal AWS Security Group example for AD DC (inbound)

* Source: Azure VNet CIDR (10.20.0.0/16) — allow TCP/UDP 53, TCP 88, TCP/UDP 389, TCP 445, TCP 135, TCP 49152-65535.
* Source: Your admin IP — allow RDP (3389).

## Minimal Azure NSG rules for VM subnet

* Allow inbound from AWS VPC CIDR for AD ports (same list above).
* Allow outbound to AWS VPC CIDR for AD ports.

---

## Security & production notes

* In production, **use IPsec/IKE with strong pre-shared keys or BGP with authentication**.
* For real deployments consider **AWS Transit Gateway** or **Azure ExpressRoute / Direct Connect** for large scale and better performance.
* Limit dynamic RPC ports via registry if you must reduce the ephemeral port range.
* Monitor VPN tunnel health and latency.

---

## Quick test commands (Windows)

* `whoami` — shows current user
* `hostname` — shows machine name
* `set` — shows environment variables
* `ping <ip>` — ICMP check
* `nslookup <domain-controller>` — DNS resolution
* `nltest /sc_query:pkaws.xyz` — check secure channel to domain

---

## Summary checklist (do these in order)

1. Create VPC (AWS) + Subnets + EC2 (AD DC) + promote to AD
2. Create VGW, Customer Gateway (azure public IP), VPN connection, add route on AWS route table
3. Create Azure VNet, GatewaySubnet, Virtual Network Gateway, Local Network Gateway (AWS public IP + AWS CIDR), create connection
4. Create Azure VM and set DNS to AWS AD DC IP
5. Open firewall/SG/NSG rules (AD ports between CIDRs)
6. Join Azure VM to domain and test file sharing

---
