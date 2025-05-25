Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore, PresentationFramework

[xml]$ngineXAML = get-content -path "gui.xaml"
$Reader= New-Object System.Xml.XmlNodeReader $ngineXAML
$ngineWindow = [Windows.Markup.XamlReader]::Load($Reader)

$global:fPath = $null

$ngineXAML.SelectNodes("//*[@Name]") | Foreach-Object {Set-Variable -Name $_.Name -Value $ngineWindow.FindName($_.Name)}

$iFile.Add_Click(
        {    
      $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
      $FileBrowser.Filter = "Video Format |*.avi; *.flv; *.mp4; *.m4a; *.m4b; *.m4v; *.mov; *.ogv; *.ogg";
      if ($FileBrowser.ShowDialog() -eq "Ok") {
        $global:fPath = $FileBrowser.FileName
        $MetadataResolution = ./bin/ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=p=0:s=x $($global:fPath)
        $MetadataRatio = ./bin/ffprobe -v error -select_streams v -show_entries stream=display_aspect_ratio -of csv=p=0:s=x $($global:fPath)

        if ($MetadataResolution.Split("x")[0] -lt $MetadataResolution.Split("x")[1]) {
          $rotation = "(Portrait)"
        } else {
          $rotation = "(Paysage)"
        }

        $MetadataBits = [Math]::Round((./bin/ffprobe -v error -select_streams v -show_entries stream=bit_rate -of csv=p=0:s=x $($global:fPath)) / 1000)

        $infoBox.Text = "Resolution (W x H): $($MetadataResolution)
Ratio : $($MetadataRatio)
Débit : $($MetadataBits)" + " Kbit/s"
        $infoBox.FontSize = 16
        $infoBox.Height = 130
        $infoBox.Width = 475
      }
    })

$eFile.Add_Click({
  if ($global:fPath -ne $null) {
    $saveWindow = New-Object System.Windows.Forms.SaveFileDialog 
    $saveWindow.Filter = "Video Format |*.avi; *.flv; *.mp4; *.m4a; *.m4b; *.m4v; *.mov; *.avi; *.flv; *.ogv; *.ogg";
    if ($saveWindow.ShowDialog() -eq "Ok") {
      $ePath = $saveWindow.FileName

      if ($MetadataRatio -eq "N/A") {
        $ArgumentList = "-y -i $($fPath) -c:v libx264 -r 24 -b:v 6000k -maxrate 6000k -bufsize 1M -crf 20 -vf $($ePath)"
      } else {
        $ArgumentList = "-y -i $($fPath) -c:v libx264 -r 24 -b:v 6000k -maxrate 6000k -bufsize 1M -crf 20 -vf setdar=$($MetadataRatio) $($ePath)"
      }
        $ffmpegprocess = Start-Process -FilePath ".\bin\ffmpeg.exe" -ArgumentList $ArgumentList -Wait -NoNewWindow
        Write-Host $ffmpegprocess
        $MetadataResolution = ./bin/ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=p=0:s=x $($ePath)
        $MetadataRatio = ./bin/ffprobe -v error -select_streams v -show_entries stream=display_aspect_ratio -of csv=p=0:s=x $($ePath)

        <#if ($MetadataResolution.Split("x")[0] -lt $MetadataResolution.Split("x")[1]) {
          $rotation = "(Portrait)"
        } else {
          $rotation = "(Paysage)"
        }#>

        $MetadataBits = [Math]::Round((./bin/ffprobe -v error -select_streams v -show_entries stream=bit_rate -of csv=p=0:s=x $($ePath)) / 1000)

        $exportInfoBox.Text = "Here are the details of your compressed video : 
        
Resolution (W x H): $($MetadataResolution)
Ratio : $($MetadataRatio) 
Débit : $($MetadataBits)" + " Kbit/s"
        $exportInfoBox.FontSize = 16
        $exportInfoBox.Height = 130
        $exportInfoBox.Width = 475
    }
  } else {
    [System.Windows.MessageBox]::Show("You did not select the video you would like to compress. Click on 'Browse Media' to do so then retry.", "Unknown Video", 0, 48)
  }
})

$deleteMedia.Add_Click({
  $global:fPath = $null
  $infoBox.Text = "The details about your MP4 video will be displayed inside this box"
})

Write-Host $FR_original

$ngineWindow.ShowDialog() | Out-Null