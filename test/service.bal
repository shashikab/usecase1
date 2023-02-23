import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// The `Album` record to load records from `albums` table.
type Item record {|
    string item_id;
    string item_description;
    string item_name;
|};

configurable string USER = "choreo";
configurable string PASSWORD = "wso2!234";
configurable string HOST = "sahackathon.mysql.database.azure.com";
configurable int PORT = 3306;
configurable string DATABASE = "shashika_db";

service / on new http:Listener(8080) {
    private final mysql:Client db;

    function init() returns error? {
        // Initiate the mysql client at the start of the service. This will be used
        // throughout the lifetime of the service.
        self.db = check new (HOST, USER, PASSWORD, DATABASE, PORT,connectionPool = {maxOpenConnections: 3});
    }

    resource function get items() returns Item[]|sql:Error? {
        // Execute simple query to retrieve all records from the `albums` table.
        stream<Item, sql:Error?> itemStream = self.db->query(`SELECT * FROM items`);

        // Process the stream and convert results to Album[] or return error.
        return from Item item in itemStream
            select item;
    }
}
