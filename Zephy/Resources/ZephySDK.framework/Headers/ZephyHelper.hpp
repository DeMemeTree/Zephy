//
//  ZephyHelper.hpp
//  ZephySDK
//
//

#ifndef ZephyHelper_hpp
#define ZephyHelper_hpp

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>


#ifdef __cplusplus
extern "C" {
#endif

    bool create_wallet(char *path, char *password, char *language, char *error);
    bool restore_wallet_from_seed(char *path, char *password, char *seed, uint64_t restoreHeight, char *error);
    bool load_wallet(char *path, char *password, int32_t nettype);
    bool is_wallet_exist(char *path);

    char *get_filename();
    const char *seed();

    size_t subaddrress_size();
    char *get_subaddress_label(uint32_t accountIndex, uint32_t addressIndex);
    char *get_subaddress_account(uint32_t accountIndex, uint32_t addressIndex);
    void subaddress_add_row(uint32_t accountIndex, char *label);

    uint64_t get_full_balance(char *assetTyp, uint32_t account_index);
    uint64_t get_unlocked_balance(char *assetTyp, uint32_t account_indexe);
    uint64_t get_current_height();
    uint64_t get_node_height();

    bool transaction_create(char *source_asset,
                            char *dest_asset,
                            char *address,
                            char *amount,
                            char *error);

    bool is_connected();
    bool synchronized();

    bool setup_node(char *address, char *login, char *password, bool use_ssl, bool is_light_wallet, char *error);
    bool connect_to_node(char *error);
    void rescan_blockchain();
    void start_refresh();
    void set_refresh_from_block_height(uint64_t height);
    void set_recovering_from_seed(bool is_recovery);
    void store(char *path);

    void set_trusted_daemon(bool arg);
    bool trusted_daemon();
#ifdef __cplusplus
}
#endif

#endif
