pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

// the contract is similar to a class
contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // this is a constructor of a Zombie object
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // mappings are key-value pairs that store data
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // underscore in function argument is convention to distinguish between global variables and function variables
    // internal functions are functions that can be called by objects that inherit from this contract
    function _createZombie(string memory _name, uint _dna) internal {
        // Array.push() returns the length of the array after inserting value
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // msg.sender gives the address of the owner of the contract
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        // fire an event
        emit NewZombie(id, _name, _dna);
    } 

    // functions that have view only read data
    // functions are public by default
    // add private to make the function inaccessible to unauthorized calls fromt the network
    function _generateRandomDna(string memory _str) private view returns (uint) {
        // typecasting values
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // if the condition is false, an error will be thrown
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

