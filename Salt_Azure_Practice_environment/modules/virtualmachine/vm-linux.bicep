@description('Username for the Virtual Machine.')
param vmAdminUsername string
param SSH_publicKey string = ''
@description('The size of the VM')
param VmSize string = 'Standard_DS12_v2'
@description('Location for all resources.')
param location string = 'northeurope'
param vnetName string = 'vnet-test-01'
param vnetResourceGroupName string = 'test-01'
param subnetName string = 'mySubnet'
param vmName string = take('myVm${uniqueString(resourceGroup().id)}', 15)
param networkInterfaceName string = 'nic-${vmName}'
param osDiskType string = 'StandardSSD_LRS'
param imagePublisher string = 'MicrosoftWindowsServer'
param imageOffer string = 'WindowsServer'
param ImageSku string = '2019-Datacenter'
param vmImageVersion string = 'latest'
param diskSizeGB int = 128

// private ip related parameters
param privateIPAddress string = ''

// public ip related parameters
param deploypublicIpAddress bool = false
var publicIpAddressName = 'pip-${vmName}'

// custom dns related parameters
param customDns bool = false
param customDnsServers array = [
]

//custom script extension related parameters
param vmExtension_CustomScript_deploy bool = false
param vmExtension_CustomScript_fileUris array = [
]
param vmExtension_CustomScript_commandToExecute string = ''

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  parent: vnet
  name: subnetName
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = if (deploypublicIpAddress) {
  name: publicIpAddressName
  location: location
  tags: {
    displayName: publicIpAddressName
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: vmName
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaceName
  location: location
  tags: {
    displayName: networkInterfaceName
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: deploypublicIpAddress ? {
            id: publicIpAddress.id
          } : null
          subnet: {
            id: subnet.id
          }
          privateIPAddress: privateIPAddress != '' ? privateIPAddress : null
        }
      }
    ]
    dnsSettings: customDns ? {
      dnsServers: customDnsServers
    } : null
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: location
  tags: {
    displayName: vmName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: VmSize
    }
    osProfile: {
      adminUsername: vmAdminUsername
      computerName: vmName
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${vmAdminUsername}/.ssh/authorized_keys'
              keyData: SSH_publicKey
            }
          ]
        }
      }
    }    
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: ImageSku
        version: vmImageVersion
      }
      osDisk: {
        name: '${vmName}OsDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        diskSizeGB: diskSizeGB
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

resource vmExtension_CustomScript 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = if (vmExtension_CustomScript_deploy) {
  parent: vm
  name: 'CustomScript-${vm.name}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: vmExtension_CustomScript_fileUris      
      commandToExecute: vmExtension_CustomScript_commandToExecute
    }
  }
}
