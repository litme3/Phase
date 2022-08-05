// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./auth/Monarchy.sol";
import "./Phase.sol";

/// @title Phase Protocol
/// @author Autocrat (Ryan)
/// @notice Creates & interfaces with Phase Profiles
contract MetaPhase is Monarchy {

    /*///////////////////////////////////////////////////////////////
                            INITIALIZATION
    //////////////////////////////////////////////////////////////*/

    constructor() Monarchy(address(0)) {}

    /*///////////////////////////////////////////////////////////////
                            PHASE PROFILE 
    //////////////////////////////////////////////////////////////*/

    /// @notice username => whether or not it's taken
    mapping (string => bool) public usernames;

    /// @notice address => phase profile
    mapping (address => Phase) public phase;

    /// @notice array of phases
    Phase[] public phases;

    event CreatedProfile(
        address indexed user_address, 
        address indexed phase_address, 
        string username
    );

    event ChangedProfile(
        address indexed user_address, 
        address indexed phase_address, 
        string username
    );

    function createProfile(
        address _address, 
        string memory username,
        string memory avatar,
        string memory background_image,
        string memory bio,
        string[][] memory links
    ) public onlyKing {
        require(bytes(username).length > 0, "EMPTY_USERNAME!");
        require(!usernames[username], "USERNAME_TAKEN!");

        Phase _phase = new Phase(
            _address,
            username, 
            avatar,
            background_image,
            bio,
            links
        );

        phase[_address] = _phase;

        usernames[username] = true;

        phases.push(_phase);

        emit CreatedProfile(_address, address(_phase), username);
    }

    /// @notice Will set new profile 
    /// @dev Didn't feel like making an event for this, but can
    function changeProfile(
        address _address,
        string memory username,
        string memory avatar,
        string memory background_image,
        string memory bio,
        string[][] memory links
    ) public onlyKing {
        require(bytes(username).length > 0, "EMPTY_USERNAME!");

        Phase _phase = phase[_address];

        usernames[_phase.symbol()] = false;

        require(!usernames[username], "USERNAME_TAKEN!");

        _phase.changeProfile(
            username,
            avatar,
            background_image,
            bio,
            links
        );

        usernames[username] = true;
    }

    /*///////////////////////////////////////////////////////////////
                               FOLLOWING
    //////////////////////////////////////////////////////////////*/

    event Follow(address indexed follower, address indexed following, address indexed phase_profile);

    event Unfollow(address indexed unfollower, address indexed unfollowing, address indexed phase_profile);

    /// @notice Mints Phase Profile
    /// @param follower Person receiving NFT
    /// @param following Owner of the Phase Profile to be minted
    /// @param metadata JSON NFT schema of the links of Phase Profile
    function follow (
        address follower, 
        address following, 
        string calldata metadata
    ) public onlyKing {
        Phase _phase = phase[following];

        require(_phase.balanceOf(follower) == 0, "ALREADY_FOLLOWING!");

        _phase.mint(follower, metadata);

        emit Follow(follower, following, address(_phase));
    }

    function unfollow (address unfollower, address unfollowing) public onlyKing {
        Phase _phase = phase[unfollowing];

        require(_phase.balanceOf(unfollower) > 0, "NOT_FOLLOWING!");

        _phase.burn(unfollower);

        emit Unfollow(unfollower, unfollowing, address(_phase));
    }

    /*///////////////////////////////////////////////////////////////
                               DISPLAY
    //////////////////////////////////////////////////////////////*/

    /// @notice returns nested array of links
    /// @dev other profile info (name, avatar, banner, bio) will need to be queried manually
    /// @param _address of phase owner
    function displayLinks(address _address) public view returns (string[][] memory links) {
        links = phase[_address].displayLinks();
    }

    /// @notice returns an array of phase addresses
    function viewPhases() public view returns (Phase[] memory) {
        return phases;
    }

}