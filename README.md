# Portable mingw64/vscode

To enable Sandbox using PowerShell, open PowerShell as Administrator and run:

```
Get-WindowsOptionalFeature -online -FeatureName Containers-DisposableClientVM
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
```

## Create the portable folder

Download this repository as zip-file and extract it to the `Desktop`.</br>
Double-click `bootstrap.wsb` to start the Sandbox.<br>
In the sandbox, open `bootstrap_share` and execute the `bootstrap.cmd` command.<br>
After some time, you can find the folder `portable_mingw_vscode` within `bootstrp_share`.<br>
This folder the final portable install - you can move it to another computer or a thumb-drive.


## Using the portable folder

Double-click on `vscode/Code.exe` to open Visual Studio Code.<br>
Select `Open Folder...` form the `File` menu and navigate to `projects\hello_world`.

### Kit and debugger

Kit: `Clang cpp4bio`<br>
Debugger: `C++ (GDB/LLDB)`<br>


## Tools used
- [Shortcut.exe](http://www.optimumx.com/download/Shortcut.zip)
- [tx.exe](https://tukaani.org/xz/)
- [wget.exe](https://eternallybored.org/misc/wget/releases/wget-1.20-win64.zip)
