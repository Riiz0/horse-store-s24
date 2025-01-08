// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract HorseStore {
    uint256 s_numberOfHorses;

    function updateHorseNumber(uint256 newHorseNumber) external {
        s_numberOfHorses = newHorseNumber;
    }

    function readNumberOfHorses() external view returns (uint256) {
        return s_numberOfHorses;
    }
}
