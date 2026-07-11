// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Time-Locked Personal Vault
 * @dev Brankas ETH yang terkunci sampai waktu tertentu
 * Aturan: Hanya pemilik yang bisa setor, tarik hanya setelah masa kunci habis
 */
contract TimeLockedVault {
    // --- Variabel Penyimpanan ---
    address public immutable owner;          // Alamat pembuat kontrak
    uint256 public immutable lockDuration;    // Lama kunci (dalam detik)
    uint256 public unlockTime;                // Waktu kapan dana bisa ditarik
    bool public fundsDeposited;               // Status apakah ada dana tersimpan

    // --- Pencatat Peristiwa ---
    event DepositMade(address indexed user, uint256 amount, uint256 availableAt);
    event FundsWithdrawn(address indexed user, uint256 amount);

    // --- Pembatas Akses ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Bukan pemilik kontrak");
        _;
    }

    modifier isUnlocked() {
        require(block.timestamp >= unlockTime, "Error: Dana masih terkunci");
        _;
    }

    modifier noActiveDeposit() {
        require(!fundsDeposited, "Error: Sudah ada dana, tarik dulu");
        _;
    }

    // --- Pembuatan Kontrak ---
    constructor(uint256 _lockDuration) {
        require(_lockDuration > 0, "Error: Lama kunci harus lebih dari 0");
        owner = msg.sender;
        lockDuration = _lockDuration;
    }

    // --- Fungsi Setor Dana ---
    function deposit() external payable onlyOwner noActiveDeposit {
        require(msg.value > 0, "Error: Jumlah setoran tidak boleh nol");
        
        unlockTime = block.timestamp + lockDuration;
        fundsDeposited = true;

        emit DepositMade(msg.sender, msg.value, unlockTime);
    }

    // --- Fungsi Tarik Dana ---
    function withdraw() external onlyOwner isUnlocked {
        uint256 balance = address(this).balance;
        require(balance > 0, "Error: Tidak ada dana untuk ditarik");

        // Reset status setelah tarik
        fundsDeposited = false;
        unlockTime = 0;

        // Kirim dana ke pemilik
        (bool sent, ) = payable(owner).call{value: balance}("");
        require(sent, "Error: Pengiriman dana gagal");

        emit FundsWithdrawn(msg.sender, balance);
    }

    // --- Fungsi Bantuan Cek Sisa Waktu ---
    function getRemainingTime() external view returns (uint256) {
        if (!fundsDeposited || block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp;
    }
}
