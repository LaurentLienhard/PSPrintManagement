#Generated at 06/06/2020 13:05:29 by LIENHARD Laurent
Class Printer {
    [System.String]$Name
    [System.String]$SharedName
    [System.String]$PortName
    [System.String]$DriverName
    [System.String]$Location
    [System.String]$PrintProcessor
    [System.String]$DataType
    [System.Boolean]$Shared
    [System.Boolean]$Published
    [System.String]$ComputerName

    #region <Constructors>
    Printer() {
    }

    Printer([System.String]$Name) {
        $this.Name = $Name
    }
    #endregion <Constructors>


    #region <Set/Get>

    #region <SharedName>
    [void] SetSharedName ([System.String]$SharedName) {
        $this.SharedName = $SharedName
    }

    [System.String] GetSharedName () {
        return $this.SharedName
    }
    #endregion <SharedName>

    #region <PortName>
    [void] SetPortName ([System.String]$PortName) {
        $this.PortName = $PortName
    }

    [System.String] GetPortName () {
        return $this.PortName
    }
    #endregion <PortName>

    #region <DriverName>
    [void] SetDriverName ([System.String]$DriverName) {
        $this.DriverName = $DriverName
    }

    [System.String] GetDriverName () {
        return $this.DriverName
    }
    #endregion <DriverName>

    #region <DataType>
    [void] SetDataType ([System.String]$DataType) {
        $DataTypeCollection = "RAW", "RAW [FF appended]", "RAW [FF auto]", "NT EMF 1.003", "NT EMF 1.006", "NT EMF 1.007", "NT EMF 1.008", "TEXT", "XPS2GDI"
        if ($DataType -in $DataTypeCollection) {
            $this.DataType = $DataType
        }
        else {
            Write-Error "PrintProcessor should be in $($DataTypeCollection)"
        }
    }


    [System.String] GetDataType () {
        return $this.DataType
    }
    #endregion <DataType>

    #region <PrintProcessor>
    [void] SetPrintProcessor([System.String]$PrintProcessor) {
        $ProcessorCollection = "winprint", "ApjPrint", "hpcpp240"
        if ($PrintProcessor -in $ProcessorCollection) {
            $this.PrintProcessor = $PrintProcessor
        }
        else {
            Write-Error "PrintProcessor should be in $($ProcessorCollection)"
        }
    }

    [System.String] GetPrintProcessor () {
        return $this.PrintProcessor
    }
    #endregion <PrintProcessor>

    #region <SharedStatus>
    [void] SetSharedStatus ([System.Boolean]$Shared) {
        $this.Shared = $Shared
    }

    [System.Boolean] GetSharedStatus () {
        return $this.Shared
    }
    #endregion <SharedStatus>

    #region <PublishedStatus>
    [void] SetPublishedStatus ([System.Boolean]$Published) {
        $this.Published = $Published
    }

    [System.Boolean] GetPublishedStatus () {
        Return $this.Published
    }
    #endregion <PublishedStatus>

    #region <Location>
    [void] SetLocation ([system.String]$Location) {
        $this.Location = $Location
    }

    [System.String] GetLocation () {
        Return $this.Location
    }
    #endregion <Location>

    #region <ComputerName>
    [void] SetComputerName ([system.String]$ComputerName) {
        $This.ComputerName = $ComputerName
    }

    [System.String] GetComputerName () {
        Return $This.ComputerName
    }
    #endregion <ComputerName>

    #endregion <Set/Get>

    #region <Method>
    [System.Boolean] static TestIfPrinterExist ([System.String]$Name, [System.String]$ComputerName) {
        if (Get-Printer -ComputerName $ComputerName -Name $Name) {
            Return $true
        }
        else {
            Return $false
        }
    }
    #endregion <Method>


}
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
