// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin/token/ERC721/ERC721.sol";
import "openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";

import "./auth/Monarchy.sol";

/// @title Phase Profile
/// @author Autocrat (Ryan)
/// @notice NFT holding a persons link profile
/// @dev Visibility _symbol in OpenZeppelin's ERC721.sol is switched to internal
contract Phase is ERC721URIStorage, Monarchy {

    /*///////////////////////////////////////////////////////////////
                            INITIALIZATION
    //////////////////////////////////////////////////////////////*/

    /// @notice address of phase owner
    address public immutable owner;

    /// @notice address => id of nft they hold
    mapping (address => uint) public holder; 

    /// @notice NFT ID
    uint public id = 1;

    string public avatar;

    string public banner;
    
    string public bio;

    string[][] public links;

    string[] public messages;

    constructor(
        address _address,
        string memory _username,
        string memory _avatar,
        string memory _banner,
        string memory _bio,
        string[][] memory _links
    ) ERC721("Phase Profile", _username) Monarchy(_address) {
        owner = _address;
        avatar = _avatar;
        banner = _banner;
        bio = _bio;
        links = _links;
    }

    /*///////////////////////////////////////////////////////////////
                              FOLLOWING
    //////////////////////////////////////////////////////////////*/

    function mint(address to, string calldata metadata) public onlyMonarch {
        require(balanceOf(to) == 0, "ALREADY_FOLLOWS!");

        _mint(to, id);

        _setTokenURI(id, metadata);

        holder[to] = id;

        ++id;
    }

    /// @dev TEMP Need to make sure users can't burn random ppl's tokens!
    function burn(address unfollower) public {
        require(balanceOf(unfollower) > 0, "NOT_FOLLOWING!");

        uint _id = holder[unfollower];

        _burn(_id);

        holder[unfollower] = 0;
    }

    /*///////////////////////////////////////////////////////////////
                              CHANGE PROFILE
    //////////////////////////////////////////////////////////////*/

    /// @notice if argument isn't empty string, changes global value
    /// @dev changed OZ's ERC721.sol _symbol from private to internal
    function changeProfile(
        string memory _username,
        string memory _avatar,
        string memory _banner,
        string memory _bio,
        string[][] memory _links
    ) public onlyMonarch {
        _symbol = _username;

        avatar = _avatar;

        banner = _banner;
        
        bio = _bio;

        links = _links;
    }

    /*///////////////////////////////////////////////////////////////
                                DISPLAY
    //////////////////////////////////////////////////////////////*/

    function viewProfile() public view returns (string[4] memory) {
        return [_symbol, avatar, bio, banner];
    }
    
    function viewLinks() public view returns (string[][] memory) {
        return links;
    }

    /*///////////////////////////////////////////////////////////////
                              SOULBOUND
    //////////////////////////////////////////////////////////////*/

    /// @notice Reverts on attempted transfer
    function _beforeTokenTransfer(
        address from, 
        address to, 
        uint tokenId
    ) internal virtual override {
        require(to == address(0) || from == address(0), "SOULBOUND");
        tokenId;
    } 

    
}