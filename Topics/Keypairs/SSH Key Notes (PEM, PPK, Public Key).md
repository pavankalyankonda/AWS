# SSH Key Notes (PEM, PPK, Public Key, Conversions & Usage)

## 1. PEM File

* **PEM = Privacy Enhanced Mail**
* Contains your **private key**.
* Used on: Linux, macOS, Windows PowerShell, Git Bash, WSL.
* SSH example:

```
ssh -i mykey.pem user@IP
```

---

## 2. PPK File

* **PPK = PuTTY Private Key**
* Required for **PuTTY** on Windows.
* PuTTY cannot use .pem directly.

---

## 3. Public Key (.pub)

* Safe to share.
* Stored on VM during creation.
* Used by server to verify your private key.

```
ssh-rsa AAAAB3NzaC1...
```

### Where AWS EC2 places the public key on the VM

For Amazon Linux / Ubuntu EC2 instances:

```
/home/ec2-user/.ssh/authorized_keys
```

(or corresponding username, e.g. ubuntu)

---

## 4. How Keys Work Together

| Key                    | Purpose                | Stored Where  | Safe to Share? |
| ---------------------- | ---------------------- | ------------- | -------------- |
| **Public key (.pub)**  | Verifies your identity | On the server | Yes            |
| **Private key (.pem)** | Your identity proof    | Your machine  | No             |
| **Private key (.ppk)** | Same but PuTTY format  | Your machine  | No             |

---

## 5. When to Use Which Key

### Use **PEM** when connecting from:

* Linux/macOS terminal
* Windows PowerShell (OpenSSH)
* Git Bash
* WSL

```
ssh -i mykey.pem ec2-user@IP
```

### Use **PPK** when connecting from:

* PuTTY
* WinSCP (PuTTY auth agent)

---

## 6. Convert Keys

### Convert PEM → PPK

Using PuTTYgen:

1. Open PuTTYgen
2. Load `.pem`
3. Save private key → `.ppk`

### Convert PPK → PEM

1. Open PuTTYgen
2. Load `.ppk`
3. Conversions → Export OpenSSH key → `.pem`

---

## 7. Extract Public Key from PEM

```
ssh-keygen -y -f mykey.pem > mykey.pub
```

---

## 8. Fix Permissions for PEM

```
chmod 400 mykey.pem
```

---

## 9. Summary

* **PEM** = private key for OpenSSH
* **PPK** = private key for PuTTY
* **Public key** stored in `authorized_keys`
* Convert using **PuTTYgen**
* Never share private keys
