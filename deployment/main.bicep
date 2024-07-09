@description('location where resources will be created')
param location string = 'westus2'

@description('Azure App Service Environment subnet name')
param aseSubnetName string = 'asev3-subnet-01'

@description('Azure App Service Environment subnet name for delegation')
param aseSubnetNameDelegation string = 'asev3-subnet-01-delegation'

@description('Azure App Service Environment name')
param aseName string = 'asev3-env-01'

// @description('Azure App Service Plan name')
// param appServicePlanName string = 'isolated-asp-asev3'

// @description('Azure Function App name')
// param functionAppName string = 'function-app-asev3'

resource asev3Vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'asev3-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: aseSubnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: [
            {
              name: aseSubnetNameDelegation
              properties: {
                serviceName: 'Microsoft.Web/hostingEnvironments'
              }
            }
          ]
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource asev3demoenv 'Microsoft.Web/hostingEnvironments@2023-01-01' = {
  name: aseName
  location: location
  kind: 'ASEV3'
  properties: {
    dedicatedHostCount: 0
    frontEndScaleFactor: 15
    ipsslAddressCount: 0
    multiSize: 'Standard_D2d_v4'
    networkingConfiguration: {
      properties: {
        allowNewPrivateEndpointConnections: false
        ftpEnabled: false
        remoteDebugEnabled: false
      }
    }
    virtualNetwork: {
      id: asev3Vnet.properties.subnets[0].id      
      subnet: aseSubnetName
    }
    zoneRedundant: false
  }
}

// resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
//   name: appServicePlanName
//   location: location
//   properties: {
//     hostingEnvironmentProfile: {
//       id: asev3demoenv.id
//     }
//     perSiteScaling: false
//     maximumElasticWorkerCount: 1
//     isSpot: false
//     reserved: true
//     isXenon: false
//     hyperV: false
//     targetWorkerCount: 0
//     targetWorkerSizeId: 0
//   }
//   sku: {
//     name: 'I1v2'
//     tier: 'IsolatedV2'
//     size: 'I1v2'
//     family: 'Iv2'
//     capacity: 1
//   }
//   kind: 'linux'
// }

// resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
//   name: functionAppName
//   location: location
//   kind: 'functionapp, linux'
//   properties: {
//     enabled: true
//     serverFarmId: appServicePlan.id
//     reserved: true
//     isXenon: false
//     hyperV: false
//     siteConfig: {
//       numberOfWorkers: 1
//       linuxFxVersion: 'Python|3.10'
//       acrUseManagedIdentityCreds: false
//       alwaysOn: true
//       http20Enabled: true
//     }
//     hostingEnvironmentProfile: {
//       id: asev3demoenv.id
//     }
//   }
// }
