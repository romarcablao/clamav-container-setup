## CFN Template for ClamAV Instance

[![GitHub](https://img.shields.io/badge/GitHub-romarcablao-lightgrey)](https://github.com/romarcablao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-romarcablao-blue)](https://linkedin.com/in/romarcablao)

### Operating System

This template uses Ubuntu 20.04 LTS. You can change and choose your prefered AMI for this template.

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
