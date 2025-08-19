pragma solidity ^0.8.0;

contract DecentralizedSimulator {
    struct Node {
        address owner;
        string name;
        uint256 balance;
    }

    struct Transaction {
        uint256 id;
        address sender;
        address receiver;
        uint256 amount;
    }

    mapping (address => Node) public nodes;
    mapping (uint256 => Transaction) public transactions;
    uint256 public transactionCount;

    event NewNodeAdded(address indexed owner, string name);
    event TransactionMade(uint256 indexed id, address sender, address receiver, uint256 amount);

    constructor() {
        // Initialize a genesis node
        nodes[address(this)] = Node(address(this), "Genesis Node", 1000000);
        emit NewNodeAdded(address(this), "Genesis Node");
    }

    function addNode(string memory _name) public {
        // Only allow unique node names
        require(!checkNodeExists(msg.sender), "Node already exists");
        nodes[msg.sender] = Node(msg.sender, _name, 0);
        emit NewNodeAdded(msg.sender, _name);
    }

    function checkNodeExists(address _address) public view returns (bool) {
        return nodes[_address].owner != address(0);
    }

    function makeTransaction(address _receiver, uint256 _amount) public {
        // Check if sender has sufficient balance
        require(nodes[msg.sender].balance >= _amount, "Insufficient balance");
        
        // Update sender's balance
        nodes[msg.sender].balance -= _amount;

        // Update receiver's balance
        nodes[_receiver].balance += _amount;

        // Add transaction to the ledger
        transactionCount++;
        transactions[transactionCount] = Transaction(transactionCount, msg.sender, _receiver, _amount);
        emit TransactionMade(transactionCount, msg.sender, _receiver, _amount);
    }

    function getNodeBalance(address _address) public view returns (uint256) {
        return nodes[_address].balance;
    }

    function getTransaction(uint256 _id) public view returns (address, address, uint256) {
        return (transactions[_id].sender, transactions[_id].receiver, transactions[_id].amount);
    }
}