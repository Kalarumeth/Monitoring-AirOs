#!/bin/bash

# - VAR

# - Bash info
APPNAME=$(basename $0)
NAME="Check Ubiquiti LiteBeam M5"
AUTHOR="Kalarumeth"
VERSION="v0.1"
URL="https://github.com/Kalarumeth"

# - Default settings for connection
COMMUNITY="public"
HOST_NAME="localhost"
SNMPVERSION="1"

# - State Variables
STATE_OK=0
STATE_WARN=1
STATE_CRIT=2
STATE_UNK=3
STATE=$STATE_OK

# - Range Variables
WA=75
CR=50

# - OID

UBNT.GetOIDS() {
    #Device Information
    OID_dot11manufacturerName="1.2.840.10036.3.1.2.1.2.5"
    OID_dot11manufacturerProductName="1.2.840.10036.3.1.2.1.3.5"
    OID_dot11manufacturerProductVersion="1.2.840.10036.3.1.2.1.4.5"
    OID_sysDescr="1.3.6.1.2.1.1.1.0"
    OID_sysUpTime="1.3.6.1.2.1.1.3.0"
    OID_sysContact="1.3.6.1.2.1.1.4.0"
    OID_sysName="1.3.6.1.2.1.1.5.0"
    OID_sysLocation="1.3.6.1.2.1.1.6.0"
    OID_sysORLastChange="1.3.6.1.2.1.1.8.0"
    
    #Memory
    OID_memTotal="1.3.6.1.4.1.10002.1.1.1.1.1.0"
    OID_memFree="1.3.6.1.4.1.10002.1.1.1.1.2.0"
    OID_memBuffer="1.3.6.1.4.1.10002.1.1.1.1.3.0"
    OID_memCache="1.3.6.1.4.1.10002.1.1.1.1.4.0"

    #Radio status & statistics
    OID_ubntRadioMode="1.3.6.1.4.1.41112.1.4.1.1.2.1"
    OID_ubntRadioCCode="1.3.6.1.4.1.41112.1.4.1.1.3.1"
    OID_ubntRadioFreq="1.3.6.1.4.1.41112.1.4.1.1.4.1"
    OID_ubntRadioDfsEnabled="1.3.6.1.4.1.41112.1.4.1.1.5.1"
    OID_ubntRadioTxPower="1.3.6.1.4.1.41112.1.4.1.1.6.1"
    OID_ubntRadioDistance="1.3.6.1.4.1.41112.1.4.1.1.7.1"
    OID_ubntRadioChainmask="1.3.6.1.4.1.41112.1.4.1.1.8.1"
    OID_ubntRadioAntenna="1.3.6.1.4.1.41112.1.4.1.1.9.1"

    #Wireless statistics
    OID_ubntWlStatSsid="1.3.6.1.4.1.41112.1.4.5.1.2.1"
    OID_ubntWlStatHideSsid="1.3.6.1.4.1.41112.1.4.5.1.3.1"
    OID_ubntWlStatApMac="1.3.6.1.4.1.41112.1.4.5.1.4.1"
    OID_ubntWlStatSignal="1.3.6.1.4.1.41112.1.4.5.1.5.1"
    OID_ubntWlStatRssi="1.3.6.1.4.1.41112.1.4.5.1.6.1"
    OID_ubntWlStatCcq="1.3.6.1.4.1.41112.1.4.5.1.7.1"
    OID_ubntWlStatNoiseFloor="1.3.6.1.4.1.41112.1.4.5.1.8.1"
    OID_ubntWlStatTxRate="1.3.6.1.4.1.41112.1.4.5.1.9.1"
    OID_ubntWlStatRxRate="1.3.6.1.4.1.41112.1.4.5.1.10.1"
    OID_ubntWlStatSecurity="1.3.6.1.4.1.41112.1.4.5.1.11.1"
    OID_ubntWlStatWdsEnabled="1.3.6.1.4.1.41112.1.4.5.1.12.1"
    OID_ubntWlStatApRepeater="1.3.6.1.4.1.41112.1.4.5.1.13.1"
    OID_ubntWlStatChanWidth="1.3.6.1.4.1.41112.1.4.5.1.14.1"
    OID_ubntWlStatStaCount="1.3.6.1.4.1.41112.1.4.5.1.15.1"

    #AirMax Statistics
    OID_ubntAirMaxEnabled="1.3.6.1.4.1.41112.1.4.6.1.2.1"
    OID_ubntAirMaxQuality="1.3.6.1.4.1.41112.1.4.6.1.3.1"
    OID_ubntAirMaxCapacity="1.3.6.1.4.1.41112.1.4.6.1.4.1"
    OID_ubntAirMaxPriority="1.3.6.1.4.1.41112.1.4.6.1.5.1"
    OID_ubntAirMaxNoAck="1.3.6.1.4.1.41112.1.4.6.1.6.1"

    #Station Statistics
    OID_ubntStaName="1.3.6.1.4.1.41112.1.4.7.1.2.1.104.215.154.156.204.212"
    OID_ubntStaSignal="1.3.6.1.4.1.41112.1.4.7.1.3.1.104.215.154.156.204.212"
    OID_ubntStaNoiseFloor="1.3.6.1.4.1.41112.1.4.7.1.4.1.104.215.154.156.204.212"
    OID_ubntStaDistance="1.3.6.1.4.1.41112.1.4.7.1.5.1.104.215.154.156.204.212"
    OID_ubntStaCcq="1.3.6.1.4.1.41112.1.4.7.1.6.1.104.215.154.156.204.212"
    OID_ubntStaAmp="1.3.6.1.4.1.41112.1.4.7.1.7.1.104.215.154.156.204.212"
    OID_ubntStaAmq="1.3.6.1.4.1.41112.1.4.7.1.8.1.104.215.154.156.204.212"
    OID_ubntStaAmc="1.3.6.1.4.1.41112.1.4.7.1.9.1.104.215.154.156.204.212"
    OID_ubntStaLastIp="1.3.6.1.4.1.41112.1.4.7.1.10.1.104.215.154.156.204.212"
    OID_ubntStaTxRate="1.3.6.1.4.1.41112.1.4.7.1.11.1.104.215.154.156.204.212"
    OID_ubntStaRxRate="1.3.6.1.4.1.41112.1.4.7.1.12.1.104.215.154.156.204.212"
    OID_ubntStaTxBytes="1.3.6.1.4.1.41112.1.4.7.1.13.1.104.215.154.156.204.212"
    OID_ubntStaRxBytes="1.3.6.1.4.1.41112.1.4.7.1.14.1.104.215.154.156.204.212"
    OID_ubntStaConnTime="1.3.6.1.4.1.41112.1.4.7.1.15.1.104.215.154.156.204.212"
}

