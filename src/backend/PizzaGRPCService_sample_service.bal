import ballerina/grpc;
import ballerina/log;

listener grpc:Listener ep = new (9092, {
    secureSocket: {
        keyStore: {
            path: "/Library/Ballerina/ballerina-1.0.0-beta-SNAPSHOT/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        }
    }
});

service PizzaGRPCService on ep {

    resource function orderPizza(grpc:Caller caller, OrderInfo value) {
        log:printInfo("pizza order placed: " + value.id);
        error? result = caller -> send("order placed: " + value.id);

        if (result is error) {
            log:printError("error occured when replying from grpc pizza service");
        }
    }
}

