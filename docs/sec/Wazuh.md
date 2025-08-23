# Wazuh

The Open Source Security Platform

Unified XDR and SIEM protection for endpoints and cloud workloads.

https://wazuh.com/

参考文章：https://l0n9w4y.cc/posts/22306/

## 测试环境

Sever:

- SOC-wazuh 192.168.208.145

Agent:

- Linux: Falco-rengine 192.168.208.139
- Win: 



## Wazuh central

### Requirements

| **Agents** | **CPU** | **RAM** | **Storage (90 days)** |
| ---------- | ------- | ------- | --------------------- |
| **1–25**   | 4 vCPU  | 8 GiB   | 50 GB                 |
| **25–50**  | 8 vCPU  | 8 GiB   | 100 GB                |
| **50–100** | 8 vCPU  | 8 GiB   | 200 GB                |



### Operating system

Wazuh central components can be installed on a 64-bit Linux operating system. Wazuh recommends any of the following operating system versions:

| Amazon Linux 2                   | CentOS 7, 8                       |
| -------------------------------- | --------------------------------- |
| Red Hat Enterprise Linux 7, 8, 9 | Ubuntu 16.04, 18.04, 20.04, 22.04 |



### Installing Wazuh

第一步：Download and run the Wazuh installation assistant.

```bash
$ curl -sO https://packages.wazuh.com/4.4/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```

Once the assistant finishes the installation, the output shows the access credentials and a message that confirms that the installation was successful.

```
INFO: --- Summary ---
INFO: You can access the web interface https://<wazuh-dashboard-ip>
    User: admin
    Password: <ADMIN_PASSWORD>
INFO: Installation finished.
```

You now have installed and configured Wazuh.

第二步：Access the Wazuh web interface with `https://<wazuh-dashboard-ip>` and your credentials:

- Username: admin
- Password: <ADMIN_PASSWORD>

> **Note: **You can find the passwords for all the Wazuh indexer and Wazuh API users in the `wazuh-passwords.txt` file inside `wazuh-install-files.tar`. To print them, run the following command: `$ sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt`

If you want to uninstall the Wazuh central components, run the Wazuh installation assistant using the option `-u` or `–-uninstall`.

18/07/2023 21:34:31 INFO: You can access the web interface https://<wazuh-dashboard-ip>
    User: admin
    Password: K9at36WeF9b*jRr?LrB4iuxa25*Ozb7D
18/07/2023 21:34:31 INFO: Installation finished.

感受：Wazuh 的安装交付狠下功夫，支持各种安装部署方式：OVA Docker K8s Asible Puppet 很多很多，客户端也很努力做兼容性。



## Wazuh Agent

Windows:

```
Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.4.5-1.msi -OutFile ${env:tmp}\wazuh-agent.msi; msiexec.exe /i ${env:tmp}\wazuh-agent.msi /q WAZUH_MANAGER='192.168.208.145' WAZUH_REGISTRATION_SERVER='192.168.208.145' WAZUH_AGENT_GROUP='default' WAZUH_AGENT_NAME='twin' 

NET START WazuhSvc
```

Ubuntu:

```
curl -so wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.4.5-1_amd64.deb && sudo WAZUH_MANAGER='192.168.208.145' WAZUH_AGENT_GROUP='default' WAZUH_AGENT_NAME='test139' dpkg -i ./wazuh-agent.deb

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```



