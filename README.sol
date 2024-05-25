# To-do-List


// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract TodoList {
    struct Todo {
        uint256 id;
        bytes32 content;
        address owner;
        bool isCompleted;
        uint256 timestamp;
    }

    uint256 public constant maxAmountOfTodos = 100;
    
    // Owner => todos
    mapping(address => Todo[maxAmountOfTodos]) public todos;
    
    // Owner => last todo id
    mapping(address => uint256) public lastIds;

    modifier onlyOwner(address _owner) {
        require(msg.sender == _owner, "Only the owner can perform this action");
        _;
    }

    // Add a todo to the list
    function addTodo(bytes32 _content) public {
        Todo memory myNote = Todo(lastIds[msg.sender], _content, msg.sender, false, block.timestamp);
        todos[msg.sender][lastIds[msg.sender]] = myNote;
        if (lastIds[msg.sender] >= maxAmountOfTodos) {
            lastIds[msg.sender] = 0;
        } else {
            lastIds[msg.sender]++;
        }
    }

    // Mark a todo as completed
    function markTodoAsCompleted(uint256 _todoId) public onlyOwner(todos[msg.sender][_todoId].owner) {
        require(_todoId < maxAmountOfTodos, "Invalid todo ID");
        require(!todos[msg.sender][_todoId].isCompleted, "Todo is already completed");
        todos[msg.sender][_todoId].isCompleted = true;
    }
}
