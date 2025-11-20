# **AWS Security Groups & NACLs – Simple Documentation**

## ⭐ 1. What Are SGs and NACLs?

### **Security Group (SG)**

* Works at **instance level** (EC2, ENI, RDS, etc.)
* **Stateful** → if inbound is allowed, outbound is automatically allowed
* Controls access **to/from a specific server**

### **Network ACL (NACL)**

* Works at **subnet level**
* **Stateless** → must allow both inbound and outbound
* Controls access **before traffic reaches any server**
* Can explicitly **DENY** traffic (SG cannot deny)

---

## 2. Why Do We Need Both?

| Feature                 | SG | NACL             |
| ----------------------- | -- | ---------------- |
| Instance-level control  | ✔️ | ❌                |
| Subnet-level firewall   | ❌  | ✔️               |
| Stateful                | ✔️ | ❌                |
| Allow rules only        | ✔️ | ❌ (allow + deny) |
| Protects before server? | ❌  | ✔️               |
| Block malicious IPs     | ❌  | ✔️               |

**In real architectures, SG is the seatbelt, NACL is the airbag.
Both protect you at different layers.**

---

## 3. Our Real-Time Architecture Example

## VPCs & IP Ranges

| VPC Name                             | CIDR             |
| ------------------------------------ | ---------------- |
| **VPC-A** (App Layer)                | `10.53.0.0/16`   |
| **VPC-B** (Monitoring/Logs)          | `172.16.0.0/16`  |
| **VPC-C** (Shared Services: AD, DNS) | `192.168.0.0/16` |

### Goal

App servers in **VPC-A** should reach **AD + DNS** servers in **VPC-C**, but **only on**:

* **Port 53 (DNS)**
* **Port 389 (LDAP / AD)**

No other traffic should be allowed between these VPCs.

---

## 4. How SG and NACL Work Together Here

## 🔹 Step 1 — SECURITY GROUPS (Instance-Level)

### **SG on AD/DNS server in VPC-C**

Inbound rules:

| Type | Port | Source              |
| ---- | ---- | ------------------- |
| DNS  | 53   | SG-App (from VPC-A) |
| LDAP | 389  | SG-App (from VPC-A) |

**What this gives us:**
✔ Only specific ports allowed
✔ Only from *app servers*
✔ If an app server is hacked → the compromised server can scan ports
❗ BUT SG can’t **deny** or stop subnet-wide scanning attempts
❗ SG cannot block IP ranges

---

## 🔹 Step 2 — NACLs (Subnet-Level)

### **Shared Services Subnet NACL (in VPC-C)**

Inbound Rules:

| Rule | Source         | Port | Action |
| ---- | -------------- | ---- | ------ |
| 100  | `10.53.0.0/16` | 53   | ALLOW  |
| 110  | `10.53.0.0/16` | 389  | ALLOW  |
| 200  | `0.0.0.0/0`    | ALL  | DENY   |

Outbound Rules:

| Rule | Destination    | Port | Action |
| ---- | -------------- | ---- | ------ |
| 100  | `10.53.0.0/16` | 53   | ALLOW  |
| 110  | `10.53.0.0/16` | 389  | ALLOW  |
| 200  | `0.0.0.0/0`    | ALL  | DENY   |

**What this gives us:**
✔ No one else can touch AD/DNS
✔ Even if the SG allows something, NACL blocks all other ports
✔ Subnet-level protection
✔ Prevents port scans from hitting *all servers*

---

## 5. Your Main Doubt Answered Simply

### ❓ *If the app server is compromised, can't it reach VPC-C since SG + NACL already allow the range?*

### ✔ YES, **but only on ports 53 and 389**, nothing else.

### ✔ NO, it cannot:

* Scan 1,000 ports
* Attack other servers
* Reach any other service in VPC-C
* Laterally move (sideways attack)

### Why?

Because **NACL blocks everything else** before it even enters the subnet.

---

## 6. What If NACL Didn’t Exist?

If you used only SGs:

* A hacked app server could port-scan AD/DNS servers
* Though SG silently drops other ports, CPU/Memory on the AD/DNS may be affected
* Attack surface increases
* Lateral movement becomes possible
* Subnet gets no protection

**NACL reduces the blast radius massively.
It acts as a subnet firewall to stop bad traffic early.**

---

## 7. Example of Blocking a Malicious IP Range Using NACL

Suppose you detect malicious traffic from:

```
45.123.10.0/24
```

### Add NACL Inbound Rule:

| Rule | Source           | Port | Action |
| ---- | ---------------- | ---- | ------ |
| 50   | `45.123.10.0/24` | ALL  | DENY   |

### Add NACL Outbound Rule:

| Rule | Destination      | Port | Action |
| ---- | ---------------- | ---- | ------ |
| 50   | `45.123.10.0/24` | ALL  | DENY   |

**Done. Traffic is blocked instantly at the subnet.**

SG **cannot** do this because SG has no deny rule.

---

## 8. Final Summary (Use This in Interviews)

### **SG**

* Instance firewall
* Stateful
* Allow only
* Secures specific servers

### **NACL**

* Subnet firewall
* Stateless
* Allow + Deny
* Blocks bad IP ranges
* Protects against port scanning & lateral movement

### **Together**

* SG protects the *server*
* NACL protects the *subnet*

---
