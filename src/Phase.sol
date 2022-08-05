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

    /// @notice address => id of nft they hold
    mapping (address => uint) public owner; 
    
    /// @notice NFT ID
    uint public id = 1;

    string public avatar;

    string public background_image;
    
    string public bio;

    string public twitter;

    string public github;

    string public website;

    constructor(
        address _address,
        string memory _username,
        string memory _avatar,
        string memory _background_image,
        string memory _bio,
        string memory _twitter,
        string memory _github,
        string memory _website
    ) ERC721("Phase Profile", _username) Monarchy(_address) {
        avatar = _avatar;
        background_image = _background_image;
        bio = _bio;
        twitter = _twitter;
        github = _github;
        website = _website;
    }

    /*///////////////////////////////////////////////////////////////
                              FOLLOWING
    //////////////////////////////////////////////////////////////*/

    function mint(address to, string calldata metadata) public onlyMonarch {
        require(balanceOf(to) == 0, "ALREADY_FOLLOWS!");

        _mint(to, id);

        _setTokenURI(id, metadata);

        owner[to] = id;

        id++;
    }

    /// @dev TEMP Need to make sure users can't burn random ppl's tokens!
    function burn(address unfollower) public {
        require(balanceOf(unfollower) > 0, "NOT_FOLLOWING!");

        uint _id = owner[unfollower];

        _burn(_id);

        owner[unfollower] = 0;
    }

    /*///////////////////////////////////////////////////////////////
                                DISPLAY
    //////////////////////////////////////////////////////////////*/

    function display() public view returns (string[7] memory profile) {
        return [ _symbol, avatar, background_image, bio, twitter, github, website ];
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