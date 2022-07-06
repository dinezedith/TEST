// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Dropbox {

    uint256 maxsize = 250;
    address public owner;
    uint256 fee;
    
    constructor() {
        owner = msg.sender;
        fee = 1 * 10 ** 16;
    }

    mapping(address => string) public fileToOwner;
    mapping(string => address) public ownerToFile;

    enum Type {
        UPLOAD,
        DOWNLOAD
    }

    function getUpload(string calldata URI, uint256 _size, Type _type) external payable {
        require(_size > 0, "Invalid size");
        if(_size > maxsize && ownerToFile[URI] != msg.sender) {
            uint256 _fee = (_size - maxsize) * 1024 * fee; 
            require(msg.value  >= _fee, "paid invalid amount");
            payable(owner).transfer(_fee);
            payable(msg.sender).transfer(msg.value - fee);
        }
        if(Type.UPLOAD == _type) {
        fileToOwner[msg.sender] = URI;
        ownerToFile[URI] = msg.sender;
        }
    }
}