UBNT.GetData() {
    UBNT.GetOIDS

    case $1 in
        airmax)
            ubntAirMaxEnabled=$(Source.SNMP $OID_ubntAirMaxEnabled | cut -d ' ' -f 4)
            ubntAirMaxQuality=$(Source.SNMP $OID_ubntAirMaxQuality | cut -d ' ' -f 4)
            ubntAirMaxCapacity=$(Source.SNMP $OID_ubntAirMaxCapacity | cut -d ' ' -f 4)
            ubntAirMaxPriority=$(Source.SNMP $OID_ubntAirMaxPriority | cut -d ' ' -f 4)
            ubntAirMaxNoAck=$(Source.SNMP $OID_ubntAirMaxNoAck | cut -d ' ' -f 4)
            ;;
        info)
            dot11manufacturerName=$(Source.SNMP $OID_dot11manufacturerName | cut -d '"' -f 2)
            dot11manufacturerProductName=$(Source.SNMP $OID_dot11manufacturerProductName | cut -d '"' -f 2)
            dot11manufacturerProductVersion=$(Source.SNMP $OID_dot11manufacturerProductVersion | cut -d '"' -f 2)
            sysDescr=$(Source.SNMP $OID_sysDescr | cut -d '"' -f 2)
            sysUpTime=$(Source.SNMP $OID_sysUpTime | cut -d ' ' -f 5)
            sysLocation=$(Source.SNMP $OID_sysLocation | cut -d '"' -f 2)
            sysORLastChange=$(Source.SNMP $OID_sysORLastChange | cut -d ' ' -f 5)
            ;;
        radio)
            ubntRadioMode=$(Source.SNMP $OID_ubntRadioMode | cut -d ' ' -f 4)
            ubntRadioCCode=$(Source.SNMP $OID_ubntRadioCCode | cut -d ' ' -f 4)
            ubntRadioFreq=$(Source.SNMP $OID_ubntRadioFreq | cut -d ' ' -f 4)
            ubntRadioDfsEnabled=$(Source.SNMP $OID_ubntRadioDfsEnabled | cut -d ' ' -f 4)
            ubntRadioTxPower=$(Source.SNMP $OID_ubntRadioTxPower | cut -d ' ' -f 4)
            ubntRadioDistance=$(Source.SNMP $OID_ubntRadioDistance | cut -d ' ' -f 4)
            ubntRadioChainmask=$(Source.SNMP $OID_ubntRadioChainmask | cut -d ' ' -f 4)
            ubntRadioAntenna=$(Source.SNMP $OID_ubntRadioAntenna | cut -d '"' -f 2)
            ;;
        ram)
            rawRamAll=$(Source.SNMP $OID_memTotal | cut -d ' ' -f 4)
            rawRamFree=$(Source.SNMP $OID_memFree | cut -d ' ' -f 4)
            valueRamAllMb=$(echo "$rawRamAll" | awk '{ mbyte = $1 /1000; print mbyte }'  | xargs printf "%.2f")
            valueRamFreeMb=$(echo "$rawRamFree" | awk '{ mbyte = $1 /1000; print mbyte }'  | xargs printf "%.2f")
            printPercetageRam=$(echo "$rawRamFree" "$rawRamAll" | awk '{ ramp = $1 /$2 *100; print ramp }' | xargs printf "%.2f")
            printPercetageRamUsed=$(echo "$printPercetageRam" | awk '{ ramup = 100 - $1; print ramup }')
            rangePercetageRam=$(echo "$printPercetageRamUsed" | cut -d "." -f1)
            rawRamUsed=$(echo "$rawRamAll" "$rawRamFree" | awk '{ used = $1 -$2; print used }')
            valueRamUsedMb=$(echo "$rawRamUsed" | awk '{ mbyte = $1 /1000; print mbyte }'  | xargs printf "%.2f")
            rawmemBuffer=$(Source.SNMP $OID_memBuffer | cut -d ' ' -f 4)
            memBuffer=$(echo "$rawmemBuffer" | awk '{ mbyte = $1 /1000; print mbyte }'  | xargs printf "%.2f")
            memCache=$(Source.SNMP $OID_memCache | cut -d ' ' -f 4)
            ;;
        station)
            mode=$(Source.SNMP $OID_ubntRadioMode | cut -d ' ' -f 4)
            ubntStaName=$(Source.SNMP $OID_ubntStaName | cut -d '"' -f 2)
            ubntStaSignal=$(Source.SNMP $OID_ubntStaSignal | cut -d ' ' -f 4)
            ubntStaNoiseFloor=$(Source.SNMP $OID_ubntStaNoiseFloor | cut -d ' ' -f 4)
            ubntStaCcq=$(Source.SNMP $OID_ubntStaCcq | cut -d ' ' -f 4)
            ubntStaTxRate=$(Source.SNMP $OID_ubntStaTxRate | cut -d ' ' -f 4)
            ubntStaRxRate=$(Source.SNMP $OID_ubntStaRxRate | cut -d ' ' -f 4)
            ubntStaTxBytes=$(Source.SNMP $OID_ubntStaTxBytes | cut -d ' ' -f 4)
            ubntStaRxBytes=$(Source.SNMP $OID_ubntStaRxBytes | cut -d ' ' -f 4)
            ubntStaConnTime=$(Source.SNMP $OID_ubntStaConnTime | cut -d ' ' -f 5)
            ;;
        wireless)
            ubntWlStatSsid=$(Source.SNMP $OID_ubntWlStatSsid | cut -d '"' -f 2)
            ubntWlStatHideSsid=$(Source.SNMP $OID_ubntWlStatHideSsid | cut -d ' ' -f 4)
            ubntWlStatApMac=$(Source.SNMP $OID_ubntWlStatApMac | cut -d ' ' -f 4)
            ubntWlStatSignal=$(Source.SNMP $OID_ubntWlStatSignal | cut -d ' ' -f 4)
            ubntWlStatRssi=$(Source.SNMP $OID_ubntWlStatRssi | cut -d ' ' -f 4)
            ubntWlStatCcq=$(Source.SNMP $OID_ubntWlStatCcq | cut -d ' ' -f 4)
            ubntWlStatNoiseFloor=$(Source.SNMP $OID_ubntWlStatNoiseFloor | cut -d ' ' -f 4)
            ubntWlStatTxRate=$(Source.SNMP $OID_ubntWlStatTxRate | cut -d ' ' -f 4)
            ubntWlStatRxRate=$(Source.SNMP $OID_ubntWlStatRxRate | cut -d ' ' -f 4)
            ubntWlStatSecurity=$(Source.SNMP $OID_ubntWlStatSecurity | cut -d '"' -f 2)
            ubntWlStatWdsEnabled=$(Source.SNMP $OID_ubntWlStatWdsEnabled | cut -d ' ' -f 4)
            ubntWlStatApRepeater=$(Source.SNMP $OID_ubntWlStatApRepeater | cut -d ' ' -f 4)
            ubntWlStatChanWidth=$(Source.SNMP $OID_ubntWlStatChanWidth | cut -d ' ' -f 4)
            ubntWlStatStaCount=$(Source.SNMP $OID_ubntWlStatStaCount | cut -d ' ' -f 4)
            ;;
    esac
}

