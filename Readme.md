### Azure Durable Functions with Python

- Create a durable function and test locally  
`func start`

- Deploy both to Azure on a standard ASP, Y1  
`az functionapp create --resource-group <Resource Group Name> --consumption-plan-location <Location> --runtime python --runtime-version <PYTHON Runtime version> --functions-version 4 --name <Unique app name> --os-type linux --storage-account <Storage Account Name>`

- Publish to Function app
`func azure functionapp publish <Function App Name>`

- Deploy the same to ASEv3, Isolated environment
1. Create Vnet and Subnet

2. Create App Service Environment