object "HorseStoreYul" {
    code {
        // Contract Deployment
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code{
            // function dispatcher
            switch selector()
            // updateHorseNumber(uint256)
            case 0xcdfead2e {
                storeNumber(decodeAsUint(0))
            }
            // readNumberOfHorses()
            case 0xe26c017 {
                returnUint(readNumber())
            }
            default {
                revert(0, 0)
            }

            function storeNumber(newNumber){
                sstore(0, newNumber)
            }

            function readNumber() -> storedNumber {
                storedNumber := sload(0)
            }

            /*-- decoding functions --*/
            function selector() -> s {
                s :=div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
            }

            function decodeAsUint(offset) -> v {
                let positionInCalldata := add(4, mul(offset, 0x20))
                if lt(calldatasize(), add(positionInCalldata, 0x20)) {
                    revert(0, 0)
                }
                v := calldataload(positionInCalldata)
            }

            function returnUint(v){
                mstore(0, v)
                return(0, 0x20)
            }
        }
    }
}