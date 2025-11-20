Linux: Setting Environment Variables
## 1️⃣ What is an Environment Variable?

Environment variables store settings that your shell or programs can use.

## Example:

export PATH
export AWS_ACCESS_KEY_ID

## 2️⃣ Where do we set environment variables?

You usually put them inside:

✔️ ~/.bashrc (for a normal user)

This file runs automatically when the user opens a terminal.

Changes apply only to that user.

✔️ /root/.bashrc (for root user)

Runs only for the root user.

Separate from normal user’s .bashrc.

## 3️⃣ What is ~ ?

~ (tilde) means home directory of the logged-in user.

Example:

User	Actual Home Path	~ Means
ubuntu	/home/ubuntu	/home/ubuntu
ec2-user	/home/ec2-user	/home/ec2-user
root	/root	/root

So:

If you're logged in as ubuntu, running:
nano ~/.bashrc → opens /home/ubuntu/.bashrc

If you're logged in as root, running:
nano ~/.bashrc → opens /root/.bashrc

## 4️⃣ How to set an environment variable

Example: setting AWS CLI credentials.

Step 1 — Edit .bashrc
nano ~/.bashrc

Step 2 — Add your variables at the bottom:
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_DEFAULT_REGION="us-east-1"

Step 3 — Save and exit

(CTRL + O, ENTER, CTRL + X)

## 5️⃣ What is source?

After editing .bashrc, Linux does not load the changes automatically.

You must run:

source ~/.bashrc


Meaning:
Reload the .bashrc file without restarting the terminal.

## 6️⃣ How to check if variables are set
echo $AWS_ACCESS_KEY_ID
echo $AWS_DEFAULT_REGION


If properly configured, they display values.

## 7️⃣ Example Scenarios
✔️ Logged in as ubuntu
whoami
ubuntu
nano ~/.bashrc     # edits /home/ubuntu/.bashrc
source ~/.bashrc

✔️ Logged in as root
whoami
root
nano ~/.bashrc     # edits /root/.bashrc
source ~/.bashrc


Each user has its own .bashrc file and its own environment variables.

## ✅ Summary (Very Simple)

~ = home folder of current user

.bashrc = file that loads every time you open a terminal

Add environment variables inside .bashrc

Run source ~/.bashrc to activate changes

Each user has their own .bashrc