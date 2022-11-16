## 节点侧配置
- 安装moreutils
apt-get install -y moreutils


- 启动exporter
```sh
mkdir -p /tmp/textcollector
cd /opt/node_exporter-*linux-amd64/ && nohup ./node_exporter --collector.textfile.directory="/tmp/textcollector" &
```

- 添加crontab
*/1 * * * * mkdir -p /tmp/textcollector && bash /opt/deploy/megacli.sh | sponge /tmp/textcollector/megacli.prom



## prometheus配置
- rule.yml
```yml
    - name: raid-monitor-rule
      rules:
      - alert: Array disk failure
        expr: megacli_adp_pd_failed_disks_count > 0
        for: 1m
        labels:
          service_name: TaiYuan
          level: warning
        annotations:
          description: "{{$labels.instance}}: Array failure disk count (current value is: {{ $value }}"
```



## exporter
```sh
root@storage3:~# /opt/deploy/megacli.sh
# HELP megacli_bbu_voltage BBU Voltage mV.
# TYPE megacli_bbu_voltage gauge
# HELP megacli_bbu_amp_current BBU Current mA.
# TYPE megacli_bbu_amp_current gauge
# HELP megacli_bbu_bat_state Battery State.
# TYPE megacli_bbu_bat_state gauge
# HELP megacli_bbu_bat_replacment Battery needs to be replaced.
# TYPE megacli_bbu_bat_replacment gauge
# HELP megacli_bbu_remaining_cap BBU Remaining Capacity mAh.
# TYPE megacli_bbu_remaining_cap gauge
# HELP megacli_bbu_full_cap BBU Full Charge Capacity mAh.
# TYPE megacli_bbu_full_cap gauge
# HELP megacli_bbu_max_error Battery Max Error percent.
# TYPE megacli_bbu_max_error gauge
# HELP megacli_adp_vd_count Adapter Virtual Drives count.
# TYPE megacli_adp_vd_count gauge
megacli_adp_vd_count{adapter="0"} 1
megacli_adp_vd_count{adapter="1"} 0
# HELP megacli_adp_vd_degraded_count Adapter Virtual Drives Degraded count.
# TYPE megacli_adp_vd_degraded_count gauge
megacli_adp_vd_degraded_count{adapter="0"} 0
megacli_adp_vd_degraded_count{adapter="1"} 0
# HELP megacli_adp_vd_offline_count Adapter Virtual Drives Offline count.
# TYPE megacli_adp_vd_offline_count gauge
megacli_adp_vd_offline_count{adapter="0"} 0
megacli_adp_vd_offline_count{adapter="1"} 0
# HELP megacli_adp_pd_count Adapter Physical Devices count.
# TYPE megacli_adp_pd_count gauge
megacli_adp_pd_count{adapter="0"} 14
megacli_adp_pd_count{adapter="1"} 26
# HELP megacli_adp_pd_disks_count Adapter Physical Disks count.
# TYPE megacli_adp_pd_disks_count gauge
megacli_adp_pd_disks_count{adapter="0"} 12
megacli_adp_pd_disks_count{adapter="1"} 24
# HELP megacli_adp_pd_critical_disks_count Adapter Physical Critical Disks count.
# TYPE megacli_adp_pd_critical_disks_count gauge
megacli_adp_pd_critical_disks_count{adapter="0"} 0
megacli_adp_pd_critical_disks_count{adapter="1"} 0
# HELP megacli_adp_pd_failed_disks_count Adapter Physical Failed Disks count.
# TYPE megacli_adp_pd_failed_disks_count gauge
megacli_adp_pd_failed_disks_count{adapter="0"} 0
megacli_adp_pd_failed_disks_count{adapter="1"} 24
root@storage3:~#
```