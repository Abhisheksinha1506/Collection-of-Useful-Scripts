###::: This script prompts for data inputs and then calculates whether sending your data via carrier pigeon would be faster than sending it via the internet
###::: ask what bandwidth you have in mbps
$bandwidth = Read-Host -Prompt 'what is your bandwidth in mbps?'
###::: ask how much data there is in GB
$dataload = Read-Host -Prompt 'How much data do you wish to transfer in GB?'
###::: how many KM the data will travel
$distance = Read-Host -Prompt 'How many KM must the data travel?'
###::: convert roughly to megabits
$dataloadmbits = ($dataload / 0.0001)
$Pigeonspeed = [math]::round($distance / 80,2)
$pigeoncount = [math]::ceiling($dataload / 96)
$datatransfer = [math]::round(($dataloadmbits / $bandwidth) / 3600,2)
echo "it will take $pigeoncount pigeons $pigeonspeed hours to carry your data"
echo "compared to $datatransfer hours on your bandwidth"