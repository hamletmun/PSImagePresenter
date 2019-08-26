### https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms
### https://www.rlvision.com/blog/a-drag-and-drop-gui-made-with-powershell/

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$SecondaryMonitor = [Windows.Forms.Screen]::AllScreens[1].WorkingArea

### Create form ###

$form = New-Object Windows.Forms.Form -Property @{
    Text = "Powershell Image Presenter"
    Size = '640,240'
    StartPosition = "CenterScreen"
    MinimumSize = '240,120'
    MaximizeBox = $False
}

$label = New-Object Windows.Forms.Label -Property @{
    Location = '5,10'
    AutoSize = $True
    Text = "Drop image files here:"
}

$listBox = New-Object Windows.Forms.ListBox -Property @{
    Location = '5,30'
    Size = '615,150'
    Anchor = ([Windows.Forms.AnchorStyles]::Bottom -bor [Windows.Forms.AnchorStyles]::Left -bor
        [Windows.Forms.AnchorStyles]::Right -bor [Windows.Forms.AnchorStyles]::Top)
    IntegralHeight = $False
    AllowDrop = $True
}

$statusBar = New-Object Windows.Forms.StatusBar -Property @{
    Text = "Ready"
}

$form.Controls.AddRange([System.Object[]]@($label,$listBox,$statusBar))

$form2 = New-Object Windows.Forms.Form -Property @{
    StartPosition = 'Manual'
    Location = New-Object Drawing.Point($SecondaryMonitor.X, $SecondaryMonitor.Y)
    WindowState = 'Maximized'
    FormBorderStyle = 'None'
    BackColor = 'Black'
}

$pictureBox = New-Object Windows.Forms.PictureBox -Property @{
    Size = New-Object Drawing.Size($SecondaryMonitor.Width, $SecondaryMonitor.Height)
    SizeMode = 'Zoom'
}

### Write event handlers ###

$listBox_Click = {
    $pictureBox.Image = [Drawing.Image]::Fromfile($listBox.SelectedItem)

    $form2.Controls.Add($pictureBox)
    $form2.Show()
}

$listBox_DragOver = [Windows.Forms.DragEventHandler]{
    If ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop))
    {
        $_.Effect = 'Copy'
    }
    Else
    {
        $_.Effect = 'None'
    }
}
    
$listBox_DragDrop = [Windows.Forms.DragEventHandler]{
    ForEach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
    {
        $listBox.Items.Add($filename)
    }
    $statusBar.Text = ("List contains $($listBox.Items.Count) items")
}

$listBox_KeyDown = {
    If ($_.KeyCode -eq "Delete")
    {
        $listBox.Items.Remove($listBox.SelectedItem)
    }
    $statusBar.Text = ("List contains $($listBox.Items.Count) items")
}

$form_FormClosed = {
    try
    {
        $listBox.remove_Click($button_Click)
        $listBox.remove_DragOver($listBox_DragOver)
        $listBox.remove_DragDrop($listBox_DragDrop)
        $listBox.remove_KeyDown($listBox_KeyDown)
        $form2.Close()
        $form.remove_FormClosed($Form_Cleanup_FormClosed)
    }
    catch [Exception]
    { }
}

### Wire up events ###

$listBox.Add_Click($listBox_Click)
$listBox.Add_DragOver($listBox_DragOver)
$listBox.Add_DragDrop($listBox_DragDrop)
$listBox.Add_KeyDown($listBox_KeyDown)
$form.Add_FormClosed($form_FormClosed)

#### Show form ###

[void] $form.ShowDialog()
