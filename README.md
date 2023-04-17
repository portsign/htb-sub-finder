# HTB SUB FINDER
HTB SUB FINDER is a simple bash script to automate subdomain discovery by brute-forcing subdomains using a wordlist. It adds the discovered subdomains to the /etc/hosts file to allow direct access to the subdomains from the terminal.

## Requirements
htbSubFinder requires the following tools to be installed on your system:

- bash
- sed
- curl

### Usage
To use htbSubFinder, simply run the htbSubFinder.sh script with the following command-line options:
```
./htbSubFinder.sh -i <target_ip> -d <domain> -w <wordlist> [-t <timeout>]
-i, --ip: The IP address of the target server.
-d, --domain: The domain to brute-force subdomains for.
-w, --wordlist: The wordlist to use for subdomain brute-forcing.
-t, --timeout: The connection timeout for curl requests (default: 4 seconds).
-h, --help: Show the help message and exit.
```
For example:
```
./htbSubFinder.sh -i 10.10.11.196 -d stocker.htb -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

This will start the subdomain discovery process with the specified options.

### Output
htbSubFinder will output the discovered subdomains to the terminal, as well as adding them to the /etc/hosts file for easy access. If no subdomains are found, htbSubFinder will exit with an error message.

### License
This project is licensed under the MIT License - see the LICENSE.md file for details.