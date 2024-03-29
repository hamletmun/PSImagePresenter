# PSImagePresenter
Very simple image presenter using PowerShell and WinForms

## Installation
1. Download [PSImagePresenter.ps1](../../raw/master/PSImagePresenter.ps1)
2. Create a shortcut with proper Target value
   ```
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%USERPROFILE%\Downloads\PSImagePresenter.ps1"
   ```
   * Bypass the default 'Restricted' execution policy
   * Hide 'Normal' black shell console window
   * Adjust the path, for example,"C:\Scripts\PSImagePresenter.ps1"

## Usage
1. Run **PSImagePresenter.ps1** using the shortcut or from PowerShell
2. Drag and drop image files to the listbox
3. Remove unwanted files using up/down key and delete key
4. Clic the listbox to show the selected image, maximized in the selected screen

## Reference
* [Microsoft dotnet API](https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms)
* [NETImagePresenter](https://github.com/hamletmun/NETImagePresenter)
* [RLV Blog: A drag-and-drop GUI made with PowerShell](https://www.rlvision.com/blog/a-drag-and-drop-gui-made-with-powershell)
