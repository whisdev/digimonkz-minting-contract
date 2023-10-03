// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// // import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./Guardian/Erc721LockRegistry.sol";
import "./interfaces/IERC721xHelper.sol";
import "./OPR/upgradeable/DefaultOperatorFiltererUpgradeable.sol";

using SafeMath for uint256;

contract DigiMonkzMinting is Initializable, ERC721x, DefaultOperatorFiltererUpgradeable{
    
    address public contractOwner;
    address public _admin;

    uint256 public totalMintedNum;
    uint256 public MAX_SUPPLY;
    uint256 public MINT_PRICE;
    uint256 public totalMinted;

    string public baseTokenURI;
    string public tokenURISuffix;
    string public tokenURIOverride;

    bool public mintFlag;

    mapping(address => uint256[]) totalUserNftList;

    function initialize(
        string memory baseURI,
        address admin
    ) public initializer {
        ERC721x.__ERC721x_init("DigiMonkzMinting", "DigiMonkzMinting");
        DefaultOperatorFiltererUpgradeable.__DefaultOperatorFilterer_init();
        _admin = admin;
        baseTokenURI = baseURI;
        MAX_SUPPLY = 1111;
    }

    function safeMint(uint256 _amount) internal {
        uint256 temp = totalMinted;
        require(totalMinted + _amount <= MAX_SUPPLY, "exceed MAX_SUPPLY");
        for (uint256 i=temp+1 ; i <= i+_amount; i ++) 
        {
            _mint(msg.sender, i);
        }
    }

    // ======================= Minting =========================
    function setMint(bool _mintFlag, uint256 _price) external onlyOwner {
        mintFlag = _mintFlag;
        MINT_PRICE = _price;
    }

    function minting(uint256 _amount) payable external {
        require(mintFlag, "Mint not open");
        require(msg.value == MINT_PRICE * _amount, "Failed minting");
        safeMint(_amount);
    }

    // ====================Base URI =============================
    function compareStrings (string memory a, string memory b) public pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(uint256 _tokenId) public view override(ERC721AUpgradeable, IERC721AUpgradeable) returns (string memory){
        if (bytes(tokenURIOverride).length > 0) {
            return tokenURIOverride;
        }
        return string.concat((super.tokenURI(_tokenId)), tokenURISuffix);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        baseTokenURI = baseURI;
    }

    function setTokenURISuffix(string calldata _tokenURISuffix) external onlyOwner {
        if (compareStrings(_tokenURISuffix, "!empty!")){
            tokenURISuffix = "";
        } else {
            tokenURISuffix = _tokenURISuffix;
        }
    }

    // ========================== Marketplace Control ==============================







    function userNftList() external view returns ( uint256[] memory) {
        uint256[] memory perUserNftList = totalUserNftList[msg.sender];
        return perUserNftList;
    }
}

// 0x18Ed8e3De1eae49438fe9bceE570982c98aB09e0
// 0x7F0eF5632d91A26cD7B67FB2b3aDCEdDFb5868D7
