# Build a Better Function https://technet.microsoft.com/en-us/magazine/hh360993.aspx
# The One Only Provide Common Functions, no specific tasks

function Open-FileDialog {
  <#
    .Synopsis
       Forms dialog to open file.
    .DESCRIPTION
       Forms dialog to open file.
    .EXAMPLE
       $pathtofile = Open-FileDialog -title "Please select `"Some random file.xlsx`"" -filter "Excel workbook (*.xlsx)|*.xlsx"
    .PARAMETER title
      Title of dialog window.
    .PARAMETER filter
      Extension filter in dialog window.
    .FUNCTIONALITY
       Forms dialog to open file.
  #>
  param(
    [parameter(Mandatory = $true)][string]$title,
    [string]$filter="All files (*.*)|*.*"
  )

 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null     

 $objForm = New-Object System.Windows.Forms.OpenFileDialog
 $objForm.Title = "$title"
 if ($filter) {
   $objForm.Filter = $filter
   $objForm.FilterIndex = 2
 }
 $Show = $objForm.ShowDialog()
 if ($Show -eq "OK") {
   return $objForm.FileName
 } else {
   return $null
 }
}

function Open-InputBox {
  <#
    .Synopsis
       Forms dialog to input some string.
    .DESCRIPTION
       Forms dialog to input some string.
    .EXAMPLE
       $somestring = Open-InputBox -title "String input" -message "Please input some string"
    .EXAMPLE
       $somestring = Open-InputBox -title "Username input" -message "Please input your username" -string $env:username
    .PARAMETER title
      Title of dialog window.
    .PARAMETER message
      Some message to be shown in window.
    .PARAMETER width
      Forms window width.
    .PARAMETER height
      Forms window height.
    .PARAMETER string
      Some string to be shown in inputbox.
    .FUNCTIONALITY
       Forms dialog to input some string.
  #>
  param(
    [parameter(Mandatory = $true)][string]$title,
    [string]$message,
    [int]$width=300,
    [int]$height=170,
    [string]$string
  )
  
  [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
  [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null


  #buttons actions
  $OKButtonAction = {
    $script:x = $objTestBox.Text
    $objForm.Close()
  }
  $CancelButtonAction = {
    $script:x = $null
    $objForm.Close()
  }

  $objForm = New-Object System.Windows.Forms.Form
  $objForm.Text = $title
  $objForm.Size = New-Object System.Drawing.Size($width,$height)
  $objForm.MaximumSize = New-Object System.Drawing.Size($width,$height)
  $objForm.MinimumSize = New-Object System.Drawing.Size($width,$height)
  $objForm.MinimizeBox = $false
  $objForm.MaximizeBox = $false
  $objForm.ControlBox = $false
  $objForm.StartPosition = "CenterScreen"

  $objForm.KeyPreview = $True
  $objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
      {Invoke-Command -NoNewScope $OKButtonAction}})
  $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
      {Invoke-Command -NoNewScope $CancelButtonAction}})

  $objLabel = New-Object System.Windows.Forms.Label
  $objLabel.Location = New-Object System.Drawing.Size(5,10) 
  $objLabel.Size = New-Object System.Drawing.Size(($width - 16),40) 
  $objLabel.Text = $message
  $objForm.Controls.Add($objLabel)

  $objTestBox = New-Object System.Windows.Forms.TextBox
  $objTestBox.Location = New-Object System.Drawing.Size(5,60)
  $objTestBox.Size = New-Object System.Drawing.Size(($width - 30),20)
  if ($string) {
    $objTestBox.Text = $string
  }
  $objForm.Controls.Add($objTestBox)

  $OKButton = New-Object System.Windows.Forms.Button
  $OKButton.Location = New-Object System.Drawing.Size((($width - 155) / 2),($height - 70))
  $OKButton.Size = New-Object System.Drawing.Size(75,23)
  $OKButton.Text = "OK"
  $OKButton.Add_Click($OKButtonAction)
  $objForm.Controls.Add($OKButton)
  
  $CancelButton = New-Object System.Windows.Forms.Button
  $CancelButton.Location = New-Object System.Drawing.Size((($width - 155) / 2 + 80),($height - 70))
  $CancelButton.Size = New-Object System.Drawing.Size(75,23)
  $CancelButton.Text = "Cancel"
  $CancelButton.Add_Click($CancelButtonAction)
  $objForm.Controls.Add($CancelButton)

  $objForm.ShowDialog()| Out-Null

  return $x
}

function Show-MessageBox { 
  <#
    .Synopsis
       MessageBox dialog.
    .DESCRIPTION
       MessageBox dialog.
    .EXAMPLE
       $result = Show-MessageBox -Title "Infromation" -Msg "This is just an information window" -Informational
    .PARAMETER title
      Title of Message window.
    .PARAMETER Msg
      Some message to be shown in window.
    .PARAMETER OkCancel
      Set Message Box Style.
    .PARAMETER AbortRetryIgnore
      Set Message Box Style.
    .PARAMETER YesNoCancel
      Set Message Box Style.
    .PARAMETER YesNo
      Set Message Box Style.
    .PARAMETER RetryCancel
      Set Message Box Style.
    .PARAMETER Critical
      Set Message box Icon.
    .PARAMETER Question
      Set Message box Icon.
    .PARAMETER Warning
      Set Message box Icon.
    .PARAMETER Informational
      Set Message box Icon.
    .FUNCTIONALITY
       MessageBox dialog.
  #>
  Param( 
    [Parameter(Mandatory=$True)][Alias('M')][String]$Msg, 
    [Parameter(Mandatory=$False)][Alias('T')][String]$Title = "", 
    [Parameter(Mandatory=$False)][Alias('OC')][Switch]$OkCancel, 
    [Parameter(Mandatory=$False)][Alias('OCI')][Switch]$AbortRetryIgnore, 
    [Parameter(Mandatory=$False)][Alias('YNC')][Switch]$YesNoCancel, 
    [Parameter(Mandatory=$False)][Alias('YN')][Switch]$YesNo, 
    [Parameter(Mandatory=$False)][Alias('RC')][Switch]$RetryCancel, 
    [Parameter(Mandatory=$False)][Alias('C')][Switch]$Critical, 
    [Parameter(Mandatory=$False)][Alias('Q')][Switch]$Question, 
    [Parameter(Mandatory=$False)][Alias('W')][Switch]$Warning, 
    [Parameter(Mandatory=$False)][Alias('I')][Switch]$Informational
  ) 

  #Set Message Box Style 
  IF($OkCancel){$Type = 1} 
  Elseif($AbortRetryIgnore){$Type = 2} 
  Elseif($YesNoCancel){$Type = 3} 
  Elseif($YesNo){$Type = 4} 
  Elseif($RetryCancel){$Type = 5} 
  Else{$Type = 0} 
     
  #Set Message box Icon 
  If($Critical){$Icon = 16} 
  ElseIf($Question){$Icon = 32} 
  Elseif($Warning){$Icon = 48} 
  Elseif($Informational){$Icon = 64} 
  Else{$Icon = 0} 
     
  #Loads the WinForm Assembly, Out-Null hides the message while loading. 
  [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null 
 
  #Display the message with input 
  $Answer = [System.Windows.Forms.MessageBox]::Show($MSG , $TITLE, $Type, $Icon) 
     
  #Return Answer 
  Return $Answer 
}

function Save-FileDialog {
  <#
    .Synopsis
       Forms dialog to save file.
    .DESCRIPTION
       Forms dialog to save  file.
    .EXAMPLE
       $pathtofile = Save-FileDialog -title "Choose where to save file" -filter "Excel workbook (*.xlsx)|*.xlsx"
    .PARAMETER title
      Title of dialog window.
    .PARAMETER filename
      Predefined file name.
    .PARAMETER filter
      Extension filter in dialog window.
    .FUNCTIONALITY
       Forms dialog to save  file.
  #>
  param(
    [string]$title,
    [string]$filename,
    [string]$filter="All files (*.*)|*.*"
  )

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null     

  $objForm = New-Object System.Windows.Forms.SaveFileDialog
  $objForm.Title = $title
  $objForm.FileName = $filename
  if ($filter) {
    $objForm.Filter = $filter
    $objForm.FilterIndex = 2
  }
  $Show = $objForm.ShowDialog()
  if ($Show -eq "OK")
  {
    return $objForm.FileName
  } else {
    return $null
  }
}

function Show-Balloon{
	param(
		[string]$title,
		[string]$text
	)
	
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
 
	$balloon = New-Object System.Windows.Forms.NotifyIcon
	$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
	$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
	$balloon.Icon = $icon
	$balloon.BalloonTipIcon = 'Info'
	$balloon.BalloonTipText = $text
	$balloon.BalloonTipTitle = $title
	$balloon.Visible = $true
	$balloon.ShowBalloonTip(10000)
	Start-Sleep -Seconds 5
	$balloon.Dispose()
}

function Get-InstalledSoftware{
  $InstalledSoftware = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | Get-ItemProperty
  IF (Test-path HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\){
      $InstalledSoftware += Get-ChildItem HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ | Get-ItemProperty
  }
  IF (Test-path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\) {
     $InstalledSoftware += Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ | Get-ItemProperty
  }
  $list = $InstalledSoftware | Where {$_.DisplayName -ne $Null -AND $_.SystemComponent -ne "1" } 
  if($list -ne  $Null){
    $list = $list|Select DisplayName,ParentDisplayName|Sort-Object {"$_"}
  }
  return $list
}

function Get-WebFile {
  <#
    Downloads a file or page from the web
    .Example
    Get-WebFile http://mirrors.cnnic.cn/apache/couchdb/binary/win/1.4.0/setup-couchdb-1.4.0_R16B01.exe 
    Downloads the latest version of this file to the current directory
  #>
  [CmdletBinding(DefaultParameterSetName="NoCredentials")]
   param(
      #  The URL of the file/page to download
      [Parameter(Mandatory=$true,Position=0)]
      [System.Uri][Alias("Url")]$Uri # = (Read-Host "The URL to download")
   ,
      #  A Path to save the downloaded content. 
      [string]$FileName
   ,
      #  Leave the file unblocked instead of blocked
      [Switch]$Unblocked
   ,
      #  Rather than saving the downloaded content to a file, output it.  
      #  This is for text documents like web pages and rss feeds, and allows you to avoid temporarily caching the text in a file.
      [switch]$Passthru
   ,
      #  Supresses the Write-Progress during download
      [switch]$Quiet
   ,
      #  The name of a variable to store the session (cookies) in
      [String]$SessionVariableName
   ,
      #  Text to include at the front of the UserAgent string
      [string]$UserAgent = "PowerShellWget/$(1.0)"
   )

   Write-Verbose "Downloading &#39;$Uri'"
   $EAP,$ErrorActionPreference = $ErrorActionPreference, "Stop"
   $request = [System.Net.HttpWebRequest]::Create($Uri);
   $ErrorActionPreference = $EAP
   $request.UserAgent = $(
         "{0} (PowerShell {1}; .NET CLR {2}; {3}; http://www.caiyunlin.com)" -f $UserAgent,
         $(if($Host.Version){$Host.Version}else{"1.0"}),
         [Environment]::Version,
         [Environment]::OSVersion.ToString().Replace("Microsoft Windows ", "Win")
      )

   $Cookies = New-Object System.Net.CookieContainer
   if($SessionVariableName) {
      $Cookies = Get-Variable $SessionVariableName -Scope 1
   }
   $request.CookieContainer = $Cookies
   if($SessionVariableName) {
      Set-Variable $SessionVariableName -Scope 1 -Value $Cookies
   }

   try {
      $res = $request.GetResponse();
   } catch [System.Net.WebException] {
      Write-Error $_.Exception -Category ResourceUnavailable
      return
   } catch {
      Write-Error $_.Exception -Category NotImplemented
      return
   }

   if((Test-Path variable:res) -and $res.StatusCode -eq 200) {
      if($fileName -and !(Split-Path $fileName)) {
         $fileName = Join-Path (Convert-Path (Get-Location -PSProvider "FileSystem")) $fileName
      }
      elseif((!$Passthru -and !$fileName) -or ($fileName -and (Test-Path -PathType "Container" $fileName)))
      {
         [string]$fileName = ([regex]'&#40;?i)filename=(.*)$').Match( $res.Headers["Content-Disposition"] ).Groups[1].Value
         $fileName = $fileName.trim("&#92;/""'")

         $ofs = ""
         $fileName = [Regex]::Replace($fileName, "[$([Regex]::Escape(""$([System.IO.Path]::GetInvalidPathChars())$([IO.Path]::AltDirectorySeparatorChar)$([IO.Path]::DirectorySeparatorChar)""))]", "_")
         $ofs = " "

         if(!$fileName) {
            $fileName = $res.ResponseUri.Segments[-1]
            $fileName = $fileName.trim("\/")
            if(!$fileName) {
               $fileName = Read-Host "Please provide a file name"
            }
            $fileName = $fileName.trim("\/")
            if(!([IO.FileInfo]$fileName).Extension) {
               $fileName = $fileName + "." + $res.ContentType.Split(";")[0].Split("/")[1]
            }
         }
         $fileName = Join-Path (Convert-Path (Get-Location -PSProvider "FileSystem")) $fileName
      }
      if($Passthru) {
         $encoding = [System.Text.Encoding]::GetEncoding( $res.CharacterSet )
         [string]$output = ""
      }

      [int]$goal = $res.ContentLength
      $reader = $res.GetResponseStream()
      if($fileName) {
         try {
            $writer = new-object System.IO.FileStream $fileName, "Create"
         } catch {
            Write-Error $_.Exception -Category WriteError
            return
         }
      }
      [byte[]]$buffer = new-object byte[] 4096
      [int]$total = [int]$count = 0
      do
      {
         $count = $reader.Read($buffer, 0, $buffer.Length);
         if($fileName) {
            $writer.Write($buffer, 0, $count);
         }
         if($Passthru){
            $output += $encoding.GetString($buffer,0,$count)
         } elseif(!$quiet) {
            $total += $count
            if($goal -gt 0) {
               Write-Progress "Downloading $Uri" "Saving $total of $goal" -id 0 -percentComplete (($total/$goal)*100)
            } else {
               Write-Progress "Downloading $Uri" "Saving $total bytes..." -id 0
            }
         }
      } while ($count -gt 0)

      $reader.Close()
      if($fileName) {
         $writer.Flush()
         $writer.Close()
      }
      if($Passthru){
         $output
      }
   }
   if(Test-Path variable:res) { $res.Close(); }
   if($fileName) {
      ls $fileName
   }
}

function Extract-File{
  Param(
    [Parameter(Mandatory=$True,HelpMessage="Enter Zip FileName")][string]$ZipFileName,
    [Parameter(Mandatory=$True,HelpMessage="Enter Destination Path")][string]$Destination
  )
   
  if(test-path($ZipFileName))
  {   
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace($ZipFileName)
    if(!(test-path($destination))){
        $d = New-Item -Path $destination -Type Directory
        Write-Host "Creating Folder "$d.FullName
    }
    $destinationFolder = $shellApplication.NameSpace($destination)
    Write-Host "Extracting "$ZipFileName" to "$destination

    #CopyHere parameter definition please refer http://msdn.microsoft.com/en-us/library/bb787866(VS.85).aspx
    #16:Respond with "Yes to All" for any dialog box that is displayed. It will overwrite the existing files
    $destinationFolder.CopyHere($zipPackage.Items(),16)
  }
  else{
    Write-Host "Can't Find $ZipFileName"
  }
}

function Install-Software{
  #Download And Install Softwares
   
  #end  
}

function Show-Help(){
  Write-Host "Open-FileDialog"
  Write-Host "Open-InputBox"
  Write-Host "Show-MessageBox"
  Write-Host "Show-FileDialog"
  Write-Host "Show-Balloon"
  Write-Host "Get-WebFile"
  Write-Host "Install-Software"
  Write-Host "Show-Help"
}

New-Alias install Install-Software

Write-Host "TheOne Loaded Successfully" -ForegroundColor Green