#region <Move-Printer>
<#
    .SYNOPSIS
    Move Printer

    .DESCRIPTION
    Moves printers from one print server to another.

    .PARAMETER PrinterName
    Name of one or more printers

    .PARAMETER FromComputerName
    Source print server name

    .PARAMETER ToComputerName
    Destination print server name

    .EXAMPLE
    Move-Printer -PrinterName "MyPrinter" -FromComputerName "MyPrintServer1" -ToComputerName "MyPrintServer2"

    Moves the printer to "MyPrinter" from the server "MyPrintServer1" to the server "MyPrintServer2"

    .NOTES
    General notes
#>
Function Move-Printer {
    #Start Function Move-Printer
    [CmdletBinding(DefaultParameterSetName = "ByPrinterName")]
    [OutputType([System.Collections.HashTable])]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Mandatory,
            ParameterSetName = "ByPrinterName"
        )]
        [System.String[]]$PrinterName,
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Mandatory,
            ParameterSetName = "ByPrinterName"
        )]
        [System.String]$FromComputerName,
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Mandatory,
            ParameterSetName = "ByPrinterName"
        )]
        [System.String]$ToComputerName
    )

    Begin {
        Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss") BEGIN] Starting $($myinvocation.mycommand)"
        Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss") BEGIN] Creating an empty HashTable"
        $Result = @{ }
        $Result.Add('Time', @{ })
        $Result.Add('Error', @{ })
        $PrinterList = @()


    }

    Process {
        switch ($PSCmdlet.ParameterSetName) {
            "ByPrinterName" {
                Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss")] Creating array with Printer Object"
                foreach ($Name in $PrinterName) {
                    Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss")] Printer processing $($Name)"
                    $PrinterInfo = Get-Printer -Name $Name -ComputerName $FromComputerName

                    Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss")] Creating the PRINTER object $($Name)"
                    $NewPrinter = [PRINTER]::New($Name)
                    switch -Wildcard ($PrinterInfo.DriverName) {
                        "HP*" {
                            $NewPrinter.SetDriverName("HP Universal Printing PCL 6 (v6.9.0)")
                            $NewPrinter.SetPrintProcessor("hpcpp240")
                        }
                        "BROTHER*" {
                            $NewPrinter.SetDriverName("Brother Mono Universal Printer (PCL)")
                            $NewPrinter.SetPrintProcessor("WinPrint")
                        }
                        "Canon LBP*" {
                            $NewPrinter.SetDriverName("Canon Generic Plus PCL6")
                            $NewPrinter.SetPrintProcessor("WinPrint")

                        }
                        Default {
                            $NewPrinter.SetDriverName($PrinterInfo.DriverName)
                            $NewPrinter.SetPrintProcessor($PrinterInfo.PrintProcessor)
                        }
                    }
                    $NewPrinter.SetDataType($PrinterInfo.Datatype)
                    $NewPrinter.SetSharedName($PrinterInfo.ShareName)
                    $NewPrinter.SetPortName($PrinterInfo.PortName)
                    $NewPrinter.SetPublishedStatus($false)
                    $NewPrinter.SetSharedStatus($PrinterInfo.Shared)
                    $NewPrinter.SetLocation($PrinterInfo.Location)

                    Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss")] Adding the object $($Name) to the list of printers to be processed"
                    $Array = @($NewPrinter)
                    $PrinterList += $Array
                }
            }
        }

        foreach ($Printer in $PrinterList) {
            $Printer.Create($ToComputerName)

        }

    }



    End {
        Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss") END] Ending $($myinvocation.mycommand)"
        Return $Result
    }
}	 #End Function Move-Printer
#endregion <Move-Printer>