#!/vendor/bin/sh
## Copyright (c) 2022 Amazon.com, Inc. or its affiliates.  All rights reserved.
##
## PROPRIETARY/CONFIDENTIAL.  USE IS SUBJECT TO LICENSE TERMS.

#Add function to log KDM metrics to Minerva.
log_to_kdm_minerva () {
    local default=""
    local default_value=1
    local default_unit="count"
    local RAW_METRICS=${1}

    local VALUE=${default_value}
    local UNIT=${default_unit}
    local KEY=${default}
    local METADATA=${default}
    local METADATA1=${default}
    local METADATA2=${default}
    local METADATA3=${default}

    local schema_id="ir04/2/03330400"
    local group_id="30pfp83p"

    IFS=';'
    dataPoints=($RAW_METRICS)
    for val in ${dataPoints[@]};
    do
        IFS='='
        key_val_pair=($val)
        if [[ "${key_val_pair[0]}" == "operation" ]]; then
            OPERATION=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" == "key" ]]; then
            KEY=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" = "value" ]]; then
            VALUE=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" == "unit" ]]; then
            UNIT=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" == "metadata3" ]]; then
            METADATA3=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" == "metadata2" ]]; then
            METADATA2=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" == "metadata1" ]]; then
            METADATA1=${key_val_pair[1]}
        elif [[ "${key_val_pair[0]}" == "metadata" ]]; then
            METADATA=${key_val_pair[1]}
        else
            log -m -t "wifi_metrics_common" "Metric record error: Unknown key passed" "${key_val_pair[0]}"
        fi
        unset IFS
    done
    unset IFS

    if [[ "${OPERATION}" == "${default_value}" ]]; then
        log -m -t "wifi_metrics_common" "Metric record error: Operation missing"
        return
    fi

    local kdm_logStr="wifiKDM:${OPERATION}:fgtracking=false;DV;1,Timer=${VALUE};TI;1,unit=${UNIT};DV;1,metadata=!{\"d\"#{\"groupId\"#\"${group_id}\"$\"schemaId\"#\"${schema_id}\""

    if [[ "${KEY}" != "${default}" ]]; then
        kdm_logStr+="$\"key\"#\"${KEY}\""
    fi
    if [[ "${METADATA3}" != "${default}" ]]; then
        kdm_logStr+="$\"metadata3\"#\"${METADATA3}\""
    fi
    if [[ "${METADATA2}" != "${default}" ]]; then
        kdm_logStr+="$\"metadata2\"#\"${METADATA2}\""
    fi
    if [[ "${METADATA1}" != "${default}" ]]; then
        kdm_logStr+="$\"metadata1\"#\"${METADATA1}\""
    fi
    if [[ "${METADATA}" != "${default}" ]]; then
        kdm_logStr+="$\"metadata\"#\"${METADATA}\""
    fi

    kdm_logStr+="}};DV;1:NR"
    log -v -t "Vlog" $kdm_logStr
}