# - MAIN CODE

Source.HostAlive() {
    for server in $HOST_NAME; do
        ping -c1 -W1 -q $server &>/dev/null
        if [[ $? != 0 ]] ; then
            printf "%s\n" "$server is unreachable"
            exit $STATE_UNK
        fi
    done
}

Source.SNMP() {    
    snmpwalk -v $SNMPVERSION -r 1 -t 10 -Oe -c $COMMUNITY $HOST_NAME $1
}

Source.SNMP.Hex() {    
    snmpwalk -v $SNMPVERSION -r 1 -t 10 -Oa -c $COMMUNITY $HOST_NAME $1
}

# - Ubiquiti Status Variables

GetStatus.OnOff() {
    case $1 in
        1) local sED="On" ;;
        2) local sED="Off" ;;
    esac

    echo $sED
}

GetStatus.BToMB() {
    local value=$(echo "$1" | awk '{ mbyte = $1 /1000/1000; print mbyte }'  | xargs printf "%.f")
    echo "$value MB"
}

GetStatus.BToGB() {
    local value=$(echo "$1" | awk '{ gbyte = $1 /1000/1000/1000; print gbyte }'  | xargs printf "%.2f")
    echo "$value GB"
}

GetStatus.RadioMode() {
    case $1 in
        1) local sRM="Station" ;;
        2) local sRM="Access Point" ;;
        3) local sRM="AP Repeater" ;;
        4) local sRM="AP Wireless Distribution System" ;;
    esac

    echo $sRM
}

