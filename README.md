# ansible-galera-haproxy
deploy galera cluster with haproxy

version 0.1 支持部署安装，暂不支持更新配置

# 版本要求
在 centos7.3 测试 ok，支持<= centos/rhel 7.3的操作系统

# 部署方法

## 0. 部署ansible

```bash
sh -x init.sh
```


## 1. 修改目录下的hosts文件(定义部署节点)

示例如下：
```bash
[mariadb]
192.168.183.[137:139]

[haproxy]
192.168.183.[137:139]
```
mariadb和haproxy部署在相同的三台服务器上

## 2. 修改变量文件(group_vars/all.yml)：
建议修改值：
```bash
# 配置vip地址
vip_address: "192.168.183.201"
# vip绑定的端口名称
vip_interface: "ens33"
# router id，建议为vip address 最后一位
keepalived_virtual_router_id: "201"
# 同vip_interface
db_interface: "ens33"
# 数据库root用户密码
mariadb_passwd: "root"
```
除了以上值，其他不建议修改

## 3. 测试服务器连通性

```bash
ansible -i hosts all -m ping -k
```

## 4. 部署mariadb cluster

```bash
ansible-playbook -i hosts galera.yml -k
```

备注: 3和4 两步需要输入root用户密码

## 5. 集群检查
```bash
mysql -h$host_vip -uroot -p$password 

MariaDB [mysql]> show status like 'wsrep_%';
```
关注如下几个值
- wsrep_connected = on 链接已开启
- wsrep_local_index = 1 在集群中的索引值
- wsrep_cluster_size =3 集群中节点的数量
- wsrep_incoming_addresses = xxx.xxx.xxx.xxx:3306,xxx.xxx.xxx.xxx:3306,1xxx.xxx.xxx.xxx:3306 集群中节点的访问地址

## 6. 验证