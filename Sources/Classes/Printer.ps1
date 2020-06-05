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
    [System.String]$PSComputerName

    Printer() {
    }

    Printer([System.String]$Name) {
        $this.Name = $Name
    }

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
