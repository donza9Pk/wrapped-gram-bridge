# Wrapped Gram Bridge (WGRAM)

A public good infrastructure project providing a secure, source-available Wrapped Gram (WGRAM) token contract to support decentralized cross-chain asset transfers for the Gram and TON ecosystem.

## 🚀 Overview

Following the core ecosystem governance updates where the native TON token migrated to **Gram ($GRAM)**, this repository introduces the standard implementation for **Wrapped Gram (WGRAM)** on EVM-compatible chains (such as Binance Smart Chain and Ethereum). 

This project aims to enhance multi-chain liquidity, enable decentralized bridging, and provide open-source tooling for early adopters and developers in the TON network ecosystem.

## 🛠️ Key Features

- **ERC-20 Compliant:** Fully compatible with all decentralized exchanges (DEXs), automated market makers (AMMs), and DeFi protocols.
- **Secure Bridge Logic:** Integrated `depositBridge` and `withdrawBridge` functions managed via strict cryptographic ownership controls.
- **Gas Optimized:** Written in Solidity ^0.8.20 with clean execution pathways to preserve minimal gas usage during cross-chain transactions.
- **Audit Ready:** Source-available architecture designed for multi-signature (Multi-Sig) ownership transition to prevent single points of failure.

## 📜 Smart Contract Deployment

The core smart contract logic is written in `WrappedGram.sol`. It allows institutional bridges and community pools to lock native Gram tokens on the TON network and mint equivalent **WGRAM** on EVM-compatible chains 1:1.

## ⚖️ License

This project is open-source and available under the [MIT License](LICENSE).
