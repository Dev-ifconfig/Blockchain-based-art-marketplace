module BlockchainBasedArtMarketplaceSystem::Marketplace {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing an artwork for sale.
    struct Artwork has store, key {
        price: u64,       // Price of the artwork in tokens
        is_sold: bool,    // Whether the artwork has been sold
    }

    /// Function to list an artwork for sale with a specified price.
    public fun list_artwork(seller: &signer, price: u64) {
        let artwork = Artwork {
            price,
            is_sold: false,
        };
        move_to(seller, artwork);
    }

    /// Function for a buyer to purchase an artwork from a seller.
    public fun purchase_artwork(buyer: &signer, seller: address) acquires Artwork {
        let artwork = borrow_global_mut<Artwork>(seller);

        // Ensure the artwork is available for sale
        assert!(!artwork.is_sold, 1);

        // Transfer the price from the buyer to the seller
        let payment = coin::withdraw<AptosCoin>(buyer, artwork.price);
        coin::deposit<AptosCoin>(seller, payment);

        // Mark the artwork as sold
        artwork.is_sold = true;
    }
}
