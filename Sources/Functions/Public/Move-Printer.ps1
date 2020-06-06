#region <Move-Printer>
#After building the function and defining the parameters
#Place yourself here and do ## to generate help
Function Move-Printer {
    #Start Function Move-Printer
    [CmdletBinding()]
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
        [System.String[]]$FromComputerName,
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Mandatory,
            ParameterSetName = "ByPrinterName"
        )]
        [System.String[]]$ToComputerName
    )

    Begin {
        Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss") BEGIN] Starting $($myinvocation.mycommand)"
        Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss") BEGIN] Creating an empty HashTable"
        $Result = @{ }
        $Result.Add('Error', @{ })
        $PrinterList = @()
    }

    Process {
        switch ($PSCmdlet.ParameterSetName) {
            "ByPrinterName" {
                foreach ($Name in $PrinterName) {
                    Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss")] Creating array with Printer Object"
                    if ([PRINTER]::TestIfPrinterExist($Name, $FromComputerName)) {
                        $PrinterInfo = Get-Printer -Name $Name -ComputerName $FromComputerName
                        $NewPrinter = [PRINTER]::New($Name)
                        $NewPrinter.SetDriverName($PrinterInfo.DriverName)
                        $NewPrinter.SetPrintProcessor($PrinterInfo.PrintProcessor)
                        $NewPrinter.SetDataType($PrinterInfo.Datatype)
                        $NewPrinter.SetSharedName($PrinterInfo.ShareName)
                        $NewPrinter.SetPortName($PrinterInfo.PortName)
                        $NewPrinter.SetPublishedStatus($PrinterInfo.Published)
                        $NewPrinter.SetSharedStatus($PrinterInfo.Shared)
                        $NewPrinter.SetLocation($PrinterInfo.Location)

                        $Array = @($NewPrinter)
                        $PrinterList += $Array
                    }
                }
            }
        }
    }



    End {
        Write-Verbose "[$(get-date -format "yyyy/MM/dd HH:mm:ss") END] Ending $($myinvocation.mycommand)"
        Return $Result
    }
}	 #End Function Move-Printer
#endregion <Move-Printer>