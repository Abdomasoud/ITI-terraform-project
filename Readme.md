# Terraform ITI Project Assignment

## Networking

1. **Create a VPC**
2. **Create an Internet Gateway**
3. **Create a Public Route Table**
4. **Create a Private Route Table**
5. **Create a Public Route**
6. **Attach the Public Route Table to Subnets**

## Compute

7. **Create a Security Group**: Allow SSH from `0.0.0.0/0`.
8. **Create a Security Group**: Allow SSH and port `3000` from VPC CIDR only.
9. **Create an EC2 Instance (Bastion)**: Place it in the public subnet with the security group from step 7.
10. **Create an EC2 Instance (Application)**: Place it in the private subnet with the security group from step 8.

## Additional Steps

11. **Create Two Workspaces**: Create `dev` and `prod` workspaces.
12. **Create Variable Definition Files**: Create two `.tfvars` files for the `dev` and `prod` environments.
13. **Separate Network Resources**: Move network resources into a reusable network module.
14. **Apply Code for Two Environments**: Deploy the infrastructure in `us-east-1` and `eu-central-1` regions.
15. **Run Local-Exec Provisioner**: Print the public IP of the Bastion EC2 instance using the `local-exec` provisioner.
16. **Upload Code to GitHub**: Upload the Terraform infrastructure code to a GitHub project.
17. **Create Jenkins Image**: Build a Jenkins image with Terraform pre-installed.
18. **Create Jenkins Pipeline**: Create a pipeline that accepts an environment parameter (`env-param`) to apply Terraform code to a specific environment.
19. **Verify Email in SES**: Verify your email address in the AWS SES service.
20. **Create Lambda Function**: Create a Lambda function to send emails.
21. **Create Trigger for State File Changes**: Set up a trigger to detect changes in the Terraform state file and send an email notification.

## Database and Application

22. **Create RDS**: Deploy an RDS instance for database needs.
23. **Create Elastic Cache**: Deploy an Elastic Cache instance for caching.
24. **Deploy Node.js App**: Use Jenkins to deploy a Node.js application on the application EC2 instance.