GetStatus.CheckStaMode() {
    if [[ $1 != "1" ]]; then
        printf "%s\n%s\n%s\n" "The following device isn't set to Station." "Is setted on '$(GetStatus.RadioMode $1)'," "disable the following service for this device." && exit $STATE_UNK
    fi
}

GetStatus.AMQuality() {
    if [[ $1 < $CR-1 ]]; then
        local sQuality="CRIT!"
        STATE=$STATE_CRIT
    elif [[ $1 < $WA-1 ]]; then
        local sQuality="WARN!"
        STATE=$STATE_WARN
    fi

    echo "$1" "%" "$sQuality"
}

GetStatus.AMPriority() {
    case $1 in
        0) local sAMP="High" ;;
        1) local sAMP="Medium" ;;
        2) local sAMP="Low" ;;
        3) local sAMP="None" ;;
    esac

    echo $sAMP
}

# - Ubiquiti Monitoring

UBNT.Main() {
    Source.HostAlive
    
    case $1 in
        airmax)
            UBNT.AirMax
            exit $STATE ;;
        info)
            UBNT.Info
            exit $STATE ;;
        radio)
            UBNT.Radio
            exit $STATE ;;
        ram)
            UBNT.Ram
            exit $STATE ;;
        station)
            UBNT.Station
            exit $STATE ;;
        wireless)
            UBNT.Wireless
            exit $STATE ;;
        *)
            echo "Unknown check!"
            Help.UBNT
            exit $STATE_UNK ;;
    esac
}

