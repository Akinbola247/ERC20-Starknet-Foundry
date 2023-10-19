
#[cfg(test)]
mod tests {
use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::TryInto;
use starknet::ContractAddress;
use starknet::Felt252TryIntoContractAddress;

use snforge_std::{declare, ContractClassTrait, start_prank, stop_prank};

use erc20_contract::erc20::Ierc20SafeDispatcher;
use erc20_contract::erc20::Ierc20SafeDispatcherTrait;



fn deploy_contract(name: felt252) -> ContractAddress {
    let reciepient = starknet::contract_address_const::<0x01>();
    let supply : felt252 = 20000000;
    let contract = declare(name);
    let mut calldata = array![supply, reciepient.into()];
    contract.deploy(@calldata).unwrap()
}

#[test]
#[available_gas(3000000000000000)]
fn test_balance_of() {  
    let contract_address = deploy_contract('erc20');
    let safe_dispatcher = Ierc20SafeDispatcher { contract_address };
    let reciepient = starknet::contract_address_const::<0x01>();
    let balance = safe_dispatcher.balance_of(reciepient).unwrap();
    assert (balance == 20000000, 'Invalid Balance');
}

#[test]
#[available_gas(3000000000000000)]
fn test_transfer() {
    let contract_address = deploy_contract('erc20');
    let safe_dispatcher = Ierc20SafeDispatcher { contract_address };
    
    let sender = starknet::contract_address_const::<0x01>();
    let receiver = starknet::contract_address_const::<0x02>();
    let amount : felt252 = 10000000;
    
    start_prank(contract_address, sender);
    safe_dispatcher.transfer(receiver.into(), amount.into());
    let balance_after_transfer = safe_dispatcher.balance_of(receiver).unwrap();
    assert(balance_after_transfer == 10000000, 'invalid amount');
    stop_prank(contract_address);
 }

}