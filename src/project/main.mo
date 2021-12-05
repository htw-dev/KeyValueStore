/*
Build a simple KeyValue store canister in Motoko. Expose PUT, GET, DELETE. 
https://smartcontracts.org/docs/language-guide/motoko.html
Bonus points for 
1. Using Result types https://smartcontracts.org/docs/base-libraries/Result.html
2. Partitioning by principal-id - https://smartcontracts.org/docs/language-guide/caller-id.html
3. Pagination. Hint create a separate idx use Text Compare : https://smartcontracts.org/docs/base-libraries/Text.html#compare & an ordered data struct

Some code samples which might be helpful
https://github.com/DepartureLabsIC/non-fungible-token
https://github.com/orgs/aviate-labs/repositories
https://github.com/crusso?tab=repositories
*/

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";

shared (msg) actor class Store() {
    let owner = msg.caller;
/*
	Simple actor declarations do not let you access their installer. 
    If you need access to the installer of an actor, 
    rewrite the actor declaration as a zero-argument actor class instead. 
*/
    stable var contractOwners : [Principal] = [owner];
    type Result<T, E> = Result.Result<T, E>;
    let store = HashMap.HashMap<Text, Text>(
        0, 
        Text.equal,
        Text.hash,
    );

    public shared({caller}) func put(key : Text, value : Text) : async Result<Text, Text> {
        assert(owner == msg.caller);
        store.put(key, value);
        switch(store.get(key)) {
            case(null) {
                #err("PUT for key '" # key # "' and value '" # value # "' failed.");
            };
            case(? v){
                #ok("Successfully stored '" # value # "' for '" # key # "'");
            };
        };   
    };

    public func get(key : Text) : async Result<Text, Text> {
        switch(store.get(key)) {
            case(null) {#err("There is no value stored for '" # key # "'.");};
            case(? v){
                #ok(v);
            };
        };
    };

    public func getAll() : async Result<Text, Text> {
        // code this to iterate through the hashmap and output ALL [K, V] pairs
    }

    public shared({caller}) func delete(key : Text) : async Result<Text, Text> {
        // Chose remove over delete for the confirmation of correct value deletion
        assert(owner == msg.caller);
        switch(store.remove(key)) {
            case(null) {
                #err("Failed to delete '" # key # "' and paired value.");
            };
            case(? v){
                #ok("'" # key # "' has been deleted successfully!");
            };
        };
    };

    public shared({caller}) func getOwners() : async () {
        for(i in Iter.range(0, contractOwners.size()-1)){ Debug.print(Principal.toText(contractOwners[i])); };
    };
/*
    public shared({caller}) func addOwner(newOwner : Text) : async () {
        //Debug.print(newOwner);
        assert(owner == msg.caller);
        let temp : Principal = Principal.fromText(newOwner);
        contractOwners := Array.append(contractOwners, Array.make<Principal>(temp));
    }
*/

};