// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Campain {
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 public numberOfApprovers;
    Request[] public requests;

    struct Request {
        string description;
        uint256 value;
        address payable receipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }

    constructor(uint256 _minimumContribution) {
        manager = msg.sender;
        minimumContribution = _minimumContribution;
        numberOfApprovers = 0;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        // approvers.push(msg.sender);
        approvers[msg.sender] = true;
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function createRequest(
        string memory description,
        uint256 value,
        address payable receipient
    ) public OnlyAllowedForManager {
        // Solution from: https://stackoverflow.com/a/66916116/3705299
        Request storage request = requests[numberOfApprovers++];
        request.description = description;
        request.value = value;
        request.receipient = receipient;
        request.complete = false;
    }

    function approveRequest(uint256 index) public OnlyAllowedForContributor {
        Request storage request = requests[index];
        require(!request.approvals[msg.sender]); // if already not approved
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint256 index) public payable {
        Request storage request = requests[index];
        require(request.approvalCount > numberOfApprovers / 2);
        require(!request.complete);
        request.complete = true;
        request.receipient.transfer(request.value);
    }

    modifier OnlyAllowedForContributor() {
        require(true);
        _;
    }

    modifier OnlyAllowedForManager() {
        require(msg.sender == manager);
        _;
    }
}
