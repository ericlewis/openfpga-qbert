# Q*Bert

Q*Bert arcade core for Analogue Pocket ported from MiSTer - originally created by [Pierco](https://www.patreon.com/pierco). 
It's a reproduction of the original PCBs rather than a reinterpretation but with some dual port RAM exceptions.

Additional details
------------------

**Audio board MA216:**

- SC01 is not implemented. Waiting for brave people to do it.

**NVRAM:**

- Not implemented - NVRAM should be C5/C6 on schematics.

**Ports:**

- IP17-10: input port for test buttons, coins and player 1/2.
- IP47-40: input port for joystick.
- OP27-20: output port for sound interface
- OP33-37: output port for knocker and coin meter.

Known Bugs
----------

- Problem with vertical position register E1-2. When a new object is falling from the top of the screen (ball), it appears briefly at the bottom of the screen.
- High Scores screen: the big three letters of player's name are not displayed correctly. It works well after a few resets (is it a problem with bus sharing logic which sends zeros to simulate high impedance for ORing outputs?). I don't have the PCB so it's difficult to know the original behavior.
- Votrax chip is cruelly missing, QBert needs his @!#?@! voice!!!