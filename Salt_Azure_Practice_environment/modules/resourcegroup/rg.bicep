targetScope = 'subscription'

param name string
param location string
param tags object

resource ResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
  }
}
