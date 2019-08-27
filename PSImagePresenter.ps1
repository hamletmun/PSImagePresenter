### https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms
### https://www.rlvision.com/blog/a-drag-and-drop-gui-made-with-powershell/

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

### Create form ###

$MainForm = New-Object Windows.Forms.Form -Property @{
    Text = "PowerShell Image Presenter"
    Size = '640,240'
    StartPosition = "CenterScreen"
    MinimumSize = '240,120'
    MaximizeBox = $False
}

$label = New-Object Windows.Forms.Label -Property @{
    Location = '5,10'
    AutoSize = $True
    Text = "Drop image files here and show on:"
}

$comboBox = New-Object Windows.Forms.ComboBox -Property @{
    Location = '187,7'
    DropDownStyle = 'DropDown'
}

1..[Windows.Forms.Screen]::AllScreens.Length | ForEach-Object {
    $comboBox.Items.Add("Screen " + $_)
}
$comboBox.SelectedIndex = $comboBox.Items.Count - 1
$SelectedScreen = [Windows.Forms.Screen]::AllScreens[$comboBox.SelectedIndex].WorkingArea

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

$MainForm.Controls.AddRange([Windows.Forms.Control[]]@($label,$comboBox,$listBox,$statusBar))

$form2 = New-Object Windows.Forms.Form -Property @{
    StartPosition = 'Manual'
    Location = New-Object Drawing.Point($SelectedScreen.X, $SelectedScreen.Y)
    WindowState = 'Maximized'
    FormBorderStyle = 'None'
    BackColor = 'Black'
}

$pictureBox = New-Object Windows.Forms.PictureBox -Property @{
    Size = New-Object Drawing.Size($SelectedScreen.Width, $SelectedScreen.Height)
    SizeMode = 'Zoom'
}

$form2.Controls.Add($pictureBox)

### Write event handlers ###

$comboBox_SelectedIndexChanged = {
    $SelectedScreen = [Windows.Forms.Screen]::AllScreens[$comboBox.SelectedIndex].WorkingArea
    $form2.WindowState = 'Normal'
    $form2.Location = New-Object Drawing.Point($SelectedScreen.X, $SelectedScreen.Y)
    $form2.WindowState = 'Maximized'
    $pictureBox.Size = New-Object Drawing.Size($SelectedScreen.Width, $SelectedScreen.Height)
}

$listBox_Click = {
    try {
        $pictureBox.Image = [Drawing.Image]::Fromfile($listBox.SelectedItem)
        $form2.Show()
    } catch {}
}

$listBox_DragEnter = [Windows.Forms.DragEventHandler]{
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
    try {
        $listBox.remove_Click($button_Click)
        $listBox.remove_DragEnter($listBox_DragEnter)
        $listBox.remove_DragDrop($listBox_DragDrop)
        $listBox.remove_KeyDown($listBox_KeyDown)
        $form2.Close()
        $MainForm.remove_FormClosed($Form_Cleanup_FormClosed)
    } catch [Exception] { }
}

### Wire up events ###

$comboBox.Add_SelectedIndexChanged($comboBox_SelectedIndexChanged)
$listBox.Add_Click($listBox_Click)
$listBox.Add_DragEnter($listBox_DragEnter)
$listBox.Add_DragDrop($listBox_DragDrop)
$listBox.Add_KeyDown($listBox_KeyDown)
$MainForm.Add_FormClosed($form_FormClosed)

#### Show form ###

[void] $MainForm.ShowDialog()
