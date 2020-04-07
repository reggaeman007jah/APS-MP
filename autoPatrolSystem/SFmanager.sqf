
// Script to manage the flow of new reinforcements in the mission
// using set and getVariables to control whether new units should be created (for pickup)
// prevents endless cycles of new pickup tasks
// idea - when units are created for pickup, setVariable on player to "busy"
// when checking whether to make new RF, check ^^ is busy?
// if yes, then, do nothing, if no, then check troop numbers, and create new task if necessary