```
$ sudo dpkg -L wazuh-agent
/.
/etc
/etc/systemd
/etc/systemd/system
/etc/systemd/system/wazuh-agent.service
/etc/init.d
/etc/init.d/wazuh-agent
/usr
/usr/share
/usr/share/doc
/usr/share/doc/wazuh-agent
/usr/share/doc/wazuh-agent/changelog.Debian.gz
/usr/share/doc/wazuh-agent/copyright
/usr/share/lintian
/usr/share/lintian/overrides
/usr/share/lintian/overrides/wazuh-agent
/usr/lib
/usr/lib/systemd
/usr/lib/systemd/system
/usr/lib/systemd/system/wazuh-agent.service
/var
/var/ossec
/var/ossec/etc
/var/ossec/etc/wpk_root.pem
/var/ossec/etc/localtime
/var/ossec/etc/client.keys
/var/ossec/etc/internal_options.conf
/var/ossec/etc/shared
/var/ossec/etc/shared/win_applications_rcl.txt
/var/ossec/etc/shared/win_audit_rcl.txt
/var/ossec/etc/shared/cis_debian_linux_rcl.txt
/var/ossec/etc/shared/cis_win2012r2_domainL1_rcl.txt
/var/ossec/etc/shared/cis_apache2224_rcl.txt
/var/ossec/etc/shared/cis_mysql5-6_community_rcl.txt
/var/ossec/etc/shared/win_malware_rcl.txt
/var/ossec/etc/shared/cis_sles11_linux_rcl.txt
/var/ossec/etc/shared/cis_win2012r2_domainL2_rcl.txt
/var/ossec/etc/shared/cis_rhel7_linux_rcl.txt
/var/ossec/etc/shared/cis_rhel5_linux_rcl.txt
/var/ossec/etc/shared/cis_mysql5-6_enterprise_rcl.txt
/var/ossec/etc/shared/rootkit_trojans.txt
/var/ossec/etc/shared/cis_rhel6_linux_rcl.txt
/var/ossec/etc/shared/cis_sles12_linux_rcl.txt
/var/ossec/etc/shared/cis_win2012r2_memberL2_rcl.txt
/var/ossec/etc/shared/system_audit_ssh.txt
/var/ossec/etc/shared/cis_rhel_linux_rcl.txt
/var/ossec/etc/shared/cis_win2012r2_memberL1_rcl.txt
/var/ossec/etc/shared/rootkit_files.txt
/var/ossec/etc/shared/system_audit_rcl.txt
/var/ossec/etc/ossec.conf
/var/ossec/etc/local_internal_options.conf
/var/ossec/bin
/var/ossec/bin/wazuh-agentd
/var/ossec/bin/wazuh-execd
/var/ossec/bin/wazuh-logcollector
/var/ossec/bin/agent-auth
/var/ossec/bin/wazuh-modulesd
/var/ossec/bin/manage_agents
/var/ossec/bin/wazuh-control
/var/ossec/bin/wazuh-syscheckd
/var/ossec/logs
/var/ossec/logs/wazuh
/var/ossec/packages_files
/var/ossec/wodles
/var/ossec/wodles/docker
/var/ossec/wodles/docker/DockerListener
/var/ossec/wodles/__init__.py
/var/ossec/wodles/aws
/var/ossec/wodles/aws/aws-s3
/var/ossec/wodles/utils.py
/var/ossec/wodles/gcloud
/var/ossec/wodles/gcloud/tools.py
/var/ossec/wodles/gcloud/pubsub
/var/ossec/wodles/gcloud/pubsub/subscriber.py
/var/ossec/wodles/gcloud/integration.py
/var/ossec/wodles/gcloud/exceptions.py
/var/ossec/wodles/gcloud/gcloud
/var/ossec/wodles/gcloud/buckets
/var/ossec/wodles/gcloud/buckets/access_logs.py
/var/ossec/wodles/gcloud/buckets/bucket.py
/var/ossec/wodles/azure
/var/ossec/wodles/azure/orm.py
/var/ossec/wodles/azure/azure-logs
/var/ossec/agentless
/var/ossec/.ssh
/var/ossec/ruleset
/var/ossec/queue
/var/ossec/backup
/var/ossec/lib
/var/ossec/active-response
/var/ossec/tmp
/var/ossec/var
/var/ossec/var/incoming
/var/ossec/var/run
/var/ossec/var/wodles
/var/ossec/var/upgrade
/var/ossec/var/selinux
/var/ossec/var/selinux/wazuh.pp
```



报错：dpkg 彻底删除

```
# 删除功能文件
sudo dpkg -r  wazuh-agent
# 删除配置文件
sudo dpkg -P  wazuh-agent
```





