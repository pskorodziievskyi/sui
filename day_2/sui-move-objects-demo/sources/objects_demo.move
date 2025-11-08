module objects_demo::objects_demo {
    
    use std::string::{String};
    use sui::event;

    public struct Item has key {
        id: UID,
        name: String,
    }

    public struct Created has copy, drop { obj_id: object::ID, name: String }
    public struct Updated has copy, drop { obj_id: object::ID, new_name: String }
    public struct Transferred has copy, drop { obj_id: object::ID, to: address }

    public fun create_item(name: String, ctx: &mut TxContext) {
        // create Item object
        let item = Item { id: object::new(ctx), name };
        // emit Created event with the new object's id and name
        event::emit(Created { obj_id: object::id(&item), name: item.name });
        // transfer the Item object to the transaction sender
        transfer::transfer(item, tx_context::sender(ctx));
    }

    public fun rename_item(item: &mut Item, new_name: String) { // Why do we use &mut?
        item.name = new_name;
        // emit Updated event with object id and new name
        event::emit(Updated { obj_id: object::id(item), new_name });
    }

    public fun transfer_item(item: Item, recipient: address) {
        event::emit(Transferred { obj_id: object::id(&item), to: recipient });
        // transfer the Item object to the recipient
        transfer::transfer(item, recipient);
    }

    public fun get_item_name(item: &Item): String {
        item.name
    }
}
