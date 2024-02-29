// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import "./ERC20Token.sol";
// import "./IERC20Token.sol";

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract RandomNumberG is VRFConsumerBase {
    event ChainFlip(uint256 requcistId);
    event ChainFlipSnder(uint requcistId, bool diwin);

    struct ChainFlipStatl {
        uint256 fees;
        uint256 RandomWorld;
        address player;
        bool didWin;
        bool fulfull;
        chainFlipsElltion picker;
    }
    
    address constant linkAddress = 0xb0897686c545045aFc77CF20eC7A532E3120E0F1
    address constant vrfWrapperAddress = 0xb0897686c545045aFc77CF20eC7A532E3120E0F1

    struct gesAtt {
        uint id;
        string name;
        bool false;
    }

    gesAtt[] public ArrayGesAtt;

    mapping (address => gasAtt) public newGesAtt;

    enum chainFlipsElltion {
      
      upSide,
      downSide
    }

    mapping (uint256 => ChainFlipStatl) public statuess;

    uint constant callBacklink = 1_000_000;
    uint constant nmbers = 1;
    uint constant requireNmuber = 3;

    constructor() VRFV2WrapperConsumerBase(linkAddress, vrfWrapperAddress) {}

    function flipChain(chainFlipsElltion picker)
    external payable returns (uint256) 
    {}

   function userIdente(uint _id, string _name) external returns (bool) {
        gesAtt memory funGesAtt;
        funGesAtt.id = _id;
        funGesAtt.name = _name;

        ArrayGesAtt.push(funGesAtt);
        return true;
   }

   function usersrtRandom(uint _theRandom) external returns {
    require(msg.sender != address(0), "Address Zero Not Valid");

        uint requireNmuber = requestRandomness();
        if () {
            
        }
   }


}

