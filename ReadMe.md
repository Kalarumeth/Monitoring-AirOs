# Check AirOs
<img src="https://img.shields.io/badge/Code-Bash-orange?style=flat-square&logo=GNU%20Bash&logoColor=orange" alt="Bash"> <img src="https://img.shields.io/badge/Device-AirOs-0559C9?style=flat-square&logo=Ubiquiti" alt="Checked Device"> <img src="https://img.shields.io/badge/Release-v1.0-green?style=flat-square" alt="Release">

<img src="https://img.shields.io/badge/Dev by-Kalarumeth-blueviolet?style=flat-square" alt="Dev"> <img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="MIT License">

The following script is used to monitor and display the basic information of Ubiquity AirOs via snmpwalk scripts and are processed to provide easy-to-read data. It can be run separately or integrated into Icinga2 as a monitoring plugin.

**Important**: *snmpwalk command is required for script to run correctly*


# Update Note

## 1.0 - Release

    + Release

# Installation

1. Download the script and give it privilages for run
```
curl -LJO https://raw.githubusercontent.com/Kalarumeth/Monitoring-AirOs/main/check_airos.sh
```

2. Move to Icinga Plugin Dir
```
Default location: /usr/lib/nagios/plugins
```

3. Add command to Icinga
```
object CheckCommand "check_airos" {
    import "plugin-check-command"
    command = [ PluginDir + "/check_airos.sh" ]
    arguments += {
        "-c" = {
            order = 0
            value = "$snmp_community$"
        }
        "-cr" = {
            order = 3
            value = "$crit$"
        }
        "-h" = {
            order = 1
            required = true
            value = "$address$"
        }
        "-t" = {
            order = 4
            required = true
            value = "$airos_type$"
        }
        "-wa" = {
            order = 2
            value = "$warn$"
        }
    }
}
```

# Functions

The Script is designed to monitor the following functions:

- **[airmax] AirMax:**
Show all airMax Statistics of device
```
AirMax Information
Enabled:	On
Quality:	96 % 
Capacity:	45 %
Priority:	None
NoAck:		Off
```

- **[info] Info:**
Show basic information
```
Device Information
Location:	 OUTSIDE
UpTime:		 2 days, 18:03:25.00
LastChange:	 17:01:14.00
Ubiquiti Networks, Inc. LiteBeam M5
airOs Ver:	 XW.ar934x.v6.3.6.33330.210818.1930
```

- **[radio] Radio:**
Show status and statistics of radio
```
Radio Information
Mode:		AP Wireless Distribution System
Country:	380
Frequency:	5185
DFS:		Off
TxPower:	0
Distance:	0
Chainmask:	1
Antenna:	11x14 - 23 dBi
```

- **[ram] Ram:**
Show ram usage
```
OK! RAM used: 25.27 / 62.14 Mb (40.67%)
RAM free: 36.86 Mb (59.33%)
Buffer: 2.99 Mb
Cache:  0 Kb
```

- **[station] Station:**
Show station information, work only on station setup
```
Station Information
Name:		    AP041
Signal:		    -41 dBm
Noise floor:	-100
CCQ:		    99 %
Con. Time:	    2
TX/RX Rate:	    150 MB / 150 MB
TX/RX Bytes:	3.39 GB / 7.88 GB
```

- **[wireless] Wireless:**
Show wireless information
```
Wireless Information
SSID:		    Bridge
Hide:		    On
Signal:		    -42 dBm
RSSI:		    54 dBm
CCQ:		    99
Noise floor:	-99
TX/RX Rate:	    150 MB / 150 MB
Security:	    WPA2
WDS:		    On
Ap Repeater:	Off
Channel Width:	40
Station Count:	1
```

# How it work

Method to compose the execution string:

    ./check_airos.sh -c <SNMP community> -h <host> [-wa <value> -cr <value>] -t <object>

### OPTIONS:

```
-c  --community     SNMP v2 community string with Read access.
                     Default is: public.
-h  --host          [REQUIRED OPTION] Host name or IP address to check.
                     Default is: localhost.
-wa --allert-wa     Defines the threshold for Warning.
                     Default is: 75.
-cr --allert-cr     Defines the threshold for Critical.
                     Default is: 50.
-t  --type          [REQUIRED OPTION] Field for select element to check on WatchGuard Device.
                     { airmax | info | radio | ram | station | wireless }.
-H  --help          Show script help.
-V  --version       Show script version.
```

# Credits

### Author

    Kalarumeth - https://github.com/Kalarumeth

### License

    MIT License - Copyright 2022 Kalarumeth