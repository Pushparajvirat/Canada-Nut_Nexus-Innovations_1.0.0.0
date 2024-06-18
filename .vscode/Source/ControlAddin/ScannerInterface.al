controladdin ScannerInterface
{
    MaximumHeight = 1;
    MaximumWidth = 1;
    MinimumHeight = 1;
    MinimumWidth = 1;
    HorizontalShrink = true;
    VerticalShrink = true;
    RequestedHeight = 1;
    RequestedWidth = 1;
    StartupScript = './.vscode/Source/JS/Scanner.js';
    Scripts = './.vscode/Source/JS/script.js';
    event Scanned(Barcode: Text);
    procedure SetFocus();
}