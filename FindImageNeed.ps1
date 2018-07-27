Import-module ActiveDirectory # This allows for you to use Active Directory commands

$computers = Get-ADComputer -Filter * # This gets all domain computers

Foreach ($computer in $computers) {
    if ($computer.Name -match "NB.[IA]") { # This checks to see if a computer is an instructor station or student-facing computer
        if (Test-Connection -ComputerName $computer.Name -Count 1 -Quiet) { # This tests to see if the computer can be pinged
           
            # This sets the path and file to test for the computer
		    $path = "\\" + $computer.Name + "\C$\Image_Version_R14_Student_w10_x64_*"  
		   
            if (Test-Path -PathType Leaf -Path $path) { # This tests to see if the path is valid or basically if the file set above 
                # This writes the computer name to a log file is the image fingerprint file is found
			    $computer.Name | Out-File -FilePath 'C:\ComputerImageLogs\NeedsImage.txt' -Append
            } else {
                # This writes the computer name to a log file is the image fingerprint file is NOT found
			    $computer.Name | Out-File -FilePath 'C:\ComputerImageLogs\DoesNotNeedImage.txt' -Append  
		    } 
        } else {
            #Log that computer could not be reached
            $computer.Name | Out-File -FilePath 'C:\ComputerImageLogs\NoPing.txt' -Append
        }
    }
}