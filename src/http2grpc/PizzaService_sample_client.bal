import ballerina/grpc;
import ballerina/io;

public function main (string... args) {
    PizzaServiceClient ep = new("http://localhost:9090");
    // PizzaServiceBlockingClient blockingEp = new("http://localhost:9090");

    pizzaOrder order = 
    ep -> orderPizza();

}

service PizzaServiceMessageListener = service {

    resource function onMessage(string message) {
        io:println("Response received from server: " + message);
    }

    resource function onError(error err) {
        io:println("Error from Connector: " + err.reason() + " - " + <string> err.detail()["message"]);
    }

    resource function onComplete() {
        io:println("Server Complete Sending Responses.");
    }
};

