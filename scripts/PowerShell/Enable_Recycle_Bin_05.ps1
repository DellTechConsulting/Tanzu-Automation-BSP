$ForestFQDN = "contoso.com"
$SchemaDC   = "serverdc01.contoso.com"

Enable-ADOptionalFeature –Identity 'Recycle Bin Feature' –Scope ForestOrConfigurationSet –Target $ForestFQDN -Server $SchemaDC -confirm:$false