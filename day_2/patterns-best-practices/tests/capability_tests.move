module patterns_best_practices::capability_tests {
    use sui::test_scenario;
    use std::string;
    use patterns_best_practices::capability::{Self, AdminCap, Badge};

    const ADMIN: address = @0x1;
    const RECIPIENT: address = @0x3;

    #[test]
    public fun can_mint_with_cap() {
        // Create a test scenario (sc)
        let mut sc = test_scenario::begin(ADMIN);
        
        // Next transaction from ADMIN
        test_scenario::next_tx(&mut sc, ADMIN);
        {
            // Create AdminCap
            let admin_cap = capability::new_admin_for_test(test_scenario::ctx(&mut sc));
            
            // Mint a badge
            capability::mint_badge(
                &admin_cap, 
                string::utf8(b"VIP"), 
                1, 
                RECIPIENT, 
                test_scenario::ctx(&mut sc)
            );
            
            // Destruct AdminCap object
            capability::destruct_for_test(admin_cap);
        };

        // Verify the badge was minted to the recipient
        test_scenario::next_tx(&mut sc, RECIPIENT);
        {
            assert!(test_scenario::has_most_recent_for_address<Badge>(RECIPIENT), 0);
        };

        // End test_scenario
        test_scenario::end(sc);
    }

    #[test]
    #[expected_failure]
    public fun cannot_mint_without_cap() {
        let mut sc = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut sc, RECIPIENT);
        {
            // This should fail because RECIPIENT doesn't have an AdminCap
            // We try to take an AdminCap that doesn't exist
            let _admin_cap = test_scenario::take_from_sender<AdminCap>(&sc);
            // This line should never be reached due to the take failure above
            abort 0
        };

        test_scenario::end(sc);
    }
}
