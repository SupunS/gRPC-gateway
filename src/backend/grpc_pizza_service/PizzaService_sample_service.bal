import ballerina/grpc;

listener grpc:Listener ep = new (9000);

service PizzaService on ep {

    resource function orderPizza(grpc:Caller caller, orderInfo value) {
        // Implementation goes here.
        io:println("pizza ordered from gRPC");
        error? result = caller -> send("pizza ordered");

        if (result is error) {
            io:println("error occured when replying from grpc pizza service");
        }
        // You should return a string
    }
}

