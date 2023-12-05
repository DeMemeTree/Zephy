import * as core from "zephyr-javascript";
import MoneroWalletFull = require("zephyr-javascript/src/main/js/wallet/MoneroWalletFull");
import { ICreateWallet, IOpenWallet, ITxConfig, IKeys, IMonerRPCConnection } from "./config";
import MoneroTxWallet = require("zephyr-javascript/src/main/js/wallet/model/MoneroTxWallet");
import ZephyrBalance = require("zephyr-javascript/src/main/js/wallet/model/ZephyrBalance");
import MoneroAddressBookEntry = require("zephyr-javascript/src/main/js/wallet/model/MoneroAddressBookEntry");


let wallet: MoneroWalletFull;
declare function nativeLog(message: string): void;

export const createWallet = () => {
  nativeLog("Cant find path")
  //wallet = await core.createWalletFull(walletData);
  return true;
};

// export const createWallet = async (walletData: ICreateWallet) => {
//   nativeLog(walletData.path ?? "Cant find path")
//   wallet = await core.createWalletFull(walletData);
//   return true;
// };

export const openWallet = async (walletData: IOpenWallet) => {
  wallet = await core.openWalletFull(walletData);
  return true;
};

export const closeWallet = async (save: boolean) => {
  //@ts-ignore
  return wallet.close(save);
};

export const getReserveInfo = async () => {
  //@ts-ignore
  return wallet.getReserveInfo();
};

export const getBalance = async (
  accountIdx: number | undefined = undefined,
  subaddressIdx: number | undefined = undefined,
  assetType: string | undefined = undefined,
) => {
  if (!wallet) {
    throw Error("no wallet exist");
  }
  //@ts-ignore
  const balance: ZephyrBalance = await wallet.getBalance(accountIdx, subaddressIdx, assetType);
  return balance;
};

export const getUnlockedBalance = async (
  accountIdx: number | undefined = undefined,
  subaddressIdx: number | undefined = undefined,
  assetType: string | undefined = undefined,
) => {
  if (!wallet) {
    throw Error("no wallet exist");
  }

  const balance: ZephyrBalance = await wallet.getUnlockedBalance(
    //@ts-ignore
    accountIdx,
    subaddressIdx,
    assetType,
  );
  return balance;
};

export const getWalletData = async (): Promise<DataView[]> => {
  return wallet.getData();
};

export const getMnemonic = async () => {
  return wallet.getMnemonic();
};


export const getWalletHeight = async () => {
  return wallet.getHeight();
};

export const getNodeHeight = async () => {
  return wallet.getDaemonHeight();
};

export const getChainHeight = async () => {
  return wallet.getDaemonMaxPeerHeight();
};

export const isWalletConnected = async (): Promise<boolean> => {
  if (!wallet) return false;
  return wallet.isConnectedToDaemon();
};

export const setDaemonConnection = async (connection: IMonerRPCConnection) => {
  //@ts-ignore
  return wallet.setDaemonConnection(connection);
};
