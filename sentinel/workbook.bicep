// sentinel/workbook.bicep
@description('Name of the workbook (e.g., soc-detection-summary)')
param workbookDisplayName string

@description('Serialized workbook content (JSON string)')
param workbookDefinitionFile string

@description('Log Analytics workspace resource ID')
param sourceId string

resource workbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: guid(resourceGroup().id, workbookDisplayName)
  location: resourceGroup().location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    category: 'security'
    sourceId: sourceId
    serializedData: workbookDefinitionFile
    version: '1.0'
    tags: {
      project: 'iac-foundation'
    }
  }
}
