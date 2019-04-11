 $FileName = "C:\Users\riwasa\Documents\Dev\azure-samples\networking\NSG\Discovery Service Tags\ServiceTags_Public_20180612.json"

 $Name = "*"

 $Region = "*"


$content = Get-Content $FileName | ConvertFrom-Json | Select -Expand values
#$contentJson = ConvertFrom-Json $content

$content



####### Search Service Tags  ############
#$selectedTags =
#Get-Content $FileName |
#ConvertFrom-Json  |
#Select -Expand values | 
#Select @{Name="Name"; Expression={ $_.name}}, 
#	@{Name="Region"; Expression={ $_.properties.Region}},
##	@{Name="Ranges"; Expression={ $_.properties.addressPrefixes.count}},
#	@{Name="Version"; Expression={ $_.properties.changeNumber}}	| 
#where { ($_.Name -like $Name) -and ( $_.Region -like $Region) } | 
#Sort-Object Name |
#Out-GridView -Title "Select Service Tag" -PassThru
#$selectedTags