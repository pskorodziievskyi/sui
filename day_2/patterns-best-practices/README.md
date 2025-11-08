# 🧭 Patterns & Best Practices (60 min)

Focus:
- Capability pattern
- Events
- Basic access control

---

## ➕ Add-ons in this pack (advanced)

- **Fully-wired tests** (`tests/*.move`): positive/negative for capability, access control, .

Run all tests:
```bash
sui move test
```

## Build & Publish
```bash
sui move build
sui client publish --gas-budget 300000000
export PACKAGE_ID=<PACKAGE_ID>
```

## Capability pattern
```bash
sui client call \
  --package $PACKAGE_ID \
  --module capability \
  --function init \
  --gas-budget 200000000

# Mint via capability (CLI auto-borrows &AdminCap you own)
sui client call \
  --package $PACKAGE_ID \
  --module capability \
  --function mint_badge \
  --args $ADMINCAP_ID "VIP" 1 $(sui client active-address) \
  --gas-budget 200000000
```

## Events
```bash
sui client call \
  --package $PACKAGE_ID \
  --module events \
  --function mint \
  --args "Member" \
  --gas-budget 200000000

sui client objects --owner $(sui client active-address) | grep Badge
export BADGE_ID=<...>

sui client call \
  --package $PACKAGE_ID \
  --module events \
  --function rename \
  --args $BADGE_ID "Gold Member" \
  --gas-budget 200000000
```

## Access control
```bash
sui client call \
  --package $PACKAGE_ID \
  --module access_control \
  --function create \
  --args "hello" \
  --gas-budget 200000000

# sui client objects $(sui client active-address) --json | grep Notebook
sui client objects (and serach objet id for notebook)
export NOTE_ID=<...>

sui client call \
  --package $PACKAGE_ID \
  --module access_control \
  --function append_line \
  --args $NOTE_ID "world" \
  --gas-budget 200000000
```

to check output:

sui client object $NOTE_ID --json 
base) pavloskorodziievskyi@Pavlos-MacBook-Pro patterns-best-practices % sui client object $NOTE_ID --json
{
  "objectId": "0x719f90cd9d395d8e1980d56d586554e3c803b2800a61c13c15401d7120debcae",
  "version": "349180913",
  "digest": "DbXgwVaqE37DEMTFASn97zyWSimZt2TPf4yYrMsdL5Ti",
  "type": "0x68a18462da4950e8e9efecd10d21eafce1a1fd9694aadefb05f6071990a0d14c::access_control::Notebook",
  "owner": {
    "AddressOwner": "0xca9d0fc0ebd1a374d47f137b402fc5a9f57ac3f6a32668dccd7423af31650a98"
  },
  "previousTransaction": "3HSMbYzwnG5kGRvrRUQsybZE4xEppQJBkAijCkUaJZfY",
  "storageRebate": "1694800",
  "content": {
    "dataType": "moveObject",
    "type": "0x68a18462da4950e8e9efecd10d21eafce1a1fd9694aadefb05f6071990a0d14c::access_control::Notebook",
    "hasPublicTransfer": false,
    "fields": {
      "body": "hello\nworld",
      "id": {
        "id": "0x719f90cd9d395d8e1980d56d586554e3c803b2800a61c13c15401d7120debcae"
      },
      "owner": "0xca9d0fc0ebd1a374d47f137b402fc5a9f57ac3f6a32668dccd7423af31650a98"
    }
  }
}
