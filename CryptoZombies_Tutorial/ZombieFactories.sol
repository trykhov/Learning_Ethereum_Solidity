pragma solidity >=0.5.0 <0.6.0;

// the contract is similar to a class
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // this is a constructor of a Zombie object
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // functions are public by default
    // add private to make the function inaccessible to unauthorized calls fromt the network
    // underscore in function argument is convention to distinguish between global variables and function variables
    function _createZombie(string memory _name, uint _dna) private {
        // Array.push() returns the length of the array after inserting value
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // fire an event
        emit NewZombie(id, _name, _dna);
    } 

    // functions that have view only read data
    // 
    function _generateRandomDna(string memory _str) private view returns (uint) {
        // typecasting values
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}