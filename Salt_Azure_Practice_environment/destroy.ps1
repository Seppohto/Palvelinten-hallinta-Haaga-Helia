$rg1='rg-salt-test-weu-01'
$rg2='rg-salt-test-sce-01'
az group delete --name $rg1 --no-wait --yes
az group delete --name $rg2 -yes