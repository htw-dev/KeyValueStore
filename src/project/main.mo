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
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";

shared (msg) actor class Store() {
    let owner = msg.caller;

    //Simple actor declarations do not let you access their installer. 
    //If you need access to the installer of an actor, 
    //rewrite the actor declaration as a zero-argument actor class instead. 

    let store = HashMap.HashMap<Text, Text>(
        0, 
        Text.equal,
        Text.hash,
    );

    // Put the specified Key & Value into our HashMap as a new {K, V} pair
    // Overwrites an existing value if the key already exists
    public shared({caller}) func put(key : Text, value : Text) : async Result.Result<Text, Text> {
        assert(owner == msg.caller);
        store.put(key, value);
        switch(store.get(key)) {
            case(null) {
                #err("PUT for key '" # key # "' and value '" # value # "' failed.");
            };
            case(?v){
                #ok("Successfully stored '" # v # "' for '" # key # "'");
            };
        };   
    };

    // Get the associated value for a specified key, if it exists in the HashMap
    public query func get(key : Text) : async Result.Result<Text, Text> {
        switch(store.get(key)) {
            case(null) {#err("There is no value stored for '" # key # "'.");};
            case(?v){
                #ok(v);
            };
        };
    };

    // Retrieve a number of key-value pairs by number per page, listed by page number.
    // First argument is how many results per page, second is which page you would like to view.
    public func getAll(itemsPer : Nat, pageNum : Nat) : async Text {
        var sortedKeys = storeKeysToSortedArray();
        var outputText : Text = "";
        for (i in Iter.range((itemsPer * (pageNum-1), (itemsPer*pageNum)-1))) {
            if(i > sortedKeys.size()-1) {
                return outputText;
            };
            Debug.print(sortedKeys[i]);
            switch(store.get(sortedKeys[i])) {
                case(null) { () };
                case(?v){
                    ( outputText #= sortedKeys[i] # ", " # v # "\n" );
                };
            };
        };
        return outputText;
    };

    // Function that iterates through all keys in our 'store' HashMap, 
    // placing them into an array and sorting them by Text comparison.
    // Returns a sorted [Text].
    func storeKeysToSortedArray() : [Text] {
        var pairs : [Text] = Iter.toArray(store.keys());
        var sortPairs = Array.sort<Text>(pairs, Text.compare);
        
        return sortPairs;
    };

    // Delete a specified key and the key's associated value from our HashMap, if it exists
    public shared({caller}) func delete(key : Text) : async Result.Result<Text, Text> {
        // Chose remove() over delete() for the confirmation of correct value deletion
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

};