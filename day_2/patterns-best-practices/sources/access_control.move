module patterns_best_practices::access_control {
    use std::string::{Self, String};

    const ERR_NOT_OWNER: u64 = 1;

    public struct Notebook has key { id: UID, owner: address, body: String }

    public fun create(body: String, ctx: &mut TxContext) {
        // Get sender
        let sender = tx_context::sender(ctx);
        // Create a Notebook object
        let notebook = Notebook { 
            id: object::new(ctx), 
            owner: sender, 
            body 
        };
        // Transfer the Notebook object to the sender
        transfer::transfer(notebook, sender);
    }

    public fun append_line(n: &mut Notebook, line: String, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == n.owner, ERR_NOT_OWNER);
        string::append(&mut n.body, string::utf8(b"\n"));
        // Add the line to the end of the body
        string::append(&mut n.body, line);
    }

    public fun get_body(n: &Notebook): String { n.body } // Why do we pass via & ?

    public fun transfer_note(n: Notebook, new_owner: address, ctx: &mut TxContext) {
        // Add sender check for security
        assert!(tx_context::sender(ctx) == n.owner, ERR_NOT_OWNER);
        
        // Modify the owner and transfer
        let mut new_n = n;
        new_n.owner = new_owner;
        
        // Transfer the Notebook object to the new_owner
        transfer::transfer(new_n, new_owner);
    }

    /// TEST helper: create without transfer, return Notebook
    #[test_only]
    public fun create_for_test(body: String, ctx: &mut TxContext): Notebook {
        Notebook { id: object::new(ctx), owner: tx_context::sender(ctx), body }
    }

    /// Why do we need it?
    #[test_only]
    public fun destruct_for_test(note: Notebook) {
        let Notebook { id, owner: _, body: _ } = note; // Destructure and ignore unused fields
        id.delete();
    }
}
