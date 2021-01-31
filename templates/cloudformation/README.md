## CFN Template for ClamAV Instance

[![GitHub](https://img.shields.io/badge/GitHub-romarcablao-lightgrey)](https://github.com/romarcablao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-romarcablao-blue)](https://linkedin.com/in/romarcablao)

### Operating System and Instance Specs

This template uses Ubuntu 20.04 LTS. You can change and choose your prefered AMI for this template.

| Instance Type | vCPUs | vMem | OS               |
| ------------- | ----- | ---- | ---------------- |
| t3a.medium    | 2     | 4GiB | Ubuntu 20.04 LTS |

[EC2 Instance Savings Plans with 1 Year Reservation Cost](https://calculator.aws/#/estimate?id=0bb35d0a5b5ad7cbbfc90a23c53cf87d68bed03d)

### Security Group

You can limit the inbound rules to specific IP or IP CIDR Block by defining it the security group.

```yaml
GroupDescription: ClamAV Server Security Group
SecurityGroupIngress:
  - IpProtocol: tcp
    FromPort: "443"
    ToPort: "443"
    CidrIp: "50.168.10.0/32"
```
