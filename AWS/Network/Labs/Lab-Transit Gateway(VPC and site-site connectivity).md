This lab provides instructions on:
1. How to create connectivity between 3 VPCs using Transit Gateway.
2. How to connect to Azure from AWS using the Site-to-site VPN connection by implementing VPN connection on both clouds and then
connect to Azure VM from AWS from all VPCs(connected via TGW) 

# AWS ↔ Azure TGW + Site-to-Site VPN — Lab Documentation

---

## Overview / Goal

Implement site-to-site VPN connectivity from Azure VNet → AWS across an **AWS Transit Gateway (TGW)** that connects **three AWS VPCs**:

* VPC-A: `192.168.0.0/16` (attachment: `tgw-attach-0218...`)
* VPC-B: `172.31.0.0/16` (attachment: `tgw-attach-029b...`)
* VPC-C: `10.53.0.0/16` (attachment: `tgw-attach-080e...`)
* Azure VNet: `172.16.0.0/16`
* A Site-to-Site VPN attachment to the TGW to link Azure and AWS (attachment: `tgw-attach-0a74...`, VPN id `vpn-0604...`)

You deployed one server in each VPC (public subnet) and one Windows VM in Azure. You configured security groups / NSGs and routes, established the VPN tunnels, and validated connectivity.

---

## 1 — What is a Transit Gateway and why prefer it over a Virtual Private Gateway for multi-VPC/peering

**Transit Gateway (TGW)** is a regional, highly available, managed router that centralizes routing between VPCs, VPNs, and Direct Connect.
**Virtual Private Gateway (VGW)** is an AWS-managed VPN endpoint attached to a single VPC.

**Why TGW is recommended for multi-VPC architectures:**

* **Scalability & hub model:** TGW offers a hub-and-spoke design where many VPCs can attach to a single TGW. VGW is per-VPC and requires peering/point-to-point links.
* **Single control plane:** One TGW route table manages traffic flows between many VPCs and external on-prem networks.
* **Simpler management:** No mesh of VPC peering links (which grow O(N²)). Add/remove VPCs by creating/removing attachments and TGW routes.
* **VPN & Direct Connect at hub:** One VPN/Direct Connect attachment can serve many VPCs without replicating tunnels for each VPC.
* **Route isolation and routing policies:** TGW route tables allow flexible control (associate/propagate, multiple route tables).

**When VGW might still be okay:** single-VPC VPNs or simpler one-off connections. For multi-VPC + hybrid cloud, TGW is cleaner.

---

## 2 — Lab design and resources (what you created)

**AWS**

* Transit Gateway (TGW)
* TGW Attachments:

  * `tgw-attach-0218...` → VPC `192.168.0.0/16`
  * `tgw-attach-029b...` → VPC `172.31.0.0/16`
  * `tgw-attach-080e...` → VPC `10.53.0.0/16`
  * `tgw-attach-0a74...` → VPN attachment (to Azure)
* TGW Route Table (one or more; associated with all above attachments)
* VPC route tables: per-subnet route tables that send external CIDRs to *this VPC’s* TGW attachment
* EC2 instances: Linux servers in public subnets (for testing)
* Security Groups: open to required CIDR ranges (other VPC CIDRs & Azure VNet) for SSH/ICMP (temporary)

**Azure**

* Azure VNet: `172.16.0.0/16` with a Windows VM
* Azure VPN Gateway (VNet Gateway) — public IP assigned
* Local Network Gateway(s) — configured with AWS side VPN public IP(s) and AWS CIDRs
* VPN Connections — using PSKs downloaded from AWS config / entered into Azure connections, BGP enabled if used

---

## 3 — Step-by-step actions (what you did) and why each step matters

### A. Create 3 VPCs and EC2s

* Create VPCs with CIDRs: `192.168.0.0/16`, `172.31.0.0/16`, `10.53.0.0/16`.
* Create public subnets and launch Linux EC2s (for tests).

**Why:** provides separate networks to validate TGW routing between multiple VPCs and to Azure.

---

### B. Create Transit Gateway & Attach VPCs

