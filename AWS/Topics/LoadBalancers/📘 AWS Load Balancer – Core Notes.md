📘 AWS Load Balancer – Core Notes
✅ 1. Only One ALB is Billed

Even if AWS creates multiple load balancer nodes, you pay for one ALB resource, not per node.

AWS internally creates:

1 LB node per Availability Zone (AZ) you enable

These nodes provide High Availability

Billing is NOT based on nodes.

✅ 2. What Happens if One LB Node Fails?

If an ALB node fails:

Node in AZ-1a → fails  
Node in AZ-1b → continues serving traffic


Traffic is automatically routed through healthy nodes.

No downtime.
No manual work.

✅ 3. What You Actually Pay For

The ALB cost is based on:

✔ 1. ALB hourly charge (one per LB)
✔ 2. LCU usage (Load Balancer Capacity Units), based on:

New connections/second

Active connections

Processed bytes

Rule evaluations

Traffic volume drives the bill — not node count.

✅ 4. Why the ALB Must Be in Public Subnets (Internet Facing LB)

Because it needs:

A public IP

A route to the Internet Gateway (IGW)

This allows external users to access your application.

✅ 5. ALB Can Still Send Traffic to Private Subnets

Even though the LB is in public subnets, it can forward traffic to private EC2 instances inside the VPC.

Flow:

User → Internet → IGW → Public Subnet → ALB → Private Subnet → EC2

✅ 6. ALB and Availability Zones Explained

When you create an ALB:

You must select at least 2 AZs

AWS creates one LB node per selected AZ

LB nodes scale automatically with traffic

ALB routes traffic only to targets in selected AZs.

✅ 7. Cross-AZ Traffic

If an ALB node in one AZ routes to an EC2 in another AZ:

➡ You pay cross-AZ data charges.

AWS tries to route to targets in the same AZ to avoid these costs.

🟢 8. Summary

You pay for ONE ALB, not its internal nodes

AWS runs multiple LB nodes for HA (free)

LB must be in public subnets to be internet-facing

Private EC2s are accessible through the LB

Traffic amount, not node count, determines cost

Cross-AZ routing costs extra

Best practice: LB in 2+ public subnets, EC2s in matching private subnets