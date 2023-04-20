param location string
param routes array
param routeTableName string
param tags object


resource routeTables 'Microsoft.Network/routeTables@2019-09-01' =  {
  name: routeTableName
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: routes
  }
  tags: tags
}
