Add-Type -AssemblyName System.Windows.Forms
$timerMs = 30000
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $timerMs
$timer.add_tick({wakeup; })

function AddToLog($logtext){
    $textBox.Text = $textBox.Text + "`r`n" + $logtext
    $textBox.ScrolltoCaret
}

function startTimer() {
    AddToLog "Timer started. The computer will wake up every $($timerMs / 1000) seconds."
    $timer.start()
}

function stopTimer() {
    AddToLog "Ending timer."
    $timer.Enabled = $false
    $timer.stop()
}

function wakeup() {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Minimum 1 -Maximum 1920), (Get-Random -Minimum 1 -Maximum 1080))
    [System.Windows.Forms.SendKeys]::SendWait("+")
    AddToLog "Moved mouse and pressed 'SHIFT' key at $(Get-Date)"
}

########################
# Setup User Interface
########################
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$form = New-Object System.Windows.Forms.Form
$form.Text = "STAY-AWAKE"
$form.Size = New-Object System.Drawing.Size(330, 290)
$form.StartPosition = "CenterScreen"

# Start Button
$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Location = New-Object System.Drawing.Point(10, 10)
$btnStart.Size = New-Object System.Drawing.Size(140, 35)
$btnStart.Text = "Start"
$btnStart.Add_MouseHover({ $this.Cursor = "Hand" })

$btnStart.Add_Click({StartTimer; })
$form.Controls.Add($btnStart)

# Stop Button
$btnStop = New-Object System.Windows.Forms.Button
$btnStop.Location = New-Object System.Drawing.Point(160, 10)
$btnStop.Size = New-Object System.Drawing.Size(140, 35)
$btnStop.Text = "Stop"
$btnStop.Add_Click({StopTimer; })
$form.Controls.Add($btnStop)
$btnStop.Enabled  = $true
$btnStop.Add_MouseHover({ $this.Cursor = "Hand" })

# Close Button
$form.Add_FormClosing({
    Write-Host "Cleaning up"
    StopTimer;
    $timer.Dispose();
})

# Log Area
$textLogLabel = New-Object System.Windows.Forms.Label
$textLogLabel.Location = New-Object System.Drawing.Point(10, 50)
$textLogLabel.Size = New-Object System.Drawing.Size(80, 20)
$textLogLabel.Text = "Event Log:"
$form.Controls.Add($textLogLabel)

$textBox = New-Object System.Windows.Forms.Textbox
$textBox.Location = New-Object System.Drawing.Point(10, 70)
$textBox.Size = New-Object System.Drawing.Size(290, 170)
$textBox.Multiline = $True
$textBox.Scrollbars = "vertical"

$textBox.Add_Click({$textBox.SelectAll(); $textBox.Copy()})
$form.Controls.Add($textBox)

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
