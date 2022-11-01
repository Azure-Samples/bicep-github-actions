param nsgLocation string
param nsgName string

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgName
  location: nsgLocation
  properties: {
    securityRules: [
      {
        name: 'badrule'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 100
          // we can't match on * due to a bug with checkov: https://github.com/bridgecrewio/checkov/issues/3749
          protocol: 'TCP' 
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
}
