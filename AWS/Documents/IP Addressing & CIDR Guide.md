# IP Addressing & CIDR Guide

This document explains IP addressing fundamentals, IP classes, special ranges, how IPs are calculated, and how CIDR works.

---

## 1. **What is an IP Address?**

An IPv4 address is a 32-bit number written in **dotted decimal** format like:

```
192.168.4.1
```

Each of the 4 sections (called *octets*) represents 8 bits → 8 × 4 = 32 bits.

Internally:

```
192 = 11000000
168 = 10101000
4   = 00000100
1   = 00000001
```

---

## 2. **IP Classes (A, B, C, D, E)**

Historically, IPv4 addresses were divided into classes:

| Class | First Octet Range | Default Subnet Mask | Networks | Hosts  | Usage                   |
| ----- | ----------------- | ------------------- | -------- | ------ | ----------------------- |
| **A** | 0 – 127           | 255.0.0.0 (/8)      | Few      | Many   | Large networks          |
| **B** | 128 – 191         | 255.255.0.0 (/16)   | Medium   | Medium | Universities / Mid-size |
| **C** | 192 – 223         | 255.255.255.0 (/24) | Many     | Few    | Small networks          |
| **D** | 224 – 239         | N/A                 | N/A      | N/A    | Multicast               |
| **E** | 240 – 255         | N/A                 | N/A      | N/A    | Research                |

> **Modern networks no longer rely on classful addressing** but use CIDR (Classless Inter-Domain Routing). However, classes help us identify public/private ranges.

---

## 3. **Private IP Ranges (Must Remember)**

Only 3 blocks are private:

### **Class A Private Range**

```
10.0.0.0 – 10.255.255.255  (/8)
```

### **Class B Private Range**

```
172.16.0.0 – 172.31.255.255  (/12)
```

### **Class C Private Range**

```
192.168.0.0 – 192.168.255.255  (/16)
```

**How to remember easily?**

* **10** is fully private → think "large internal networks."
* **172** only middle part 16–31 → think "16 to 31 special."
* **192.168** → very common → think "home WiFi."

Anything outside these ranges is **public** unless reserved.

---

## 4. **Where Did the 127.x.x.x Range Go? (Loopback)**

The entire:

```
127.0.0.0 – 127.255.255.255
```

Is reserved for **loopback** (localhost). When you ping 127.0.0.1 you are pinging your own machine.

Why 127? Because:

* It is the **last network in Class A**
* Reserved by design for loopback/testing

---

## 5. **Why is 0 Special?**

There are two main uses:

### **1. Network Address (Identifies the network itself)**

Example:

```
192.168.1.0/24
```

The `.0` address represents the **network**, not a host.

### **2. Default Route (0.0.0.0/0)**

Means:

> "Send traffic to the gateway when no other route matches."

Used in:

* Routing tables
* Internet gateways (AWS IGW, routers, firewalls)

---

## 6. **How IPs Are Computed (Binary→Decimal)**

Each octet is 8 bits. Each bit has a value:

```
128 64 32 16 8 4 2 1
```

Example: IP **192**

```
128+64 = 192 → 11000000
```

Example: IP **168**

```
128 + 32 + 8 = 168 → 10101000
```

This is how computers store and process IP addresses.

---

## 7. **CIDR (Classless Inter‑Domain Routing)**

CIDR determines how many bits identify the network.

### Example: **192.168.4.0/24**

* **/24** means **24 bits for network**, 8 bits for host.
* Host bits = 2⁸ = 256 addresses
* Usable hosts = 256 − 2 = **254**
  (1 for network, 1 for broadcast)

### Example: **10.0.0.0/16**

* /16 → 16 bits network, 16 bits host
* Hosts = 2¹⁶ = 65,536

---

## 8. **Quick CIDR Memory Table**

| CIDR    | Host Bits | Total IPs | Usable Hosts |
| ------- | --------- | --------- | ------------ |
| **/30** | 2         | 4         | 2            |
| **/29** | 3         | 8         | 6            |
| **/28** | 4         | 16        | 14           |
| **/27** | 5         | 32        | 30           |
| **/26** | 6         | 64        | 62           |
| **/25** | 7         | 128       | 126          |
| **/24** | 8         | 256       | 254          |
| **/23** | 9         | 512       | 510          |
| **/22** | 10        | 1024      | 1022         |

---

## 9. **How to Calculate CIDR Quickly**

### Step 1: Identify the subnet mask

Example:

```
255.255.255.192
```

192 in binary:

```
11000000 → 2 bits for network
```

Network bits = 24 + 2 = **/26**

### Step 2: Block size = 256 − subnet value

```
256 − 192 = 64
```

So ranges are:

```
0–63
64–127
128–191
192–255
```

---

## 10. Summary

* IP = 32-bit number → 4 octets
* Classes A/B/C help identify basic ranges
* Private IPs are only in 10.x, 172.16–31.x, 192.168.x
* 127.x.x.x → loopback
* 0 is network + default route
* CIDR defines network/host split
* Block size = 256 − subnet mask value

10. Network and Broadcast IPs

Every subnet has two special addresses:
Network IP (first address): Identifies the subnet itself. Cannot be assigned to a host

Example:
192.168.4.0/24
Network IP = 192.168.4.0

Broadcast IP (last address): Sends traffic to all hosts in the subnet. Cannot be assigned to a host

Example:
192.168.4.0/24
Broadcast IP = 192.168.4.255
IP Range Example

📘 Subnetting Notes: 192.168.0.0/22 (Simple Version)
1. What does /22 mean?

IPv4 has 32 bits.
/22 means:

22 bits = network

10 bits = hosts
(because 32 − 22 = 10)

2. Subnet Mask for /22

Subnet mask = first 22 bits = 1, remaining 10 bits = 0

Binary mask:

11111111.11111111.11111100.00000000


Convert to decimal:

11111111 → 255

11111111 → 255

11111100 → 252

00000000 → 0

So:

Subnet Mask = 255.255.252.0
3. Why is the 3rd octet 252?

Because:

First 16 bits (2 octets) = full network

/22 → we need 6 more network bits

6 bits in 3rd octet = 11111100

Binary:
11111100 = 252

4. Block Size (Important)

Third octet block size:

256 − 252 = 4


So networks jump by 4:

0

4

8

12
… etc.

5. For 192.168.0.0/22

The block size is 4, starting from 0:

Network:

192.168.0.0

Broadcast:

Last IP before next block:
Next block = 192.168.4.0
Broadcast = previous one =
192.168.3.255

Usable Range:

From 192.168.0.1
To 192.168.3.254

Total IPs:

2¹⁰ = 1024 IPs

Usable hosts:

1024 − 2 = 1022 usable

Summary Table
Item	Value
CIDR	/22
Subnet Mask	255.255.252.0
Network	192.168.0.0
Broadcast	192.168.3.255
Usable Range	192.168.0.1 – 192.168.3.254
Total IPs	1024
Usable Hosts	1022
Block Size	4