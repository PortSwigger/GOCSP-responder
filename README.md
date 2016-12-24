gocsp-server
===========
This is a go implementation of a basic OCSP Responder.  
The two other options are:  
1. openssl ocsp - does not support GET (safari) and dies on a request it does not understand  
2. openca-ocspd - has memory corruption bugs.  

It's a pretty simple protocol wrapped in HTTP.

Building
--------
This was confirmed building with Go 1.7rc6. 1.6 may or may not work. Don't say I didn't warn you :)

1. Clone the repo  
2. cd into repo  
3. export GOPATH=$PWD (or just clone it into your GOPATH)  
4. go install gocsp-responder/main  

Features
--------
- Supports HTTP GET and POST requests  
- Meant to work seamlessly with easy-rsa  
- Nonce extension supported (will implement more if needed)  
- SSL support (not recommended)  
- It works and doesn't have memory corruption bugs \*cough\*openca-ocspd\*cough\*  

Limitations
-----------
- Doesn't work with the out of the box crypto/ocsp library. I had to make some modifications for extensions.
- Only works with RSA keys (I think)
  
Tests
-----
This has been tested and working with the `openssl ocsp` command, Chrome, Firefox, and Safari.  

Options
-------
| Option   | Default Value                  | Description                                                                                                                 |
|----------|--------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| -bind    | ""                             | Bind address that the server will listen on (empty string is the same as 0.0.0.0 or all interfaces)                       |
| -cacert  | "ca.crt"                       | CA certificate filename                                                                                                    |
| -index   | "index.txt"                    | CA index filename (openssl 6 column index.txt file)                                                                        |
| -logfile | "/var/log/gocsp-responder.log" | File to log to                                                                                                             |
| -port    | 8888                           | Port that the server will listen on                                                                                        |
| -rcert   | "responder.crt"                | Responder certificate filename                                                                                             |
| -rkey    | "responder.key"                | Responder key filename                                                                                                     |
| -ssl     | false                          | Use SSL to serve. This is not widely supported and not recommended                                                         |
| -stdout  | false                          | Log to stdout and not the specified log file                                                                               |
| -strict  | false                          | Ensure Content-Type is application/ocsp-request in requests. Drop request if not. Some browsers (safari) don't supply this |
