//0x6080604052  348015600e575f80fd5b5060a58061001b5f395ff3fe6080604052348015600e575f80fd5b50600436106030575f3560e01c8063cdfead2e146034578063e026c017146045575b5f80fd5b6043603f3660046059565b5f55565b005b5f5460405190815260200160405180910390f35b5f602082840312156068575f80fd5b503591905056fea2646970667358221220a92949a46bfcc781440a510a5f9ef6b9ad05ed1db50a6e20b780f15425af12a964736f6c63430008140033

// 3 sections:
//  1. Contract Creation
//  2. Runtime
//  3. Metadata

// 1. Contract Creation Code
// Free Memory Pointer
PUSH1 0x80 // [0x80]
PUSH1 0x40  // [0x40, 0x80]
MSTORE      // Memory[0x40: 0x80]

// What does this chunk do?
// If someone sent value with this call revert!
// Otherwise, jump to continue execution
CALLVALUE   // [msg.value]
DUP1        // [msg.value, msg.value]
ISZERO      // [msg.value == 0, msg.value]
PUSH1 0x0e  // [0x0e, msg.value == 0, msg.value]
JUMPI       // [msg.value]
PUSH0       // [0x00, msg.value]
DUP1        // [0x00, 0x00, msg.value]
REVERT      // [msg.value]

// Jump dest if msg.value == 0
// Sticks the runtime code on-chain
JUMPDEST    // [msg.value]
POP         // []
PUSH1 0xa5  // [0xa5]
DUP1        // [0xa5, 0xa5]
PUSH2 0x001b    // [0x001b, 0xa5, 0xa5]
PUSH0       // [0x00, 0x001b, 0xa5, 0xa5]
CODECOPY    // [0xa5]       Memory:[runtime code]
PUSH0       // [0x00, 0xa5]
RETURN      // []
INVALID     // []

// 2. Runtime Code
// Entry point of all calls
// free memory pointer
PUSH1 0x80
PUSH1 0x40
MSTORE

// Checking for msg.value, and if given, reverting
CALLVALUE       // [msg.value]
DUP1            // [msg.value, msg.value]
ISZERO          // [msg.value == 0, msg.value]
PUSH1 0x0e      // [0x0e, msg.value == 0, msg.value]
JUMPI           // [msg.value]
// Jump to "continue" if msg.value == 0

PUSH0           // [0x00, msg.value]
DUP1            // [0x00, 0x00, msg.value]
REVERT          // [msg.value]

// If msg.value == 0, start here!
// continue
// This is checking to see if there is enough calldata for a function selector
JUMPDEST        // [msg.value]
POP             // []
PUSH1 0x04      // [0x04]
CALLDATASIZE    // [calldata_size, 0x04]
LT              // [calldata_size < 0x04]
PUSH1 0x30      // [0x30, calldata_size < 0x04]
JUMPI           // []
// Jump to "calldata_jump" if calldata_size is less than 0x04

// Function dispatching in solidity
PUSH0           // [0]
CALLDATALOAD    // [32bytes of calldata]
PUSH1 0xe0      // [0xe0, 32bytes of calldata]
SHR             // [calldata[0:4]] // function_selector

// Function dispatching for setNumberOfHorses
DUP1            // [function_selector, function_selector]
PUSH4 0xcdfead2e    // [0xcdfead2e, function_selector, function_selector]
EQ              // [function_selector == 0xcdfead2e, function_selector]
PUSH1 0x34      // [0x34, function_selector == 0xcdfead2e, function_selector]
JUMPI           // [function_selector]
// if function_selector == 0xcdfead2e -> set_number_of_horses

// Function dispatching for readNumberOfHorses
DUP1            // [function_selector, function_selector]
PUSH4 0xe026c017    // [0xe026c017, function_selector, function_selector]
EQ              // [function_selector == 0xe026c017, function_selector]
PUSH1 0x45      // [0x45, function_selector == 0xe026c017, function_selector]
JUMPI           // [function_selector]
// if function_selector == 0xe026c017 -> read_number_of_horses

// calldata_jump
// Revert Jumpdest
JUMPDEST        // []
PUSH0           // [0x00]
DUP1            // [0x00, 0x00]
REVERT          // []

// updateHorseNumber jump dest 1
// Setup jumping program counters in the stack
JUMPDEST        // [function_selector]
PUSH1 0x43      // [0x43, function_selector]
PUSH1 0x3f      // [0x3f, 0x43, function_selector]
CALLDATASIZE    // [calldata_size, 0x3f, 0x43, function_selector]  
PUSH1 0x04      // [0x04, calldata_size, 0x3f, 0x43, function_selector]
PUSH1 0x59      // [0x59, 0x04, calldata_size, 0x3f, 0x43, function_selector]
JUMP            // [0x04, calldata_size, 0x3f, 0x43, function_selector]

