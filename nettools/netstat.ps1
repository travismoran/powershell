# Object to contain output

$info = new-object system.text.stringbuilder

 

#Time when script is executing

$currentTime = get-date -uformat '%Y.%m.%d_%H_%M_%S'

$info.AppendLine("Script ran at : " + $currentTime)

 

#Machine info

$OSInfo = Get-WmiObject -class Win32_OperatingSystem

$info.AppendLine("Machine info : " + $OSInfo.Caption + " " + $OSInfo.OSArchitecture + " " + $OSInfo.Version)

 

$info.AppendLine("`nPorts and states:")

#Loop over the states in the array, add/remove states as needed

$stateList = "LISTENING", "TIME_WAIT", "ESTABLISHED"

foreach($s in $stateList)

{

    $c = netstat -aonp TCP | select-string $s

    if($c.count -le 0)

    {

        $info.AppendLine("0`t" + " ports in state " + $s)

    }

    else

    {

        $info.AppendLine($c.count.ToString() + "`t" + " ports in state " + $s)

    } 

}

 

$toFile = $args[0]

if($toFile -eq "NoFile")

{

    $info.ToString()

}

else

{

    # Create directory if it doesn't exist and setup file for output

    $outDir = "C:\NetStatReport\"

    if((Test-Path $outDir) -eq $FALSE)

    {

      New-Item $outDir -type directory

    }

    # Create file and write info

    $outFile = $outDir + "PortReport_"+$currentTime+".txt"

    New-Item $outFile -type file -force

    $info.ToString() | out-file $outFile -append

    # To prompt

    $info.ToString()

    "File written to :" + $outFile

}
