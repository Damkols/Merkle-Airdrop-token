// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "solmate/src/utils/MerkleProofLib.sol";


contract Airdrop is ERC20 {
    bytes32 merkleRoot;

    constructor(bytes32 _root) ERC20("Merkle", "MKL") {
        merkleRoot = _root;
    }

    mapping(address => bool) claimStatus;
    event AddressClaim(address account, uint256 amount);

    function claim(
        bytes32[] calldata _merkleProof,
        address claimer,
        uint256 _amount
    ) external returns (bool success) {
        require(!claimStatus[claimer], "You have already claimed!");
        bytes32 node = keccak256(abi.encodePacked(claimer, _amount));
        success = MerkleProofLib.verify(_merkleProof, merkleRoot, node);
        //  require(MerkleProof.verify(proof, merkleRoot, bytes32(uint256(msg.sender))), "Invalid proof");
        require(success, "MerkleDistributor: Invalid proof.");
        claimStatus[claimer] = true;
        _mint(claimer, _amount);
        claimStatus[claimer] = true;
        emit AddressClaim(claimer, _amount);
    }
}
