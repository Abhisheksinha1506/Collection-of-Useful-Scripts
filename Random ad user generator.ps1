#
#Generate up to 5,000 "Real looking" ad accounts at once script
#preset variables for the script:
#
 
$date = Get-date -format M.d.yyyy
$ou = "OU=LANDING,DC=DEFAULTDOMAIN,DC=COM"
$principlename = "@DEFAULT.com"
$description = "Test Account Generate $date"
$Number_of_users = "5000"
$company = "Test Company" 
#Supported Nationalities: AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US
#Comma seperated values for multiple ie:
#$nationalities ="US,DK,FR"
$nationalities = "US"
 
#
#end of preset variables for script:
#
 
 
function find_ad_id($first, $last) {
    $first = $first -Replace "\s*"
    $last = $last -Replace "\s*"
    $not_found = $true
    for ($i = 1; $i -le $first.length; $i++) {
        $Sam_account = ""
        $letters_first = ""
 
        for ($l = 0; $l -ne $i; $l++) {
            $letters_first += $first[$l]
        }
 
        $sam_account = $letters_first + $last
        if (-not (Get-aduser -Filter { SamaccountName -eq $sam_account })) {
            $not_found = $false
            return $sam_account
        }
    }
 
    if ($not_found -eq $true) {
        return "ERROR:FAIL"
    }
}
 
 
 
function generate() {
    $character = @("!", "$", "%", "^", "&", "*", "(", ")", "?")
    $letters_low = @("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
    $letters_cap = @("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
    $numbers = @("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
    $itterations = get-random -minimum 8 -maximum 10
    [string]$pass_value = ""
 
    for ($i = 0; $i -ne $itterations + 1; $i++) {
        $character_type = Get-random -minimum 1 -maximum 9
 
        switch ($character_type) { 
            1 {
                $letter = Get-random -minimum 0 -maximum 26
                $pass_value = $pass_value + $character[$letter]
            }
 
            2 {
                $letter = Get-random -minimum 0 -maximum 26
                $pass_value = $pass_value + $letters_low[$letter] 
            }
 
            3 {
                $letter = Get-random -minimum 0 -maximum 11
                $pass_value = $pass_value + $letters_low[$letter] 
            }
 
            4 {
                $letter = Get-random -minimum 0 -maximum 11
                $pass_value = $pass_value + $letters_cap[$letter] 
            }
 
            5 {
                $letter = Get-random -minimum 0 -maximum 11
                $pass_value = $pass_value + $character[$letter] 
            }
 
            6 {
                $letter = Get-random -minimum 0 -maximum 11
                $pass_value = $pass_value + $numbers[$letter] 
            }
 
            7 {
                $letter = Get-random -minimum 0 -maximum 11
                $pass_value = $pass_value + $letters_cap[$letter] 
            }
 
            8 {
                $letter = Get-random -minimum 0 -maximum 11
                $pass_value = $pass_value + $letters_cap[$letter]
            }
        }
 
        $letter = Get-random -minimum 0 -maximum 26
        $pass_value = $pass_value + $character[$letter]
 
        $letter = Get-random -minimum 0 -maximum 11
        $pass_value = $pass_value + $letters_cap[$letter]
 
        $letter = Get-random -minimum 0 -maximum 11
        $pass_value = $pass_value + $numbers[$letter]
    }
    return $pass_value
}
 
 
 
 
echo "Status,Date,SamAccountName,Password,FirstName,LastName,DisplayName,City,Phone" >> create_output.csv
$user_data_json_list = invoke-restmethod "https://www.randomuser.me/api/?results=$Number_of_users&nat=$nationalities" | select -expandproperty results
foreach ($user_data_json in $user_data_json_list) {
 
    $aduser_Given = $user_data_json.name.first
    $aduser_Surname = $user_data_json.name.last
    $aduser_password = generate
    $aduser_display = $user_data_json.name.last + ", " + $user_data_json.name.first
    $aduser_phone = $user_data_json.phone
    $aduser_city = $user_data_json.location.city
    $aduser_samaccountname = find_ad_id $aduser_Given $aduser_Surname
 
    if ($aduser_samaccountname -eq "ERROR:FAIL") {
        echo "Failure $aduser_Surname sam account in use"
        echo "Error Samaccount,""$date"",""$aduser_samaccountname"",""$aduser_password"",""$aduser_Given"",""$aduser_Surname"",""$aduser_display"",""$aduser_city"",""$aduser_phone""" >> create_output.csv
    }
    else {
        New-ADUser -AccountPassword (ConvertTo-SecureString “$aduser_password” -AsPlainText -Force) -ChangePasswordAtLogon $false -City $aduser_city -company “$company_name” -DisplayName “$aduser_display” -Enabled $true -MobilePhone “$aduser_phone” -Name “$aduser_display” -SamAccountName $aduser_samaccountname -Path “$ou" -givenname $aduser_Given -surname $aduser_Surname -userprincipalname (“$aduser_samaccountname” + “$principlename”) -description “$description”
        clear
        Write-Host "`r Generating user: $aduser_Given $aduser_Surname" -NoNewLine
        echo "Success,""$date"",""$aduser_samaccountname"",""$aduser_password"",""$aduser_Given"",""$aduser_Surname"",""$aduser_display"",""$aduser_city"",""$aduser_phone""" >> create_output.csv
    }
}