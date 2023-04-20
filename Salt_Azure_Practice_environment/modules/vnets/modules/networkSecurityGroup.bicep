param location string
param nsgSecurityRulesArray array
param nsgName string
param tags object

resource nsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' =  {
  name: nsgName
  location: location
  properties: {
    securityRules: nsgSecurityRulesArray
  }
  tags: tags
}

// output nsgId string = nsg.properties.resourceGuid
