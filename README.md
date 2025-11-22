> [!WARNING]
> This repository is not affiliated with ControlD Inc in any way. You use scripts from this repository at your own risk. The author is not responsible for any damage resulting from the use of these scripts. You have been warned.
>


```
   _____ _______ _____  _      _____    __          _______ _   _    _____ _   _  _____ _______ 
  / ____|__   __|  __ \| |    |  __ \   \ \        / /_   _| \ | |  |_   _| \ | |/ ____|__   __|
 | |       | |  | |__) | |    | |  | |   \ \  /\  / /  | | |  \| |    | | |  \| | (___    | |   
 | |       | |  |  _  /| |    | |  | |    \ \/  \/ /   | | | . ` |    | | | . ` |\___ \   | |   
 | |____   | |  | | \ \| |____| |__| |     \  /\  /   _| |_| |\  |   _| |_| |\  |____) |  | |   
  \_____|  |_|  |_|  \_\______|_____/       \/  \/   |_____|_| \_|  |_____|_| \_|_____/   |_|   
                                                                                                
```


# USAGE

> [!WARNING]
> Be sure you bypass running PowerShell Scripts as Admin for local files:
> 
> ```
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> Check status:
> ```
> Get-ExecutionPolicy -List
> ```
> 

Before you go, be sure you have default DNS setup in Windows.  <br/>
Use valid `-InterfaceIndex`. <br/>
Get it from `Get-DnsClientServerAddress` <br/>
Example:
`Set-DnsClientServerAddress -InterfaceIndex 1 -ResetServerAddresses;Set-DnsClientServerAddress -InterfaceIndex 2 -ResetServerAddresses` <br/>
Execute `*.ps1` files in PowerShell. <br/>
CTRLD will set `localhost` as DNS Server.  <br/>

# REFERENCE

- https://docs.controld.com/docs/ctrld <br/>
- https://docs.controld.com/docs/free-dns
