$_json = Get-Content '.\enteries.json' | Out-String | ConvertFrom-Json
$_enteriesNameArr = $_json.psobject.properties.name

$global:config = @{}

foreach ($_name in $_enteriesNameArr) {
    $global:config.$_name = $_json.$_name
}