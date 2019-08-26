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
1. If necessary, adjust your secondary monitor
   ```PowerShell
   $SecondaryMonitor = [Windows.Forms.Screen]::AllScreens[1].WorkingArea
   ```
   * 'AllScreens[1]' refers to 'Screen 2' in Display Setting
   * If you are presenting 'Screen 1', change the number to 'AllScreens[0]'
2. Run the script using the shortcut or from PowerShell
3. Drag and drop image files to the listbox
4. Remove unwanted files using up/down key and delete key
5. Clic the listbox to show the selected image, maximized in the secondary monitor

## Reference
* [Microsoft dotnet API](https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms)
* [RLV Blog: A drag-and-drop GUI made with PowerShell](https://www.rlvision.com/blog/a-drag-and-drop-gui-made-with-powershell)
