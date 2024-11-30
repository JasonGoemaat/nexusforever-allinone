# Useful Scripts

### Unlock entitlements

```sql
-- replace the first '1' with your account id, 1 should be the first account created on the server
-- these seem harmless
INSERT INTO account_entitlement VALUES (1, 3, 8); -- Costume Slot Unlock
INSERT INTO account_entitlement VALUES (1, 9, 1); -- 2-Step Verification Dividends
INSERT INTO account_entitlement VALUES (1, 12, 12); -- Character Slot Unlock
INSERT INTO account_entitlement VALUES (1, 22, 1); -- Signature Player: Benefits (Better xp gain, currency earnings, rest xp gain, more...)
INSERT INTO account_entitlement VALUES (1, 27, 8); -- Extra Bank Slot
INSERT INTO account_entitlement VALUES (1, 34, 10); -- Cosmic Reward: Coordinate Crafting Bonus
INSERT INTO account_entitlement VALUES (1, 35, 1); -- Cosmic Reward: OmniBit Drop Rate
INSERT INTO account_entitlement VALUES (1, 37, 10); -- Cosmic Reward: Increased Reputation Gain
INSERT INTO account_entitlement VALUES (1, 38, 1); -- Cosmic Reward: Full Social Access
INSERT INTO account_entitlement VALUES (1, 39, 10); -- Cosmic Reward: Circuit Board Crafting Bonus
INSERT INTO account_entitlement VALUES (1, 41, 1); -- Cosmic Reward: Wake Here Cooldown Reduction
INSERT INTO account_entitlement VALUES (1, 42, 10); -- Cosmic Reward: Extra Commodity Exchange Orders
INSERT INTO account_entitlement VALUES (1, 43, 10); -- Cosmic Reward: Extra Auctions and Bids
INSERT INTO account_entitlement VALUES (1, 44, 1); -- Increased Challenge Points (25%)
INSERT INTO account_entitlement VALUES (1, 45, 1); -- Cosmic Reward: Rest XP Bonus
INSERT INTO account_entitlement VALUES (1, 46, 1); -- Cosmic Reward: Harvesting Boost
INSERT INTO account_entitlement VALUES (1, 48, 3); -- VIP Tier 3
INSERT INTO account_entitlement VALUES (1, 61, 1); -- Unlock Chua Warrior
INSERT INTO account_entitlement VALUES (1, 62, 1); -- Unlock Aurin Engineer
INSERT INTO account_entitlement VALUES (1, 71, 1000); -- Max tradeskill supply satchel stack limit
INSERT INTO account_entitlement VALUES (1, 74, 1); -- Shared Realm Bank Unlock
INSERT INTO account_entitlement VALUES (1, 75, 23); -- Max Realm Bank Slots

-- these seem ok in the table, but are iffy, especially the 2000 quantity for the last two
INSERT INTO account_entitlement VALUES (1, 4, 1); -- Access Warplots
INSERT INTO account_entitlement VALUES (1, 23, 3); -- Auction House Slot Unlock (hmmm...  Text says 3 times for 50 each, but MaxCount is 150)
INSERT INTO account_entitlement VALUES (1, 25, 3); -- Commodities Slot Unlock (hmmm...  Text says 3 times for 50 each, but MaxCount is 150)
INSERT INTO account_entitlement VALUES (1, 26, 2000); -- Extra Decor Slots
INSERT INTO account_entitlement VALUES (1, 36, 2000); -- Costume Display Unlock
```