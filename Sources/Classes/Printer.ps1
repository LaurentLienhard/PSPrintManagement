﻿Class Printer {
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

    [System.Boolean] static TestIfPrinterPortExist ([System.String]$PortName, [System.String]$ComputerName) {
        if (Get-PrinterPort -ComputerName $ComputerName -Name $PortName) {
            Return $true
        }
        else {
            Return $false
        }
    }

    [void] Create ([System.String]$ToComputerName) {

        Write-Warning "Create printer $($This.name) on $($ToComputerName)"
        $This.CreatePrinterPort($ToComputerName)
        $This.CreatePrinter($ToComputerName)
    }

    [void] CreatePrinter ([System.String]$ToComputerName) {
        if (!([PRINTER]::TestIfPrinterExist($This.Name, $ToComputerName))) {
            Add-Printer -Name $this.Name -ShareName $this.SharedName -Location $This.Location -Published:$This.Published -Shared:$This.Shared -Datatype $This.DataType -PrintProcessor $this.PrintProcessor -DriverName $this.DriverName -PortName $This.PortName -ComputerName $ToComputerName
            Write-Warning "Printer $($This.Name) create on $($ToComputerName)"
        }
        else {
            Write-Warning "Printer $($This.Name) already exist on $($ToComputerName)"
        }
    }

    [void] CreatePrinterPort ([System.String]$ToComputerName) {
        if (!([PRINTER]::TestIfPrinterPortExist($This.PortName, $ToComputerName))) {
            Add-PrinterPort -PrinterHostAddress $This.PortName -Name $This.PortName -ComputerName $ToComputerName
            Write-Warning "Port Name $($This.PortName) create on $($ToComputerName)"
        }
        else {
            Write-Warning "Port Name $($This.PortName) already exist on $($ToComputerName)"
        }
    }

    [void] Remove ([system.String]$FromComputerName) {
        $This.RemovePrinter($FromComputerName)
        $This.RemovePrinterPort($FromComputerName)
    }


    [void] RemovePrinter ([system.String]$FromComputerName) {
        if (([PRINTER]::TestIfPrinterExist($This.Name, $FromComputerName))) {
            Remove-Printer -Name $this.Name -ComputerName $FromComputerName -Confirm:$false
            Write-Warning "Printer $($This.Name) remove from $($FromComputerName)"
        }
        else {
            Write-Warning "Printer $($This.Name) doesn't exist on $($FromComputerName)"
        }
    }


    [void] RemovePrinterPort([system.String]$FromComputerName) {
        if (([PRINTER]::TestIfPrinterPortExist($This.PortName, $FromComputerName))) {
            Remove-PrinterPort -Name $This.PortName -ComputerName $FromComputerName -Confirm:$false
            Write-Warning "Port Name $($This.PortName) remove from $($FromComputerName)"
        }
        else {
            Write-Warning "Port Name $($This.PortName) doesn't exist on $($FromComputerName)"
        }
    }
}
#endregion <Method>