1. Create TGW (choose a numeric ASN if needed; default 64512 is fine unless you must match customer ASN).
2. For each VPC: Create **TGW Attachment** → select VPC and subnet(s).
3. In TGW → Route Tables:

   * Create/choose a TGW route table.
   * **Associate** all VPC attachments and the VPN attachment to this TGW RT.

**Why:** attachments associate resources to the TGW; association ensures the TGW route table is active for those attachments.

---

### C. Configure VPC route tables (important detail)

For each VPC subnet route table (the one associated with your EC2), add routes to send traffic destined for other networks via the **TGW attachment for that VPC**.

Example for `10.53.0.0/16` VPC (route table attached to EC2 subnet):

```
Destination: 172.31.0.0/16  → Target: <TGW attachment for 10.53 VPC>
Destination: 192.168.0.0/16 → Target: <TGW attachment for 10.53 VPC>
Destination: 172.16.0.0/16  → Target: <TGW attachment for 10.53 VPC>    # Azure VNet
```

> Note: in the VPC route table UI you will only see the TGW attachment that belongs to the same VPC. That is correct — select that.

**Why:** traffic from an EC2 leaves the VPC only when its subnet route table points the destination toward the TGW attachment. Without these, traffic never reaches the TGW.

---

### D. TGW route table entries (how routes are created and whether static or propagated)

**What you must have in the TGW route table** (destination → attachment):

```
10.53.0.0/16    → tgw-attach-080e...   (VPC C)
172.31.0.0/16   → tgw-attach-029b...   (VPC B)
192.168.0.0/16  → tgw-attach-0218...   (VPC A)
172.16.0.0/16   → tgw-attach-0a74...   (VPN attachment to Azure)
```

* **How these routes get added:** Typically you **add them manually** into the TGW route table.
* **Route propagation:** TGW supports route propagation from attachments (VPN or Direct Connect) so learned routes may be auto-propagated depending on attachment type and settings (e.g., BGP learned routes from a VPN attachment can propagate). In this lab you added entries manually to be explicit.

**Clarification for your note:**

> *“did I choose the TGW attachment as static route or not?”*
> You likely added static TGW routes mapping each destination CIDR to the corresponding attachment. That is the normal and explicit method. If you had enabled route propagation for VPN and wanted BGP-learned prefixes, the TGW could accept those automatically— but for a predictable lab, static TGW routes are the clean approach.

**Why:** TGW needs to know which attachment to forward traffic to — associations alone do not define the forwarding destination.

---

### E. Security: Security Groups (SGs) & NACLs

* On each EC2 SG (temporary for testing): allow inbound from the other VPC CIDRs and Azure VNet CIDR for ports tested:

  * SSH (TCP 22) from `10.53.0.0/16`, `172.31.0.0/16`, `172.16.0.0/16`
  * ICMP (Echo Request) — for ping tests
* Ensure outbound rules allow return traffic.
* NACLs should be permissive for test (stateful SGs handle return traffic, but NACLs are stateless).

**Why:** even with correct routing, SGs/NACLs can block traffic. Start permissive for validation then tighten.

---

### F. Create Customer Gateway & Site-to-Site VPN (AWS side)

1. Create **Customer Gateway** in AWS and provide Azure VPN Gateway’s **public IP** (Outside IP).

2. Create **Site-to-Site VPN Connection**:

   * Attach to the TGW (so TGW gets a VPN attachment)
   * Enter AWS-side Local CIDR and Remote CIDR fields (defaults are 0.0.0.0/0 for broad selectors; Local=Azure private CIDR, Remote = 0.0.0.0/0 often used)
   * Choose dynamic routing (BGP) or static — for Azure you can use BGP or static depending on VPN Gateway type. In lab you used Azure connection and PSKs.

3. **Get the config / PSKs:**

   * Download the VPN configuration from AWS (choose vendor Microsoft/ Azure or Generic). The downloaded file contains:

     * Public/Outside IPs for both tunnels
     * Pre-Shared Keys (PSKs) for tunnel 1 & 2
     * Inside VPN IP addresses (for IKE/BGP)
     * BGP settings if used

**Why:** the Customer Gateway and VPN config provide the tunnel endpoints and keys that Azure needs to build the IPSec tunnels.

