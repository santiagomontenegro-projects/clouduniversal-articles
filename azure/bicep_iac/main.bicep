param location string = 'francecentral'

param virtualMachines_clouduniversal_machine_name string = 'clouduniversal-machine'
param networkInterfaces_clouduniversal_machine251_name string = 'clouduniversal-machine251'
param publicIPAddresses_clouduniversal_machine_ip_name string = 'clouduniversal-machine-ip'
param virtualNetworks_clouduniversal_machine_vnet_name string = 'clouduniversal-machine-vnet'
param networkSecurityGroups_clouduniversal_machine_nsg_name string = 'clouduniversal-machine-nsg'

param adminUsername string = 'azureuser'
@secure()
param adminPassword string

resource networkSecurityGroups_clouduniversal_machine_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_clouduniversal_machine_nsg_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource publicIPAddresses_clouduniversal_machine_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPAddresses_clouduniversal_machine_ip_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource virtualNetworks_clouduniversal_machine_vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_clouduniversal_machine_vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource networkInterfaces_clouduniversal_machine251_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_clouduniversal_machine251_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_clouduniversal_machine_ip_name_resource.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_clouduniversal_machine_vnet_name, 'default')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: networkSecurityGroups_clouduniversal_machine_nsg_name_resource.id
    }
  }
}

resource virtualMachines_clouduniversal_machine_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_clouduniversal_machine_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_clouduniversal_machine_name}-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
    }
    osProfile: {
      computerName: virtualMachines_clouduniversal_machine_name
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_clouduniversal_machine251_name_resource.id
          properties: {
            deleteOption: 'Detach'
            primary: true
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}