UBNT.AirMax() {
    UBNT.GetData airmax

    printf "%s\n\n" "AirMax Information"

    printf "%s\t%s\n" "Enabled:"      "$(GetStatus.OnOff $ubntAirMaxEnabled)"
    printf "%s\t%s\n" "Quality:"      "$(GetStatus.AMQuality $ubntAirMaxQuality)"
    printf "%s\t%s\n" "Capacity:"     "$ubntAirMaxCapacity %"
    printf "%s\t%s\n" "Priority:"     "$(GetStatus.AMPriority $ubntAirMaxPriority)"
    printf "%s\t\t%s\n" "NoAck:"      "$(GetStatus.OnOff $ubntAirMaxNoAck)"
}

UBNT.Info() {
    UBNT.GetData info

    printf "%s\n\n"     "Device Information"

    printf "%s\t%s\n"   "Location:"                 "$sysLocation"
    printf "%s\t\t%s\n" "UpTime:"                   "$sysUpTime"
    printf "%s\t%s\n\n" "LastChange:"               "$sysORLastChange"

    printf "%s%s\n"     "$dot11manufacturerProductName"   "$dot11manufacturerName"
    printf "%s\t%s\n"   "airOs Ver:"                "$dot11manufacturerProductVersion"
}

UBNT.Radio() {
    UBNT.GetData radio

    printf "%s\n\n" "Radio Information"

    printf "%s\t\t%s\n" "Mode:"      "$(GetStatus.RadioMode $ubntRadioMode)"
    printf "%s\t%s\n" "Country:"     "$ubntRadioCCode"
    printf "%s\t%s\n" "Frequency:"   "$ubntRadioFreq"
    printf "%s\t\t%s\n" "DFS:"       "$(GetStatus.OnOff $ubntRadioDfsEnabled)"
    printf "%s\t%s\n" "TxPower:"     "$ubntRadioTxPower"
    printf "%s\t%s\n" "Distance:"    "$ubntRadioDistance"
    printf "%s\t%s\n" "Chainmask:"   "$ubntRadioChainmask"
    printf "%s\t%s\n" "Antenna:"     "$ubntRadioAntenna"
}

UBNT.Ram() {
    UBNT.GetData ram

    case 1 in
        $(($rangePercetageRam <= $WA-1)))
            printf "%s\n"   "OK! RAM used: $valueRamUsedMb / $valueRamAllMb Mb ($printPercetageRamUsed%)"       "RAM free: $valueRamFreeMb Mb ($printPercetageRam%)" "Buffer: $memBuffer Mb" "Cache:  $memCache Kb" && exit $STATE_OK ;;
        $(($rangePercetageRam <= $CR-1)))
            printf "%s\n"   "WARRING! RAM used: $valueRamUsedMb / $valueRamAllMb Mb ($printPercetageRamUsed%)"  "RAM free: $valueRamFreeMb Mb ($printPercetageRam%)" "Buffer: $memBuffer Mb" "Cache:  $memCache Kb" && exit $STATE_WARN ;;
        $(($rangePercetageRam > $CR-1)))
            printf "%s\n"   "CRITICAL! RAM used: $valueRamUsedMb / $valueRamAllMb Mb ($printPercetageRamUsed%)" "RAM free: $valueRamFreeMb Mb ($printPercetageRam%)" "Buffer: $memBuffer Mb" "Cache:  $memCache Kb" && exit $STATE_CRIT ;;
    esac
}

UBNT.Station() {
    UBNT.GetData station
    GetStatus.CheckStaMode $mode

    printf "%s\n\n"     "Station Information"

    printf "%s\t\t%s\n" "Name:"             "$ubntStaName"
    printf "%s\t\t%s\n" "Signal:"           "$ubntStaSignal dBm"
    printf "%s\t%s\n"   "Noise floor:"      "$ubntStaNoiseFloor"
    printf "%s\t\t%s\n" "CCQ:"              "$ubntStaCcq %"
    printf "%s\t%s\n\n" "Con. Time:"        "$(echo $ubntStaConnTime)"

    printf "%s\t%s\n"   "TX/RX Rate:"       "$(GetStatus.BToMB $ubntStaTxRate) / $(GetStatus.BToMB $ubntStaRxRate)"
    printf "%s\t%s\n"   "TX/RX Bytes:"      "$(GetStatus.BToGB $ubntStaTxBytes) / $(GetStatus.BToGB $ubntStaRxBytes)"
}

