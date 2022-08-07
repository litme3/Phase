// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @notice Minimal Primary & Secondary Auth with a Noble Aesthetic
abstract contract Monarchy {
    
    /*//////////////////////////////////////////////////////////////
                            INITIALIZATION
    //////////////////////////////////////////////////////////////*/

    event NewKing(address newKing);

    event NewQueen(address newQueen);

    address public king;

    address public queen;

    constructor(address _queen) {
        king = msg.sender;

        queen = _queen;

        emit NewKing(msg.sender);

        emit NewQueen(_queen);
    }

    /*//////////////////////////////////////////////////////////////
                                LAWS
    //////////////////////////////////////////////////////////////*/
    
    modifier onlyKing() virtual {
        require(msg.sender == king, "NOT_KING");

        _;
    }
    
    modifier onlyMonarch() virtual {
        require(msg.sender == king || msg.sender == queen, "NOT_MONARCH");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                                COMMANDS
    //////////////////////////////////////////////////////////////*/

    function annointKing (address newKing) public onlyKing {
        king = newKing;

        emit NewKing(newKing);
    }

    function annointQueen (address newQueen) public onlyMonarch {
        queen = newQueen;

        emit NewQueen(newQueen);
    }
}