// Jump dest 4
// We ca finally run an sstore to save our value to storage:
// 1. Function dispatching
// 2. Checked for msg.value
// 3. Checked that calldata is long enough
// 4. Received the number to use from the calldata
JUMPDEST        // [calldata(of numberToUpdate), 0x43, function_selector]
PUSH0           // [0, calldata(of numberToUpdate), 0x43, function_selector]
SSTORE          // [0x43, function_selector]
JUMP            // [function_selector]
// Jump des5 5

// Jump dest 5
JUMPDEST        // [function_selector]
STOP            // [function_selector]

// readNumberOfHorses jump dest 1
JUMPDEST        // [function_selector]
PUSH0           // [0, function_selector]
SLOAD           // [numHorses, function_selector]
PUSH1 0x40      // [0x40, numHorses, function_selector]
MLOAD           // [0x80, numHorses, function_selector] // Memory [0x40: 0x80] (free memory pointer)
SWAP1           // [numHorses, 0x80, function_selector]
DUP2            // [0x80, numHorses, 0x80, function_selector]
MSTORE          // [0x80, function_selector]    Memory: 0x80: numHorses
PUSH1 0x20      // [0x20, 0x80, function_selector]
ADD             // [0x20 + 0x80, function_selector]
PUSH1 0x40      // [0x40, 0x20 + 0x80, function_selector]
MLOAD           // [0x80, 0x20 + 0x80, function_selector]
DUP1            // [0x80, 0x80, 0x20 + 0x80, function_selector]
SWAP2           // [0x20 + 0x80, 0x80, 0x80, function_selector]
SUB             // [(0x20 + 0x80) - 0x80, 0x80, function_selector]
SWAP1           // [0x80, (0x20 + 0x80) - 0x80, function_selector]
// Return a value of size 32 bytes, thats located at position 0x80 in memory
RETURN          // [function_selector]

// updateHorseNumber jump dest 2
// Check to see if there is a value to update the horse number to 
// 4 bytes for function selector, 32 bytes for horse number
JUMPDEST    // [0x04, calldata_size, 0x3f, 0x43, function_selector]
PUSH0       // [0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
PUSH1 0x20  // [0x20, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
DUP3        // [0x04, 0x20, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
DUP5        // [calldata_size, 0x04, 0x20, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
SUB         // [calldata_size - 0x04, 0x20, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
// is there more calldata than just the function selector?
SLT         // [calldata_size - 0x04 < 0x20, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
ISZERO      // [calldata_size - 0x04 < 0x20 == true, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
PUSH1 0x68  // [0x68, calldata_size - 0x04 < 0x20 == true, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
JUMPI       // [0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
// We are going to jump to Jump dest 3 if there is more calldata than: function selector + 0x20

// Revert if there isn't enough calldata!
PUSH0       // [0, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
DUP1        // [0, 0, 0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
REVERT      // [0, 0x04, calldata_size, 0x3f, 0x43, function_selector]

// updateHorseNumber jump dest 3 
// Grab the calldata for updating the horse number and delete some stuff in the stack
JUMPDEST    // [0, 0x04, calldata_size, 0x3f, 0x43, function_selector]
POP         // [0x04, calldata_size, 0x3f, 0x43, function_selector]
CALLDATALOAD    // [calldata( of numberToUpdate), calldata_size, 0x3f, 0x43, function_selector]
SWAP2       // [0x3f, calldata_size, calldata( of numberToUpdate), 0x43, function_selector]
SWAP1       // [calldata_size, 0x3f, calldata( of numberToUpdate), 0x43, function_selector]
POP         // [0x3f, calldata(of numberToUpdate), 0x3f, 0x43, function_selector]
JUMP        //  [calldata(of numberToUpdate), 0x3f, 0x43, function_selector]
// jump to jump dest 4

// 3. Metadata
INVALID
LOG2
PUSH5 0x6970667358
INVALID
SLT
KECCAK256
INVALID
INVALID
BLOBHASH
LOG4
PUSH12 0xfcc781440a510a5f9ef6b9ad
SDIV
INVALID
SAR
INVALID
EXP
PUSH15 0x20b780f15425af12a964736f6c6343
STOP
ADDMOD
EQ
STOP
CALLER