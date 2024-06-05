// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract HorseStore {
    uint256 s_horseNumber;

    function updateHorseNumber(uint256 newHorseNumber) external {
        s_horseNumber = newHorseNumber;
    }

    function getHorseNumber() public view returns (uint256) {
        return s_horseNumber;
    }
}
