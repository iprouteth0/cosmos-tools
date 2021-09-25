#! /bin/bash

# bash script Cosmos Monitor with telegram msg.→ what do? =  send telegram msg with status + peers then check if the node is not running restart + msg telegram 
#EDIT where: 26657 for your RPC port if it is a different one. + <YOUR_TELEGRAM_TOKEN> + <YOUR_CHAT_ID> + <WRITE-NODE-NAME-HERE> + <sudo systemctl <PROCESS NAME> ???>
while [ "true" ]
    do
        token="bot-telegrem-token"
        chat_id="channel-id-here"
        tg_api="https://api.telegram.org/bot${token}/sendMessage?chat_id=${chat_id}"
        status=`curl http://192.168.1.173:26657/status | grep -E catching_up`
        peers=`curl  http://192.168.1.173:26657/net_info | grep -E n_peers`
        jailed=`docker exec node bandd q staking validators --node http://34.77.171.169:26657 | grep -A9 -B13 iprouteth0 | grep jailed`
        
        master=`curl http://34.77.171.169:26657/status | grep -E catching_up`
        masterpeers=`curl http://34.77.171.169:26657/net_info | grep -E n_peers`
        masterjail=`docker exec node bandd q staking validators --node http://34.77.171.169:26657| grep -A9 -B13 DiBug | grep jailed`
        masterstatus="@teletooz DiBug: ${master} & ${masterpeers} & ${masterjail}"


        status_msg="⚛️   iprouteth0:  🔖    ${peers} & ${status} & ${jailed} ⛏⚙️"
            echo "${status_msg}"
            curl -s "${tg_api}" --data-urlencode "text=${status_msg} & ${masterstatus}" &
        if ! curl http://192.168.1.173:26657/status > /dev/null
        then
            crash_msg="☢️Hum, iprouteth0 is Not running☢️. Restarting now‼️ . . 🚀"
            echo $crash_msg
            curl -s "${tg_api}" --data-urlencode "text=${crash_msg}"
            rst=`echo "RESTART YOUR NODE IDIOT!"`
            echo $rst  &
        fi
            sleep 1800

    done
