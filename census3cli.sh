#!/usr/bin/env sh

set -euo pipefail

# Default values
API_ENDPOINT="http://localhost:8083"
ACTION="help"
ID=""
TYPE="erc20"
CHAIN_ID=1
STRATEGY_ID=""
ANONYMOUS="true"
QUEUE_ID=""

# Help function to display usage
usage() {
    echo "Usage: $0 -a ACTION [OPTIONS]"
    echo "Options:"
    echo "  -a  Action to perform (run, register_token, token_info, create_census, census_status, help)."
    echo "  -e  API endpoint. Default is '${API_ENDPOINT}'."
    echo "  -i  Token ID or contract address."
    echo "  -t  Token type (erc20, erc721, erc777, veNation, wANT). Default is '${TYPE}'."
    echo "  -c  Chain ID. Default is ${CHAIN_ID}."
    echo "  -s  Strategy ID."
    echo "  -n  Anonymous flag for census creation. Default is '${ANONYMOUS}'."
    echo "  -q  Queue ID for checking census status."
    echo "  -h  Display this help message."
    exit 1
}

# Parse flags
while getopts "a:e:i:t:c:s:n:q:h" opt; do
    case ${opt} in
        a) ACTION=${OPTARG} ;;
        e) API_ENDPOINT=${OPTARG} ;;
        i) ID=${OPTARG} ;;
        t) TYPE=${OPTARG} ;;
        c) CHAIN_ID=${OPTARG} ;;
        s) STRATEGY_ID=${OPTARG} ;;
        n) ANONYMOUS=${OPTARG} ;;
        q) QUEUE_ID=${OPTARG} ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Functions to perform API actions
register_token() {
    curl -v -X POST \
        --json "{\"id\": \"$ID\", \"type\": \"$TYPE\", \"chainID\": $CHAIN_ID}" \
        $API_ENDPOINT/api/token
}

token_info() {
    curl -X GET \
        $API_ENDPOINT/api/token/$ID
}

create_census() {
    curl -X POST \
        --json "{\"strategyId\": $STRATEGY_ID, \"anonymous\": $ANONYMOUS}" \
        $API_ENDPOINT/api/census
}

census_status() {
    curl -X GET \
        $API_ENDPOINT/census/queue/$QUEUE_ID
}

# Main function to call the appropriate action function
main() {
    case $ACTION in
        register_token) register_token ;;
        token_info) token_info ;;
        create_census) create_census ;;
        census_status) census_status ;;
        help) usage ;;
        *) 
            echo "Invalid action. Available actions are: register_token, token_info, create_census, census_status, help."
            exit 1
            ;;
    esac
}

main