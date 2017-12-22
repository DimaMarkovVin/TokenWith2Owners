pragma solidity ^0.4.18;

import "./ERC20Interface.sol";

contract Token2Own is ERC20Interface {
	string public constant name = "Group`s Token";
	string public constant symbol = "GT";
	uint8 public constant decimals = 0;
	mapping (address => uint256) balances;

	mapping (address => mapping (address => uint256)) allowed;

	uint256 _totalSupply = 1000000;

	mapping (address => bool) owners;
	mapping (address => mapping (address => bool)) ownerChoice;
	mapping (address => uint) counter;
	uint length = 2;

	modifier onlyOwner() {
		require(owners[msg.sender] == true);
		_;
	}

	function Token2Own() public {
		owners[0xF3615d88e54d28382F3b02e37804D71f1F9FB278] = true;
		owners[0xBae0Eb167f8BC5d0e42da66135F8E30e102603BD] = true;
		balances[0xF3615d88e54d28382F3b02e37804D71f1F9FB278] = _totalSupply/2;
		balances[0xBae0Eb167f8BC5d0e42da66135F8E30e102603BD] = _totalSupply - balances[0xF3615d88e54d28382F3b02e37804D71f1F9FB278];
	}

	function isOwner(address _owner) public constant returns (bool isOwner) {
		return owners[_owner];
	}

	function isOwnerChoice(address _owner, address _newOwner) public constant returns (bool isOwnerChoice) {
		return ownerChoice[_owner][_newOwner];
	}

	function addOwner(address _newOwner) public onlyOwner {
		require(ownerChoice[msg.sender][_newOwner] == false && owners[_newOwner] == false);
			ownerChoice[msg.sender][_newOwner] = true;
			counter[_newOwner]++;
			if (counter[_newOwner] > length/2) {
				owners[_newOwner] = true;
				length++;
				counter[_newOwner] = 0;
			}
	}


	function totalSupply() public constant returns (uint256 totalSupply) {
		totalSupply = _totalSupply;
		return totalSupply;
	}

	function balanceOf(address _owner) public constant returns (uint256 balance) {
		return balances[_owner];
	}

	function transfer(address _to, uint256 _value) returns (bool success) {
		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value >= balances[_to]) { 
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		}
		else {
			return false;
		}
	}

	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
		if(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value) { 
			balances[_from] -= _value;
			balances[_to] += _value;
			Transfer(_from, _to, _value);
			return true;
		}
		else {
			return false;
		}
	}

	function approve(address _spender, uint256 _value) returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}


	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}