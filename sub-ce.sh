#!/bin/bash

#       ____ ___  _____
#      / ___|_ _|| ___ \
#     | |    | |  | ___ \
#     | |___ | |  |____/
#      \____|___|
#
# SUB-Ce: Automate subdomain enumeration with Subfinder and Sublist3r
# Authors: Olajide James, Grok (xAI)
# License: MIT

# Check for required arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 example.com"
    exit 1
fi

DOMAIN=$1
OUTPUT_DIR="subdomain_output"
SUBFINDER_OUT="$OUTPUT_DIR/subfinder_$DOMAIN.txt"
SUBLIST3R_OUT="$OUTPUT_DIR/sublist3r_$DOMAIN.txt"
MERGED_OUT="$OUTPUT_DIR/subdomains_$DOMAIN.txt"
TIMESTAMP=$(date +%F_%H-%M-%S)
LOG_FILE="$OUTPUT_DIR/enum_log_$TIMESTAMP.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if tools are installed
command -v subfinder >/dev/null 2>&1 || { log_message "ERROR: Subfinder not installed"; exit 1; }
command -v sublist3r >/dev/null 2>&1 || { log_message "ERROR: Sublist3r not installed"; exit 1; }

log_message "Starting subdomain enumeration for $DOMAIN"

# Run Subfinder
log_message "Running Subfinder..."
subfinder -d "$DOMAIN" -o "$SUBFINDER_OUT" -silent
if [ $? -eq 0 ]; then
    log_message "Subfinder completed. Results saved to $SUBFINDER_OUT"
else
    log_message "ERROR: Subfinder failed"
    exit 1
fi

# Run Sublist3r
log_message "Running Sublist3r..."
sublist3r -d "$DOMAIN" -o "$SUBLIST3R_OUT"
if [ $? -eq 0 ]; then
    log_message "Sublist3r completed. Results saved to $SUBLIST3R_OUT"
else
    log_message "ERROR: Sublist3r failed"
    exit 1
fi

# Merge results and remove duplicates
log_message "Merging results and removing duplicates..."
cat "$SUBFINDER_OUT" "$SUBLIST3R_OUT" 2>/dev/null | sort -u > "$MERGED_OUT"
if [ $? -eq 0 ]; then
    SUBDOMAIN_COUNT=$(wc -l < "$MERGED_OUT")
    log_message "Merged subdomains saved to $MERGED_OUT ($SUBDOMAIN_COUNT unique subdomains)"
else
    log_message "ERROR: Failed to merge results"
    exit 1
fi

log_message "Enumeration complete for $DOMAIN"
