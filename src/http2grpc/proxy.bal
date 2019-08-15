import ballerina/http;
import ballerina/log;

PizzaGRPCServiceBlockingClient ep = new("https://localhost:9092", {
            secureSocket: {
                trustStore: {
                    path: "/Library/Ballerina/ballerina-1.0.0-beta-SNAPSHOT/bre/security/ballerinaTruststore.p12",
                    password: "ballerina"
                }
            }
    });

@http:ServiceConfig {
    basePath: "/PizzaService"
}
service PizzaService on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/order",
        consumes: ["text/json", "application/json"],
        body: "pizzaOrder"
    }
    resource function orderPizza(http:Caller caller, http:Request request, OrderInfo pizzaOrder) {
        log:printDebug("order recieved to the gateway: " + pizzaOrder.toString());

        [string, grpc:Headers]|grpc:Error orderResult = ep -> orderPizza(pizzaOrder);

        http:Response resp = new ();
        if (orderResult is grpc:Error) {
            resp.statusCode = 500;
            resp.setJsonPayload({"message" : orderResult.toString()});
        } else {
            resp.setJsonPayload({"message" : orderResult[0]});
        }

        var result = caller -> respond(resp);
        if (result is error) {
            log:printError("error occured when replying from grpc gateway");
        }
    }
}
