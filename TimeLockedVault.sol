// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Time-Locked Personal Vault
 * @dev Brankas ETH yang terkunci sampai waktu tertentu
 */
contract TimeLockedVault {
    address public immutable owner;
    uint256 public immutable lockDuration;
    uint256 public unlockTime;
    bool public fundsDeposited;

    event DepositMade(address indexed user, uint256 amount, uint256 availableAt);
    event FundsWithdrawn(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Bukan pemilik");
        _;
    }

    modifier isUnlocked() {
        require(block.timestamp >= unlockTime, "Dana masih terkunci");
        _;
    }

    modifier noActiveDeposit() {
        require(!fundsDeposited, "Sudah ada dana, tarik dulu");
        _;
    }

    constructor(uint256 _lockDuration) {
        require(_lockDuration > 0, "Waktu kunci harus > 0");
        owner = msg.sender;
        lockDuration = _lockDuration;
    }

    function deposit() external payable onlyOwner noActiveDeposit {
        require(msg.value > 0, "Jumlah harus lebih dari 0");
        unlockTime = block.timestamp + lockDuration;
        fundsDeposited = true;
        emit DepositMade(msg.sender, msg.value, unlockTime);
    }

    function withdraw() external onlyOwner isUnlocked {
        uint256 saldo = address(this).balance;
        require(saldo > 0, "Tidak ada dana");
        fundsDeposited = false;
        unlockTime = 0;
        (bool sukses, ) = payable(owner).call{value: saldo}("");
        require(sukses, "Gagal kirim dana");
        emit FundsWithdrawn(msg.sender, saldo);
    }

    function sisaWaktu() external view returns (uint256) {
        if (!fundsDeposited || block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp;
    }
}
