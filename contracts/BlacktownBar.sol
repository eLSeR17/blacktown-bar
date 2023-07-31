// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.8;

import "./BlacktownToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error BlacktownBar__PoolNotAvailable();
error BlacktownBar__DartsNotAvailable();
error BlacktownBar__FootballNotAvailable();
error BlacktownBar__ChessNotAvailable();
error BlacktownBar__NotMoneyForPool(address);
error BlacktownBar__NotMoneyForDarts(address);
error BlacktownBar__NotMoneyForFootball(address);
error BlacktownBar__NotMoneyForDrink(address, string);
error BlacktownBar__NonExistingDrink(address);

contract BlacktownBar is BlacktownToken, Ownable{
    uint poolFee;
    uint footballFee;
    uint dartsFee;
    uint lastRun;
    uint taxesToPay;
    uint materialCosts;

    mapping(address => bool) playingPool;
    mapping(address => bool) playingDarts;
    mapping(address => bool) playingFootball;
    mapping(address => bool) playingChess;
    mapping(string => uint) drinksPrice;
    mapping(address => mapping(string => uint)) drinksByUser;
    mapping(address => uint) userLevel;

    bool poolTaken_1;
    bool poolTaken_2;
    bool footballTaken_1;
    bool footballTaken_2;
    bool footballTaken_3;
    bool dartsTaken;
    bool chessTaken;

    event pool1_taken(address player);
    event pool2_taken(address player);
    event football1_taken(address player);
    event football2_taken(address player);
    event football3_taken(address player);
    event darts_taken(address player);
    event chess_taken(address player);

    event pool1_free(address player);
    event pool2_free(address player);
    event football1_free(address player);
    event football2_free(address player);
    event football3_free(address player);
    event darts_free(address player);
    event chess_free(address player);

    event winGame(address player);

    constructor(){
        taxesToPay = 10**16;
        taxesToPay = 3*10**16;

        poolFee = 10**16;
        dartsFee = 10**16;
        footballFee = 10**16;

        poolTaken_1 = false;
        poolTaken_2 = false;
        footballTaken_1 = false;
        footballTaken_2 = false;
        footballTaken_3 = false;
        dartsTaken = false;
        chessTaken = false;

        drinksPrice["small beer"] = 10**15;
        drinksPrice["medium beer"] = 2*10**15;
        drinksPrice["large beer"] = 5*10**15;
        drinksPrice["kalimotxo"] = 6*10**15;
        drinksPrice["juice"] = 10**15;
        drinksPrice["cockatil"] = 10**16;
    }

    function playPool() public payable{
        if(msg.value < poolFee - userLevel[msg.sender]*10**15){
            revert BlacktownBar__NotMoneyForPool(msg.sender);
        }
        if(poolTaken_1){
            if(poolTaken_2){
                revert BlacktownBar__PoolNotAvailable();
            }
            poolTaken_2 = true;
            emit pool2_taken(msg.sender);
        }      
        poolTaken_1 = true;
        emit pool1_taken(msg.sender);     

        (bool success,) = address(this).call{value: msg.value}("");

        if(success){
            playingPool[msg.sender] = true;
        }
    }

   function playDarts() public payable{
        if(msg.value < dartsFee - userLevel[msg.sender]*10**15){
            revert BlacktownBar__NotMoneyForDarts(msg.sender);
        }
        if(dartsTaken){
                revert BlacktownBar__DartsNotAvailable();
        }      
        dartsTaken = true;
        emit darts_taken(msg.sender);     

        (bool success,) = address(this).call{value: msg.value}("");

        if(success){
            playingDarts[msg.sender] = true;
        }
    }

    function playFootball() public payable{
        if(msg.value < footballFee - userLevel[msg.sender]*10**15){
            revert BlacktownBar__NotMoneyForFootball(msg.sender);
        }
        if(footballTaken_1){
            if(footballTaken_2){
                if(footballTaken_3){
                    revert BlacktownBar__DartsNotAvailable();
                }
                footballTaken_3 = true;
                emit football3_taken(msg.sender);
            }
            else{
                footballTaken_2 = true;
                emit football2_taken(msg.sender);    
            }          
        } 
        else{
        footballTaken_1 = true;
        emit football1_taken(msg.sender); 
        }   
           
        (bool success,) = address(this).call{value: msg.value}("");

        if(success){
            playingFootball[msg.sender] = true;
        }
    }

    function playChess() public payable{
        if(chessTaken){
                revert BlacktownBar__ChessNotAvailable();
        }      
        chessTaken = true;
        emit darts_taken(msg.sender);     

        (bool success,) = address(this).call{value: msg.value}("");

        if(success){
            playingChess[msg.sender] = true;
        }
    }

    function orderDrinks(string memory drink) public payable{
        if(drinksPrice[drink] == 0){
            revert BlacktownBar__NonExistingDrink(msg.sender);
        }
        if(msg.value < drinksPrice[drink] - userLevel[msg.sender]*10**15){
            revert BlacktownBar__NotMoneyForDrink(msg.sender, drink);
        }
        (bool success,) = address(this).call{value: msg.value}("");
        drinksByUser[msg.sender][drink]++;
    }

    
    //General functions about the economy of the bar

    

    function upgradeUser(address user) public onlyOwner{
        userLevel[user]++;
    }


    function getReward() public onlyOwner(){
        require(block.timestamp - lastRun > 5 minutes, "Not ready to get reward");
            uint valueToSend = address(this).balance/100;
            (bool success,) = msg.sender.call{value: valueToSend}("");
            lastRun = block.timestamp;
        }

    function getLiquidity() public view returns (uint){
        uint liquidity = address(this).balance - taxesToPay - materialCosts;
        return liquidity;
    }

}

    
