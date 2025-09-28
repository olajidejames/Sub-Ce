# SUB-Ce

       ____ ___  _____
      / ___|_ _|| ___ \
     | |    | |  | ___ \
     | |___ | |  |____/
      \____|___|

A bash script to automate subdomain enumeration using Subfinder and Sublist3r, merging results and removing duplicates.

## Authors
- Olajide James
- Grok (xAI)

## Prerequisites
- Subfinder: `go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest`
- Sublist3r: `pip install sublist3r`
- Bash and Git installed

## Usage
```bash
chmod +x sub-ce.sh
./sub-ce.sh example.com