UBNT.Wireless() {
    UBNT.GetData wireless

    printf "%s\n\n"     "Wireless Information"

    printf "%s\t\t%s\n" "SSID:"             "$ubntWlStatSsid"
    printf "%s\t\t%s\n" "Hide:"             "$(GetStatus.OnOff $ubntWlStatHideSsid)"
    printf "%s\t\t%s\n" "Signal:"           "$ubntWlStatSignal dBm"
    printf "%s\t\t%s\n" "RSSI:"             "$ubntWlStatRssi dBm"
    printf "%s\t\t%s\n" "CCQ:"              "$ubntWlStatCcq"
    printf "%s\t%s\n"   "Noise floor:"      "$ubntWlStatNoiseFloor"
    printf "%s\t%s\n"   "TX/RX Rate:"       "$(GetStatus.BToMB $ubntWlStatTxRate) / $(GetStatus.BToMB $ubntWlStatRxRate)"
    printf "%s\t%s\n"   "Security:"         "$ubntWlStatSecurity"
    printf "%s\t\t%s\n" "WDS:"              "$(GetStatus.OnOff $ubntWlStatWdsEnabled)"
    printf "%s\t%s\n"   "Ap Repeater:"      "$(GetStatus.OnOff $ubntWlStatApRepeater)"
    printf "%s\t%s\n"   "Channel Width:"    "$ubntWlStatChanWidth"
    printf "%s\t%s\n"   "Station Count:"    "$ubntWlStatStaCount"
}

# - Help 

Help.Main() {
    echo $NAME
    echo ''
    Help.Usage
    echo ''
    Help.Option
    echo ''
    Help.Info
    echo ''
    exit $STATE_UNK
}

Help.Usage() {
    printf "%s\n" "Method to compose the execution string"
    printf "%s\n" "./$APPNAME -c <SNMP community> -h <host> -t <check>"
}

Help.Option() {
    printf "%s\n"                       "OPTIONS:"
    printf "%s\t%s\t%s\n\t\t\t%s\n"     "-c" "--community"  "SNMP v2 community string with Read access." " Default is $COMMUNITY."
    printf "%s\t%s\t\t%s\n\t\t\t%s\n"   "-h" "--host"       "Host name or IP address to check." " Default is $HOST_NAME."
    printf "%s\t%s\t\t%s\n\t\t\t%s\n"   "-t" "--type"       "[REQUIRED OPTION] Field for select element to check on AirOs Device." "{ airmax | info | radio | ram | station | wireless }"
    printf "%s\t%s\t\t%s\n"             "-H" "--help"       "Show Script help"
    printf "%s\t%s\t%s\n"               "-V" "--version"    "Show Script version"
}

Help.UBNT() {
    printf "\n%s\n\n"   "Ubiquiti airOs Check Function"
    printf "%s\t%s\n\n" "Check"     "Description"
    printf "%s\t%s\n"   "airmax"    "Show all airMax Statistics of device"
    printf "%s\t%s\n"   "info"      "Show basic information"
    printf "%s\t%s\n"   "radio"     "Show status and statistics of radio"
    printf "%s\t%s\n"   "ram"       "Show ram usage"
    printf "%s\t%s\n"   "station"   "Show station information, work only on station setup"
    printf "%s\t%s\n"   "wireless"  "Show wireless information"
}

Help.Info() {
    printf "%s\t%s\t%s\n" "INFO:" "$NAME" "$VERSION" "" "$AUTHOR" "$URL"
}

# - COMMAND LINE ENCODER

while test -n "$1"; do
    case "$1" in
        --host | -h)
            HOST_NAME=$2
            shift ;;
        --comunity | -c)
            COMMUNITY=$2
            shift ;;
        --allert-wa|-wa)
            WA=$2
            shift ;;
        --allert-cr|-cr)
            CR=$2
            shift ;;
        --type | -t)
            UBNT.Main $2
            shift ;;
        --help | -H)
            Help.Main ;;
        --version | -V)
            Help.Info
            exit $STATE ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $STATE_UNK ;;
        esac
    shift
done

UBNT.Main