fn mul(a: felt252, b: felt252) -> felt252{
    a * b
}

#[test]
#[fuzzer(runs: 100, seed: 4540)]
fn test_fuzz_sum (x: felt252, y: felt252){
    assert(mul(x, y) == x * y, 'incorrect');
}