---

### G. Azure side: Local Network Gateway(s) and VPN Connection(s)

1. Create **Local Network Gateway (LNG)** in Azure:

   * Public IP: AWS VPN public IP (Tunnel endpoint)
   * Address space: add the **AWS VPC CIDRs**:

     * `10.53.0.0/16`
     * `172.31.0.0/16`
     * `192.168.0.0/16`
   * (Azure allows multiple address ranges here.)

2. Configure VPN **Connection** on Azure:

   * Use the AWS public IP(s) and **preshared keys** retrieved from AWS config.
   * For each tunnel, configure the PSK and the peer IP as provided.
   * Enable **BGP** if using dynamic routing and match ASNs (AWS TGW ASN default 64512; Azure default ASN often 65515 — ensure they differ or configure accordingly).

**Why:** Azure needs to know which remote address blocks are reachable via the VPN and the AWS tunnel endpoints and PSKs to form secure tunnels.

---

### H. TGW route to Azure and EC2 route updates

* **TGW Route Table:** Add a route `172.16.0.0/16` → VPN attachment (we did this manually in the lab).

  * *Assumption:* you added it manually; it can also be learned from BGP if configured and propagated.
* **VPC route tables:** For each VPC subnet (the one hosting EC2), add:

  ```
  Destination: 172.16.0.0/16 → Target: <TGW attachment for that VPC>
  ```

  That ensures packets from EC2 go to TGW, then TGW sends to VPN.

**Why:** Both TGW and VPC route tables must contain the Azure VNet route so that the packet flows EC2 → subnet RT → TGW attachment for that VPC → TGW route table → VPN attachment → Azure.

---

### I. Test connectivity & validation steps (what you did)

1. **Check AWS VPN**: Confirm tunnels are UP in AWS Console → Site-to-Site VPN.
2. **Azure VPN**: Confirm connection shows **Connected**.
3. From **Azure Windows VM**:

   * Disable Windows Firewall for testing and ensure NSG outbound allows traffic to AWS CIDRs.
   * Use `tracert <AWS EC2 private IP>` (ICMP/TTL may not reveal all hops; OK).
   * Use PowerShell TCP test:

     ```powershell
     Test-NetConnection -ComputerName <AWS-EC2-Private-IP> -Port 22
     ```

     Expect: `TcpTestSucceeded : True`
4. From **AWS Linux EC2**:

   * Install traceroute if needed:

     ```bash
     sudo apt update && sudo apt install -y traceroute  # Ubuntu
     sudo yum install -y traceroute  # Amazon Linux / RHEL
     ```
   * Test RDP port on Azure if checking from Linux:

     ```bash
     nc -vz <Azure-VM-Private-IP> 3389
     ```
   * Or traceroute:

     ```bash
     sudo traceroute 172.16.x.x
     ```

**Why:** these tests verify routing, firewall (SG/NSG) and tunnel functioning. Use TCP tests where ICMP is blocked.

---

## 4 — Exact config items you should have (concise checklist)

### TGW / AWS

* TGW created (ASN documented)
* Attachments: one per VPC + one VPN attachment
* TGW Route Table:

  * `10.53.0.0/16 → tgw-attach-080e...`
  * `172.31.0.0/16 → tgw-attach-029b...`
  * `192.168.0.0/16 → tgw-attach-0218...`
  * `172.16.0.0/16 → tgw-attach-0a74...` (VPN)
* TGW Associations: all attachments associated with the TGW RT
* Subnet route tables for each EC2 subnet:

  * Add route `172.16.0.0/16 → <this VPC’s TGW attachment>`
  * Add routes to other VPCs as needed (destination → this VPC’s TGW attachment)
* EC2 SG: inbound SSH (22) from `10.53.0.0/16`, `172.31.0.0/16`, `172.16.0.0/16` (and ICMP if testing)
* NACL: allow relevant traffic if used

### Azure

* Local Network Gateway: AWS public IP + AWS CIDR address space entries
* VPN Connection(s): PSKs entered from AWS config; BGP enabled if used
* Virtual Network: `172.16.0.0/16` with Windows VM
* NSG: allow inbound RDP from AWS CIDRs; outbound to AWS allowed
* Windows firewall: allow RDP (or temporarily disabled for tests)

