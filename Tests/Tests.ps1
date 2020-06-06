<# $ErrorActionPreference = "Continu"
try {
    $PrinterList = Get-printer -ComputerName SRV-PRINT01
    foreach ($Printer in $PrinterList) {
        if ((($Printer.Name -like "IMP*") -or ($Printer.Name -like "HP *") ) -and ($printer.name -notlike "*_uf")) {
            $NewPrinter = [PRINTER]::new($Printer.Name)
            if ($Printer.DriverName -like "HP*") {
                $NewPrinter.SetDriverName("HP Universal Printing PCL 6")
                $NewPrinter.SetPrintProcessor("hpcpp240")
                $NewPrinter.SetDataType("RAW")
            }
            Else {
                $NewPrinter.SetDriverName($Printer.DriverName)
                $NewPrinter.SetPrintProcessor($Printer.PrintProcessor)
                $NewPrinter.SetDataType($Printer.Datatype)
            }
            $NewPrinter.SetSharedName($Printer.ShareName)
            $NewPrinter.SetPortName($printer.PortName)

            $NewPrinter.SetPublishedStatus($Printer.Published)
            $NewPrinter.SetSharedStatus($printer.Shared)
            $NewPrinter.SetLocation($Printer.Location)

            $NewPrinter.SetComputerName($Printer.ComputerName)
            $NewPrinter
        }
    }
}
catch {
    Write-Output ('ErrorId: {0}' -f $_.Exception.Message)
    Write-Output ('Exception: {0}' -f $_.FullyQualifiedErrorId)
    Write-Output (' Category: {0}' -f (($_.Exception.GetType() | Select-Object -ExpandProperty UnderlyingSystemType).FullName))
}
finally {

} #>

$Printer = Get-Printer -ComputerName SRV-PRINT01 | Where-Object { $_.Name -eq "HP LJ2055 JENNY" }
$NewPrinter = [PRINTER]::new($Printer.Name)
$NewPrinter.SetPortName($Printer.PortName)
$NewPrinter.SetSharedName($Printer.ShareName)
$NewPrinter.SetDriverName("HP Universal Printing PCL 6 (v6.9.0)")
$NewPrinter.SetLocation($Printer.Location)
$NewPrinter.SetPrintProcessor("hpcpp240")
$NewPrinter.SetDataType($Printer.Datatype)
$NewPrinter.SetSharedStatus($Printer.Shared)
$NewPrinter.SetPublishedStatus($Printer.Published)


$NewPrinter.CopyPrinterFromTo("SRV-PRINT01", "SRV-PRINT02")