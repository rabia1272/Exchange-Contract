pragma solidity 0.6.0;

interface Token {
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
}

contract Exchange {
    uint256 orderId = 0;
    
    mapping(uint256=> Order) public orders;
    
    struct Order{
        uint256 orderId;
        address tokenContractAddress;
        address payable seller;
        uint256 eth_quantity;
        uint256 tokenId;
        bool isCompleted;
    }
    
    function placeOrder(address _tokenAddress, uint256 _quantity, uint256 _tokenID) public {
        orders[orderId] = Order(orderId,_tokenAddress, msg.sender, _quantity, _tokenID, false);
        orderId++;
    }
    
    function executeOrder(uint256 _orderId) public payable {
        orders[orderId].seller.transfer(orders[_orderId].eth_quantity);
        Token(orders[orderId].tokenContractAddress).transferFrom(orders[_orderId].seller, msg.sender, orders[_orderId].tokenId);
        orders[orderId] = Order(orderId,address(0), address(0), 0, 0, true);
    }
}