---

## 5 — Important clarifications / assumptions I made for this doc

* You manually added static routes in the TGW route table. (TGW can accept propagated routes from VPN attachments when BGP is used; for clarity labs typically add static TGW routes.)
* VPC route table changes were applied to the specific **subnet’s route table** that the EC2 instance uses (not necessarily the main table).
* You used the PSKs obtained from “Download configuration” on the AWS VPN connection for the Azure connection setup.

---

## 6 — Troubleshooting checklist (if connectivity fails)

1. **Subnets not using the route table you edited:** confirm subnet → associated route table.
2. **Missing TGW route table entries:** ensure TGW RT contains the Azure CIDR pointing to the VPN attachment.
3. **Attachment not associated with TGW RT:** in TGW → Route Tables → Associations, ensure each attachment is associated.
4. **VPC route does to wrong target:** ensure VPC route points to your VPC’s TGW attachment (only that attachment will appear).
5. **SG / NSG / Windows Firewall:** temporarily permit all traffic from other sides and re-test.
6. **VPN tunnel status:** check both sides show tunnels UP and BGP session established if using BGP.
7. **Azure Local Network Gateway address space:** ensure all AWS VPC CIDRs are present (Azure requires them for local network gateway).
8. **PSK / IKE mismatch:** verify pre-shared keys match and the Azure connection was configured using correct peer IPs.
9. **Traceroute shows `* * *` intermediate hops:** this is expected across TGW/VPN; focus on final hop and TCP tests.
10. **Confirm route propagation / BGP:** if you rely on BGP to learn routes, verify BGP peerings and route propagation settings on TGW.

---

## 7 — Useful commands (copy/paste)

**On AWS Linux EC2**

```bash
# install traceroute (if missing)
sudo apt update && sudo apt install -y traceroute     # Ubuntu
sudo yum install -y traceroute                        # Amazon Linux/CentOS

# traceroute
sudo traceroute 172.16.0.4

# test TCP from Linux (Netcat)
nc -vz 172.16.0.4 3389     # test RDP on Azure
nc -vz 172.16.0.4 80       # test HTTP

# show instance metadata (to find VPC/subnet)
curl http://169.254.169.254/latest/meta-data/local-ipv4
curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/
```

**On Windows (Azure VM, PowerShell)**

```powershell
# Test TCP connectivity
Test-NetConnection -ComputerName 192.168.2.189 -Port 22
Test-NetConnection -ComputerName 10.53.0.8 -Port 22 -TraceRoute

# traceroute (cmd.exe)
tracert 10.53.0.8

# Enable RDP firewall rule on Windows remotely (via Azure Run Command)
Set-NetFirewallRule -DisplayGroup "Remote Desktop" -Enabled True
```

**On AWS Console**

* VPC → Route Tables → verify subnet route table entries
* Transit Gateway → Route tables → verify routes & associations
* VPC → Subnets → verify route table association
* EC2 → Security groups → verify inbound/outbound rules
* Site-to-Site VPN → Download Configuration / View Tunnel details → PSKs and inside IPs

**On Azure Portal**

* Virtual Network → Subnets → confirm VM’s subnet
* Local network gateway → verify address spaces include AWS CIDRs
* VPN gateway → Connections → check Status (Connected) and PSK usage
* VM → Networking → Check NSG and effective security rules

---

## 8 — Final summary (one paragraph)

You implemented a hub-and-spoke hybrid network: three AWS VPCs attached to a single Transit Gateway, and a Site-to-Site VPN from the TGW to an Azure VNet. Each VPC uses a TGW attachment and its subnet route tables to forward Azure traffic to TGW; the TGW route table forwards Azure traffic to the VPN attachment. On the Azure side, Local Network Gateway and VPN connections were configured using the AWS-supplied pre-shared keys and AWS public IPs. Security group and NSG rules were opened for testing. Connectivity was validated using TCP tests (`Test-NetConnection` on Windows, `nc` on Linux) and traceroutes, and final confirmation was a successful bidirectional connection between Azure Windows VM and AWS Linux VM.

---

