@description('Set the local VNet name')
param vnetOne string

@description('Set the local VNet id')
param vnetOneId string

@description('Set the remote VNet name')
param vnetTwo string

@description('Sets the remote VNet Resource group')
param vnetTwoVirtualNetworkResourceGroupName string

resource existingLocalVirtualNetworkName_peering_to_remote_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${vnetOne}/peering-to-remote-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(vnetTwoVirtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks', vnetTwo)
    }
  }
}
resource existingremoteVirtualNetworkName_peering_to_local_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${vnetTwo}/peering-to-remote-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetOneId
    }
  }
}
