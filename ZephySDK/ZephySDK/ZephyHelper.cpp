//
//  ZephyHelper.cpp
//  ZephySDK
//
//
#include "ZephyHelper.hpp"


#include <stdint.h>
#include "cstdlib"
#include <chrono>
#include <functional>
#include <iostream>
#include <fstream>
#include <unistd.h>
#include <mutex>
#include <list>
#include "thread"

// Fix for randomx on ios
void __clear_cache(void* start, void* end) { }
#include "wallet2_api.h"

using namespace std::chrono_literals;

#ifdef __cplusplus
extern "C" {
#endif

    const uint64_t MONERO_BLOCK_SIZE = 1000;

    struct Utf8Box
    {
        char *value;

        Utf8Box(char *_value)
        {
            value = _value;
        }
    };

    struct SubaddressRow
    {
        uint64_t id;
        char *address;
        char *label;

        SubaddressRow(std::size_t _id, char *_address, char *_label)
        {
            id = static_cast<uint64_t>(_id);
            address = _address;
            label = _label;
        }
    };

    struct AccountRow
    {
        uint64_t id;
        char *label;

        AccountRow(std::size_t _id, char *_label)
        {
            id = static_cast<uint64_t>(_id);
            label = _label;
        }
    };

    struct TransactionInfoRow
    {
        uint64_t amount;
        uint64_t fee;
        uint64_t blockHeight;
        uint64_t confirmations;
        uint32_t subaddrAccount;
        int8_t direction;
        int8_t isPending;
        int64_t datetime;

        char *hash;
        char *source_type;

        TransactionInfoRow(Monero::TransactionInfo *transaction)
        {
            amount = transaction->amount();
            fee = transaction->fee();
            blockHeight = transaction->blockHeight();
            subaddrAccount = transaction->subaddrAccount();
            confirmations = transaction->confirmations();
            datetime = static_cast<int64_t>(transaction->timestamp());
            direction = transaction->direction();
            isPending = static_cast<int8_t>(transaction->isPending());
            std::string *hash_str = new std::string(transaction->hash());
            std::string *source_type_str = new std::string(transaction->source_type());
            hash = strdup(hash_str->c_str());
            source_type = strdup(source_type_str->c_str());
        }
    };

    Monero::Wallet *m_wallet;
    Monero::TransactionHistory *m_transaction_history;
    Monero::Subaddress *m_subaddress;
    Monero::SubaddressAccount *m_account;

    Monero::PendingTransaction *m_currentPendingTx = nullptr;

    std::mutex store_lock;
    bool is_storing = false;
    bool m_wallet_init = false;

    void change_current_wallet(Monero::Wallet *wallet) {
        m_wallet = wallet;

        if (wallet != nullptr) {
            m_transaction_history = wallet->history();
        } else {
            m_transaction_history = nullptr;
        }

        if (wallet != nullptr) {
            m_account = wallet->subaddressAccount();
        } else {
            m_account = nullptr;
        }

        if (wallet != nullptr) {
            m_subaddress = wallet->subaddress();
        } else {
            m_subaddress = nullptr;
        }
    }

    Monero::Wallet *get_current_wallet() {
        return m_wallet;
    }

    bool create_wallet(char *path, char *password, char *language, char *error) {
        Monero::WalletManager *walletManager = Monero::WalletManagerFactory::getWalletManager();
        Monero::Wallet *wallet = walletManager->createWallet(path,
                                                             password,
                                                             language,
                                                             Monero::NetworkType::MAINNET);

        int status;
        std::string errorString;
        wallet->statusWithErrorString(status, errorString);

        if (wallet->status() != Monero::Wallet::Status_Ok) {
            std::cout << wallet->errorString() << std::endl;
            error = strdup(wallet->errorString().c_str());
            return false;
        }
        change_current_wallet(wallet);
        return true;
    }

    bool restore_wallet_from_seed(char *path,
                                  char *password,
                                  char *seed,
                                  uint64_t restoreHeight,
                                  char *error) {
        Monero::NetworkType _networkType = static_cast<Monero::NetworkType>(0);
        Monero::Wallet *wallet = Monero::WalletManagerFactory::getWalletManager()->recoveryWallet(
            std::string(path),
            std::string(password),
            std::string(seed),
            _networkType,
            (uint64_t)restoreHeight);

        int status;
        std::string errorString;

        wallet->statusWithErrorString(status, errorString);

        if (status != Monero::Wallet::Status_Ok || !errorString.empty())
        {
            error = strdup(errorString.c_str());
            return false;
        }

        change_current_wallet(wallet);
        return true;
    }

    void subaddress_refresh(uint32_t accountIndex) {
        m_subaddress->refresh(accountIndex);
    }

    bool load_wallet(char *path, char *password, int32_t nettype) {
        nice(19);
        Monero::NetworkType networkType = static_cast<Monero::NetworkType>(nettype);
        Monero::WalletManager *walletManager = Monero::WalletManagerFactory::getWalletManager();
        Monero::Wallet *wallet = walletManager->openWallet(std::string(path), std::string(password), networkType);
        int status;
        std::string errorString;

        wallet->statusWithErrorString(status, errorString);
        change_current_wallet(wallet);
        subaddress_refresh(0);
        
        return !(status != Monero::Wallet::Status_Ok || !errorString.empty());
    }

    char *error_string() {
        return strdup(get_current_wallet()->errorString().c_str());
    }


    bool is_wallet_exist(char *path)
    {
        return Monero::WalletManagerFactory::getWalletManager()->walletExists(std::string(path));
    }

    void close_current_wallet()
    {
        Monero::WalletManagerFactory::getWalletManager()->closeWallet(get_current_wallet());
        change_current_wallet(nullptr);
    }

    char *get_filename()
    {
        return strdup(get_current_wallet()->filename().c_str());
    }

    char *secret_view_key()
    {
        return strdup(get_current_wallet()->secretViewKey().c_str());
    }

    char *public_view_key()
    {
        return strdup(get_current_wallet()->publicViewKey().c_str());
    }

    char *secret_spend_key()
    {
        return strdup(get_current_wallet()->secretSpendKey().c_str());
    }

    char *public_spend_key()
    {
        return strdup(get_current_wallet()->publicSpendKey().c_str());
    }

    char *get_address(uint32_t account_index, uint32_t address_index)
    {
        return strdup(get_current_wallet()->address(account_index, address_index).c_str());
    }


    const char *seed()
    {
        return strdup(get_current_wallet()->seed().c_str());
    }

    uint64_t get_full_balance(char *assetType, uint32_t account_index)
    {
        return get_current_wallet()->balance(std::string(assetType), account_index);
    }

    uint64_t get_unlocked_balance(char *assetType, uint32_t account_index)
    {
        return get_current_wallet()->unlockedBalance(std::string(assetType), account_index);
    }

    uint64_t get_current_height()
    {
        return get_current_wallet()->blockChainHeight();
    }

    uint64_t get_node_height()
    {
        return get_current_wallet()->daemonBlockChainHeight();
    }

    bool connect_to_node(char *error)
    {
        nice(19);
        bool is_connected = get_current_wallet()->connectToDaemon();

        if (!is_connected)
        {
            error = strdup(get_current_wallet()->errorString().c_str());
        }
        
        m_wallet_init = is_connected;

        return is_connected;
    }

    bool setup_node(char *address, char *login, char *password, bool use_ssl, bool is_light_wallet, char *error)
    {
        nice(19);
        Monero::Wallet *wallet = get_current_wallet();

        std::string _login = "";
        std::string _password = "";
        std::string _socksProxyAddress = "";

        if (login != nullptr)
        {
            _login = std::string(login);
        }

        if (password != nullptr)
        {
            _password = std::string(password);
        }

        bool inited = wallet->init(std::string(address), 0, _login, _password, use_ssl, is_light_wallet, _socksProxyAddress);

        if (!inited)
        {
            error = strdup(wallet->errorString().c_str());
        } else if (!wallet->connectToDaemon()) {
            error = strdup(wallet->errorString().c_str());
        }

        return inited;
    }

    bool is_connected() {
        if(m_wallet_init) {
            return get_current_wallet()->connected();
        }
        return false;
    }

    bool synchronized() {
        return get_current_wallet()->synchronized();
    }

    void start_refresh()
    {
        get_current_wallet()->refreshAsync();
        get_current_wallet()->startRefresh();
    }

    void set_refresh_from_block_height(uint64_t height)
    {
        get_current_wallet()->setRefreshFromBlockHeight(height);
    }

    void set_recovering_from_seed(bool is_recovery)
    {
        get_current_wallet()->setRecoveringFromSeed(is_recovery);
    }

    void store(char *path)
    {
        store_lock.lock();
        if (is_storing) {
            store_lock.unlock();
            return;
        }

        is_storing = true;
        get_current_wallet()->store(std::string(path));
        is_storing = false;
        store_lock.unlock();
    }

//    bool set_password(char *password) {
//        bool is_changed = get_current_wallet()->setPassword(std::string(password));
//
//        if (!is_changed) {
//           // error = Utf8Box(strdup(get_current_wallet()->errorString().c_str()));
//        }
//
//        return is_changed;
//    }

    uint64_t transaction_create(char *source_asset,
                                char *dest_asset,
                                char *address,
                                char *amount,
                                char *error) {
        nice(19);

        std::string _payment_id;
        Monero::PendingTransaction *transaction;

        if (amount != nullptr) {
            uint64_t _amount = Monero::Wallet::amountFromString(std::string(amount));
            transaction = m_wallet->createTransaction(std::string(source_asset),
                                                      std::string(dest_asset),
                                                      std::string(address),
                                                      _payment_id,
                                                      _amount,
                                                      m_wallet->defaultMixin());
        } else {
            transaction = m_wallet->createTransaction(std::string(source_asset),
                                                      std::string(dest_asset),
                                                      std::string(address),
                                                      _payment_id,
                                                      Monero::optional<uint64_t>(),
                                                      m_wallet->defaultMixin());
        }

        int status = transaction->status();

        if (status == Monero::PendingTransaction::Status::Status_Error || status == Monero::PendingTransaction::Status::Status_Critical)
        {
            error = strdup(transaction->errorString().c_str());
            return 0;
        }
        
        m_currentPendingTx = transaction;

        return transaction->fee();
    }

    bool transaction_commit() {
        if(m_currentPendingTx == nullptr) {
            return false;
        }
        
        bool committed = m_currentPendingTx->commit();

        if (committed) {
            m_currentPendingTx = nullptr;
        }

        return committed;
    }

    size_t subaddrress_size() {
        std::vector<Monero::SubaddressRow *> _subaddresses = m_subaddress->getAll();
        return _subaddresses.size();
    }

    void subaddress_add_row(uint32_t accountIndex, char *label) {
        m_subaddress->addRow(accountIndex, std::string(label));
    }

    void subaddress_set_label(uint32_t accountIndex, uint32_t addressIndex, char *label)
    {
        m_subaddress->setLabel(accountIndex, addressIndex, std::string(label));
    }

    void account_set_label_row(uint32_t account_index, char *label)
    {
        m_account->setLabel(account_index, label);
    }

    void account_refresh()
    {
        m_account->refresh();
    }

    int64_t *transactions_get_all() {
        std::vector<Monero::TransactionInfo *> transactions = m_transaction_history->getAll();
        size_t size = transactions.size();
        int64_t *transactionAddresses = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Monero::TransactionInfo *row = transactions[i];
            TransactionInfoRow *tx = new TransactionInfoRow(row);
            transactionAddresses[i] = reinterpret_cast<int64_t>(tx);
        }

        return transactionAddresses;
    }

    void transactions_refresh() {
        m_transaction_history->refresh();
    }

    size_t transactions_count() {
        return m_transaction_history->count();
    }

//    TransactionInfoRow* get_transaction(char * txId)
//    {
//        Monero::TransactionInfo *row = m_transaction_history->transaction(std::string(txId));
//        return new TransactionInfoRow(row);
//    }

    void rescan_blockchain() {
        m_wallet->rescanBlockchainAsync();
    }

    char * get_tx_key(char * txId)
    {
        return strdup(m_wallet->getTxKey(std::string(txId)).c_str());
    }

    char *get_subaddress_label(uint32_t accountIndex, uint32_t addressIndex) {
        return strdup(get_current_wallet()->getSubaddressLabel(accountIndex, addressIndex).c_str());
    }

    char *get_subaddress_account(uint32_t accountIndex, uint32_t addressIndex) {
        std::vector<Monero::SubaddressRow *> _subaddresses = m_subaddress->getAll();
        size_t size = _subaddresses.size();
        
        Monero::SubaddressRow *row = nullptr;
        
        for (size_t i = 0; i < size; i++) {
            if(i == addressIndex) {
                row = _subaddresses[i];
                break;
            }
        }
        if(row == nullptr) {
            return nullptr;
        }
        return strdup(row->getAddress().c_str());
    }
#ifdef __cplusplus
}
#endif
