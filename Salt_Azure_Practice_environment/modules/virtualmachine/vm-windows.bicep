@description('Username for the Virtual Machine.')
param vmAdminUsername string
@description('Password for the Virtual Machine. The password must be at least 12 characters long and have lower case, upper characters, digit and a special character (Regex match)')
@secure()
param vmAdminPassword string
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

// public ip related parameters
param deploypublicIpAddress bool = false
var publicIpAddressName = 'pip-${vmName}'

// vme extension related parameters
param vmExtension_AADLoginForWindows_deploy bool = false

param vmExtension_JsonADDomainExtension_deploy bool = false
param vmExtension_JsonADDomainExtension_settings_domainName string = ''
param vmExtension_JsonADDomainExtension_settings_OUPath string = ''
@secure()
param domainAdminUsername string = ''
@secure()
param domainAdminPassword string = ''
param vmExtension_CustomScriptExtension_deploy bool = false
param vmExtension_CustomScriptExtension_commandToExecute string = ''
param vmExtension_CustomScriptExtension_fileUris array = [
]

// custom dns related parameters
param customDns bool = false
param customDnsServers array = [
]

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
      computerName: vmName
      adminUsername: vmAdminUsername
      adminPassword: vmAdminPassword
      
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
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

resource vmExtension_AADLoginForWindows 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = if (vmExtension_AADLoginForWindows_deploy) {
  parent: vm
  name: 'AADLoginForWindows-${vm.name}}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADLoginForWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      mdmId: ''
    }
  }
}

resource vmExtension_JsonADDomainExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = if (vmExtension_JsonADDomainExtension_deploy) {
  parent: vm
  name: 'joindomain'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: vmExtension_JsonADDomainExtension_settings_domainName
      OUPath: vmExtension_JsonADDomainExtension_settings_OUPath
      User: '${vmExtension_JsonADDomainExtension_settings_domainName}\\${domainAdminUsername}'
      Restart: true
      Options: 3
    }
    protectedSettings: {
      Password: domainAdminPassword
    }
  }
}


resource vmExtension_CustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = if (vmExtension_CustomScriptExtension_deploy) {
  parent: vm
  name: 'CustomScriptExtension-${vm.name}'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: vmExtension_CustomScriptExtension_fileUris      
      commandToExecute: vmExtension_CustomScriptExtension_commandToExecute
    }
  }
}
