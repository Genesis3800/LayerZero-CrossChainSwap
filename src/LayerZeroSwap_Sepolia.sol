// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@layerzero-contracts/lzApp/NonblockingLzApp.sol";

/**
 * @title LayerZeroSwap_Sepolia
 * @dev This contract sends a cross-chain message from Sepolia to Mumbai to transfer MATIC in return for deposited ETH.
 */
contract LayerZeroSwap_Sepolia is NonblockingLzApp {

    // State variables for the contract
    address payable deployer;    
    uint16 public destChainId;
    bytes payload;    
    address payable contractAddress = payable(address(this));

    // Instance of the LayerZero endpoint
    ILayerZeroEndpoint public immutable endpoint;

    /**
     * @dev Constructor that initializes the contract with the LayerZero endpoint.
     * @param _lzEndpoint Address of the LayerZero endpoint.
     */
    constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {
        deployer = payable(msg.sender);
        endpoint = ILayerZeroEndpoint(_lzEndpoint);

        // If Source == Sepolia, then Destination Chain = Mumbai
        if (_lzEndpoint == 0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1) destChainId = 10109;

        // If Source == Mumbai, then Destination Chain = Sepolia
        if (_lzEndpoint == 0xf69186dfBa60DdB133E91E9A4B5673624293d8F8) destChainId = 10161;
    }

    /**
     * @dev Allows users to swap to MATIC.
     * @param Receiver Address of the receiver.
     */
    function swapTo_MATIC(address Receiver) public payable {
        require(msg.value >= 1 ether, "Please send at least 1 ETH");
        uint value = msg.value;

        bytes memory trustedRemote = trustedRemoteLookup[destChainId];
        require(trustedRemote.length != 0, "LzApp: destination chain is not a trusted source");
        _checkPayloadSize(destChainId, payload.length);

        // The message is encoded as bytes and stored in the "payload" variable.
        payload = abi.encode(Receiver, value);

        endpoint.send{value: 15 ether}(destChainId, trustedRemote, payload, contractAddress, address(0x0), bytes(""));
    }

    /**
     * @dev Internal function to handle incoming LayerZero messages.
     */
    function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal override {
        (address Receiver , uint Value) = abi.decode(_payload, (address, uint));
        address payable recipient = payable(Receiver);        
        recipient.transfer(Value);
    }

    // Fallback function to receive ether
    receive() external payable {}

    /**
     * @dev Allows the owner to withdraw all funds from the contract.
     */
    function withdrawAll() external onlyOwner {
        deployer.transfer(address(this).balance);
    }
}
