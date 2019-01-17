foreach ($file in $(Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1")){
    . $file.FullName
}