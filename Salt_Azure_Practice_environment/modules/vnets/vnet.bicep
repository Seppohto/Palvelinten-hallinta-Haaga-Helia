param location string
param vnetName string
param vnetIpAdressRanges array
param subnetObjectsArray array 


resource Vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  tags: {
    displayName: vnetName
    resourceGroup: resourceGroup().name
  }
  properties: {
    addressSpace: {
      addressPrefixes: vnetIpAdressRanges
    }
    // dhcpOptions: {
    //   dnsServers: [
    //     '10.228.23.4'
    //   ]
    // }
    // TODO Change to use array of subnet objects instead of separate name + cidr list parameters.
    subnets: [for subnet in subnetObjectsArray: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.properties.addressPrefix
        networkSecurityGroup: subnet.properties.networkSecurityGroup.deploy ? {
          id: resourceId('Microsoft.Network/networkSecurityGroups', 'nsg-${vnetName}-${subnet.name}')
        } : null
        routeTable: subnet.properties.routeTable.deploy ? {
          id: resourceId('Microsoft.Network/routeTables', 'route-${vnetName}-${subnet.name}')
        } : null
      }
    }]
  }  
  dependsOn: [
    nsgModule
    routeTablesModule
    ]
}

module nsgModule 'modules/networkSecurityGroup.bicep' = [for (subnet, i) in subnetObjectsArray: if (subnet.properties.networkSecurityGroup.deploy) {
  scope: resourceGroup()
  name: 'nsgModule${i}'
  params: {    
    location: subnet.properties.networkSecurityGroup.location
    nsgSecurityRulesArray: subnet.properties.networkSecurityGroup.nsgSecurityRulesArray
    nsgName: 'nsg-${vnetName}-${subnet.name}'
    tags: subnet.properties.networkSecurityGroup.tags
  }
}]

module routeTablesModule 'modules/routeTables.bicep' = [for (subnet, i) in subnetObjectsArray: if (subnet.properties.routeTable.deploy) {
  scope: resourceGroup()
  name: 'routeTableModule${i}'
  params: {    
    location: subnet.properties.routeTable.location
    routes: subnet.properties.routeTable.properties.routes
    routeTableName: 'route-${vnetName}-${subnet.name}'
    tags: subnet.properties.routeTable.tags
  }
}]

output vnetResourceId string = Vnet.id
