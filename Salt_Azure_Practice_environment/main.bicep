targetScope = 'subscription'

param rg array
param winservers array
param linuxservers array
@secure()
param adminpassword string
param SSH_publicKey string = ''
param vnets array

module resourceGroupSalt 'modules/resourcegroup/rg.bicep' = [ for (rg, index) in rg: {
  name: '${rg.name}-${index}'
  params: {
    name: rg.name
    location: rg.location
    tags: rg.tags
  }
}]

module vnet 'modules/vnets/vnet.bicep' = [ for (vnet, index) in vnets: {
  name: '${vnet.vnetName}-${index}'
  scope: resourceGroup(vnet.resourceGroupName)
  params: {
    vnetName: vnet.vnetName
    location: vnet.location
    subnetObjectsArray: vnet.subnetObjectsArray
    vnetIpAdressRanges: vnet.vnetIpAdressRanges
  }
  dependsOn: [
    resourceGroupSalt
  ]
}]

module vmServerWindows 'modules/virtualmachine/vm-windows.bicep' = [ for (server, index) in winservers: {
  name: 'vm-windows-${server.vmName}-${index}'
  scope: resourceGroup(server.resourceGroupName)
  params: {
    deploypublicIpAddress : server.deploypublicIpAddress
    vmAdminUsername : server.vmAdminUsername 
    vmAdminPassword : adminpassword
    VmSize : server.VmSize  
    location : server.location 
    vnetResourceGroupName : server.vnetResourceGroupName
    vnetName : server.vnetName
    subnetName : server.subnetName  
    vmName : server.vmName
    osDiskType : server.osDiskType  
    imagePublisher : server.imagePublisher  
    imageOffer : server.imageOffer  
    ImageSku : server.ImageSku  
    vmImageVersion : server.vmImageVersion  
    diskSizeGB : server.diskSizeGB
    vmExtension_CustomScriptExtension_deploy : server.vmExtension_CustomScriptExtension_deploy
    vmExtension_CustomScriptExtension_fileUris : server.vmExtension_CustomScriptExtension_fileUris
    vmExtension_CustomScriptExtension_commandToExecute : server.vmExtension_CustomScriptExtension_commandToExecute
  }
  dependsOn: [
    resourceGroupSalt
    vnet
  ]
}]

module vmServerlinux 'modules/virtualmachine/vm-linux.bicep' = [ for (server, index) in linuxservers: {
  name: 'vm-linux-${server.vmName}-${index}'
  scope: resourceGroup(server.resourceGroupName)
  params: {
    deploypublicIpAddress : server.deploypublicIpAddress
    privateIPAddress : server.privateIPAddress
    vmAdminUsername : server.vmAdminUsername 
    SSH_publicKey: SSH_publicKey
    VmSize : server.VmSize  
    location : server.location 
    vnetResourceGroupName : server.vnetResourceGroupName
    vnetName : server.vnetName
    subnetName : server.subnetName  
    vmName : server.vmName
    osDiskType : server.osDiskType  
    imagePublisher : server.imagePublisher  
    imageOffer : server.imageOffer  
    ImageSku : server.ImageSku  
    vmImageVersion : server.vmImageVersion  
    diskSizeGB : server.diskSizeGB
    vmExtension_CustomScript_deploy : server.vmExtension_CustomScript_deploy
    vmExtension_CustomScript_fileUris : server.vmExtension_CustomScript_fileUris
    vmExtension_CustomScript_commandToExecute : server.vmExtension_CustomScript_commandToExecute
  }
  dependsOn: [
    resourceGroupSalt
    vnet
  ]
}]
