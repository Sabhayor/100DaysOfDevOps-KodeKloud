# Day 2 - KodeKloud 100 Days of DevOps

## Task Overview

As part of a temporary assignment to the **Nautilus Project**, a developer named **yousuf** requires short-term access to **App Server 2** in the Stratos Datacenter.

To meet access management best practices, we need to:

* Create a **temporary Linux user**
* Ensure the username is **lowercase**
* Set an **account expiry date**

---

## Requirements

* **Username:** `yousuf`
* **Server:** App Server 2 (`stapp02`)
* **Account Expiry Date:** `2027-04-15`

---

## Step-by-Step Walkthrough

### Step 1: SSH into App Server 2

From the jump server or provided terminal, connect to App Server 2:

```bash
ssh steve@stapp02
```

> Enter the password when prompted.

---

### Step 2: Create the User with an Expiry Date

Use the `useradd` command with the `-e` flag to set the account expiry date during creation:

```bash
sudo useradd -e 2027-04-15 yousuf
```

#### Command Breakdown:

* `sudo` - Required for administrative privileges
* `useradd` - Creates a new Linux user
* `-e 2027-04-15` - Sets the account expiration date
* `yousuf` - Username (lowercase as required)

---

### Step 3: Verify the Account Expiry Date

Always verify to ensure correctness:

```bash
sudo chage -l yousuf
```

Expected output:

```text
Account expires                                : Apr 15, 2027
```

---

### Step 4: Confirm User Creation (Optional)

You can also verify that the user exists:

```bash
id yousuf
```


---

## Key Takeaway & Best Practices

* Use `useradd -e` when an expiry date is explicitly required
* Use `chage -l` to validate expiry configuration

