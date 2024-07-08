import azure.functions as func
import azure.durable_functions as df

myApp = df.DFApp(http_auth_level=func.AuthLevel.ANONYMOUS)

#Client Function
@myApp.route(route="orchestrators/{functionName}")
@myApp.durable_client_input(client_name="client")
async def http_start(req: func.HttpRequest, client):
    function_name = req.route_params.get('functionName')
    instance_id = await client.start_new(function_name)
    response = client.create_check_status_response(req, instance_id)
    return response

# Orchestrator
@myApp.orchestration_trigger(context_name="context")
def hello_orchestrator(context):
    f1 = yield context.call_activity("f1", "Hello From F1")
    f2 = yield context.call_activity("f2", f1)
    result = yield context.call_activity("f3", f2)
    return result

# Chaining Activity Functions
@myApp.activity_trigger(input_name="msgf1")
def f1(msgf1: str):
    return f"{msgf1}"

@myApp.activity_trigger(input_name="msgf2")
def f2(msgf2: str):
    return f"F2 => {msgf2}"

@myApp.activity_trigger(input_name="msgf3")
def f3(msgf3: str):
    return f"F3 => {msgf3}"