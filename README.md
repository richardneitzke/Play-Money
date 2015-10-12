<div align="center"><img src ="http://i.imgur.com/4PYP96i.png" /> <br> <br> <h1>Play Money for iOS </h1> <h3> A Money-Manager for Board Games </h3></div>
<br> 


### Screenshots

<table align="center" border="0">

<tr>
<td> <img src="http://i.imgur.com/dQqZZRE.jpg"> </td>
<td> <img src="http://i.imgur.com/Gwm985R.jpg"> </td>
</tr>

<tr> <td align="center">Bank (Main View)</td> <td align="center">Player Menu</td> </tr>

<tr>
<td> <img src="http://i.imgur.com/nHkM7aL.jpg"> </td>
<td> <img src="http://i.imgur.com/wsN2SWF.jpg"> </td>
</tr>

<tr> <td align="center">Transfering Money</td> <td align="center">Adding a Player</td> </tr>


</table>

### Features

* Overview over all Players with Name, Token and Balance
* Player Menu (opens when a Player was touched):
  * Quick add $200
  * Quick Transfer Money
  * Rename Players
  * Delete Players
* Transfer Money from one Player to another
* Add a Player with a custom balance and assign a Token to him

### Used Framework for Storage-Persistence

Play-Money persists it's Player Data with a Model which manages all Players and uses a Realm to save them. Only the Model writes and reads directly to the Realm to make changes to the process easier.

### Notes by Developer

Because of the fact that it is working but not finished yet, the code could still be repetitive at some points.
Please feel free to file bugs, fix problems or contribute elsewise by opening issues or a pull request.
